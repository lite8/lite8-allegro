unit pas_loader;

{$mode delphi}

interface

uses
  Classes,
  SysUtils;

function load(name:string):string;



implementation

function load(name:string):string;
var t,s : TStringList;
  i : integer;
  inside_pas : boolean = false;
begin
     t := TStringList.Create;
     s := TStringList.Create;
     t.LoadFromFile(name);
     for i := 0 to Pred(t.Count-1) do
     begin
         if copy(t[i],1,10) = '__script__' then
            inside_pas  := true
         else if copy(t[i],1,4) = '.pas' then
            continue
         else if inside_pas and (copy(t[i],1,2) = '__') then
            inside_pas := false
         else if inside_pas then
         begin
            s.add(t[i])
         end;
     end;
     t.free;
     result := s.Text;
     s.free;
end;

end.

