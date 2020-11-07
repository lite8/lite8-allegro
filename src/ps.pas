unit ps;
(*
 * PascalScript.
 * this unit provide a bridge between user/game script and this pascal program
 * In the end the program only need 3 procedures: _init, _update, _draw.
 * author: x2nie @2020-11-06
 *)

{$mode delphi}

interface

uses
  Classes, SysUtils, uPSComponent,uPSCompiler;

type

  { TPS }

  TProc = procedure of object;                //https://gist.github.com/ik5/2950789

  TPS = class
    protected
      FScr : TPSScript;
      procedure OnCompile(Sender: TPSScript);
    public
      constructor Create(s:string);
      destructor Destroy; override;
      function Init: boolean;
      function GetProc(name:string; var proc:TProc): boolean;
  end;

implementation

uses
  uPSUtils,api;

procedure learning_errorcode(s:string);
const artinya : array[TPSPasToken] of string = (
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
var parser : TPSPascalParser;
begin
  Parser := TPSPascalParser.Create;
  Parser.SetText(s);
  while parser.CurrTokenID <> CSTI_EOF do
  begin
     writeln('@',parser.Col,' "',parser.OriginalToken,'"  `',parser.GetToken, '`   ===> ',artinya[parser.CurrTokenID]);
    Parser.next();
  end;
end;

{ TPS }

procedure TPS.OnCompile(Sender: TPSScript);
begin
   Sender.AddFunction(@cls,  'procedure cls(color: byte);');
   Sender.AddFunction(@pset, 'procedure pset(x,y, color:byte)');
   Sender.AddFunction(@btn,  'function  btn(keycode:byte):boolean');
  //  Sender.AddFunction(@printxyc, 'procedure print(txt:string; x,y: integer; color:byte); overload;');
  //  Sender.AddFunction(@printxy, 'procedure print(txt:string; x,y: integer); overload;');
  //  Sender.AddFunction(@print, 'procedure print(txt:string); overload;');

   //Sender.AddFunction(@print, 'procedure print(txt:string);');
   Sender.AddFunction(@printxyc, 'procedure print(txt:string; x,y: integer; color:byte);');
end;

constructor TPS.Create(s: string);
begin
  FScr:= TPSScript.Create(nil);
  FScr.Script.Text:= s;
  FScr.OnCompile:= OnCompile;
end;

destructor TPS.Destroy;
begin
  FScr.Free;
  inherited Destroy;
end;

function TPS.Init: boolean;
var i : integer;
  err : TPSPascalCompilerMessage;
  s : string;
begin
  result := FScr.compile();
  //try
  //  result := FScr.compile()
  //except
  //  //on E : EMyLittleException do writeln(E.Message);
  //  on E : TPSPascalCompilerError do
  //         //writeln('This is not my exception!');
  //         begin
  //
  //         end
  //  else raise;      //writeln('This is not an Exception-descendant at all!');
  //end;
  if FScr.CompilerMessageCount > 0 then
     for i:= 0 to FScr.CompilerMessageCount-1 do
     begin
        Writeln('>>' +FScr.CompilerErrorToStr(i));
        if (FScr.CompilerMessages[i] is TPSPascalCompilerError)
        and (TPSPascalCompilerError(FScr.CompilerMessages[i]).Error = ecInvalidnumberOfParameters)
        then
        begin
          err := FScr.CompilerMessages[i];
          writeln('!!', err.Pos,' ', err.Row, ' ', err.Col);
          s := FSCr.Script[err.row-1];        //row starts from 1
          writeln(s);                         // original line
          s := copy(s,1, err.col);            // truncate to only reported error tokens
          writeln('>[[',s,']]<');
          learning_errorcode(s);
        end;
     end;
end;

function TPS.GetProc(name: string; var proc: TProc): boolean;
var m : TMethod;
begin
  m := FScr.GetProcMethod(name);
  proc        := TProc(m);
  Result      := Assigned(proc);
end;


end.

