unit ps_patch;
(*
 * PascalScript Patch part.
 * Purpose: allowing user/game script of using `overload`ed procedure.
 * Description: True object pascal allow some procedure to use exactly same name
 *              with diferent parameter count, but pascalscript didn't.
 *              so this unit is a work around to solve that.
 * author: x2nie @2020-11-08
 *)

{$mode delphi}

interface

uses
   Classes, SysUtils, uPSComponent, uPSCompiler, uPSUtils;

function patch(ps:TPSScript; complain:TPSPascalCompilerMessage):boolean;


implementation

uses
   uPSRuntime;

type
   TPSExecHack = class(TPSExec);//to access protected method

const
   artinya : array[TPSPasToken] of string = (
      'EOF',

      'Comment',
      'WhiteSpace',

      'Identifier',
      'SemiColon',
      'Comma',
      'Period',
      'Colon',
      'OpenRound',
      'CloseRound',
      'OpenBlock',
      'CloseBlock',
      'Assignment',
      'Equal',
      'NotEqual',
      'Greater',
      'GreaterEqual',
      'Less',
      'LessEqual',
      'Plus',
      'Minus',
      'Divide',
      'Multiply',
      'Integer',
      'Real',
      'String',
      'Char',
      'HexInt',
      'AddressOf',
      'Dereference',
      'TwoDots',

      'and',
      'array',
      'begin',
      'case',
      'const',
      'div',
      'do',
      'downto',
      'else',
      'end',
      'for',
      'function',
      'if',
      'in',
      'mod',
      'not',
      'of',
      'or',
      'procedure',
      'program',
      'repeat',
      'record',
      'set',
      'shl',
      'shr',
      'then',
      'to',
      'type',
      'until',
      'uses',
      'var',
      'while',
      'with',
      'xor',
      'exit',
      'class',
      'constructor',
      'destructor',
      'inherited',
      'private',
      'public',
      'published',
      'protected',
      'property',
      'virtual',
      'override',
      //'default', //Birb
      'As',
      'Is',
      'Unit',
      'Try',
      'Except',
      'Finally',
      'External',
      'Forward',
      'Export',
      'Label',
      'Goto',
      'Chr',
      'Ord',
      'Interface',
      'Implementation',
      'initialization',            //* Nvds
      'finalization',              //* Nvds
      'out',
      'nil'
   );

function patch(ps:TPSScript; complain:TPSPascalCompilerMessage):boolean;
(* return true if patching success: replaced `print('h')` with `print_1('h')`
 *
 *)
//type
//  TProc = procedure of object;
//var
//  Exec: TProc;
//  m : TMethod;
type
   MyToken = record id: TPSPasToken; str: string; col: integer; end;
var
   regproc: TPSExternalProcRec;
   token  : MyTOken;
   tokens : array of MyToken;
   parser : TPSPascalParser;
   s, new_name : string;
   row,i,tk : integer;
   stack,comma,params: integer;
   patched, invalid : boolean;
begin
   patched := false;
   invalid := false;
   //writeln('##############################');
   //writeln('!!', complain.Pos,' ', complain.Row, ' ', complain.Col);
   row := complain.row-1;              //tstringlist|.row starts from 1
   s := ps.Script[row];
   //writeln(s);                         // original line
   s := copy(s,1, complain.col);            // truncate to only reported error tokens
   //writeln('>[[',s,']]<');

   //find the procedure name, then patch it
   Parser := TPSPascalParser.Create;
   stack := 0;    //bracket level
   params := 0; comma := 0;
   repeat
      //parse current line
      setLength(tokens,0);
      tk := 0;
      Parser.SetText(s);
      while parser.CurrTokenID <> CSTI_EOF do
      begin
         // writeln('@',parser.Col,' "',parser.OriginalToken,'"  `',parser.GetToken, '`   ===> ',artinya[parser.CurrTokenID]);
         // NOTE: parser is only working forward, but we only able to walk backward.
         //       so during parsing, we only save it on array & work with it later
         token.id := parser.CurrTokenID;
         token.str:= Parser.GetToken;   //auto uppercased.
         token.col:= parser.Col;
         setLength(tokens,tk+1);
         tokens[tk] := token;
         inc(tk);

         Parser.next();
      end;

      // time to find the proc name
      for tk := length(tokens)-1 downto 0 do
      begin
         token := tokens[tk];
         case token.id of
            CSTI_CloseRound : dec(stack);
            CSTI_OpenRound  : inc(stack);
            CSTI_Identifier : 
               if stack = 0 then
               begin
                  //writeln('========= we found:', token.str);
                  //writeln('========= param count:', params);
                  for i := row to complain.Row-1 do
                     writeLn(ps.Script[i]);
                  for i := 1 to complain.Col-1 do write(' ');
                  writeLn('^');
                  // test if new name is valid:
                  new_name := format('%s__%d',[token.str, params]);
                  //m := ps.GetProcMethod(new_name);
                  //writeLn('proc M:', m.Data <> nil);
                  //Exec := TProc(m);
                  //if not assigned(exec) then
                  //if m.Data = nil then
                  //if ps.Comp.FindProc(new_name) = InvalidVal then
                  //if ps.Exec.GetProc(new_name) = InvalidVal then
                  regproc:= TPSExternalProcRec.Create(nil);
                  if not TPSExecHack(ps.Exec).ImportProc(new_name, regproc) then
                  begin
                     invalid := true;
                     writeLn('Failed to patch with new proc name:',new_name);
                     regproc.Free;
                     break;
                  end;
                  regproc.Free;
                  // patching:
                  delete(s, token.col, length(token.str));
                  insert(new_name, s, token.col);
                  ps.Script[row] := s;
                  patched := true;

                  // log:
                  writeLn('>> Patch successful:');
                  for i := row to complain.Row-1 do
                     writeLn(ps.Script[i]);
                  writeLn();
               end;
            
            CSTI_Comma : 
               if stack = -1 then inc(comma);
            
            else 
               if (stack = -1 (*inside proc*)) and (params=comma ) then
               begin
                  inc(params)
               end;
         end;
         //writeln('@',token.Col,' "',token.str,'"  [',comma,'/',params ,'] ===> ',artinya[token.id]);
      end;


      dec(row);
      if row < 0 then
         break
      else
         s := ps.Script[row];


   until patched or invalid;

   result := patched;
end;

end.

