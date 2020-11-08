unit pas_loader;

{$mode delphi}

interface

uses
  Classes,
  SysUtils;

function load(name:string):string;



implementation

uses api_helper;

function load(name:string):string;
type TMode = (script,sprite,none);
var 
   mode : TMode;
   t,d : TStringList;
   i,y,x : integer;
   n : byte;
   s : string;
   // in_script : boolean = false;
   // in_sprite : boolean = false;
begin
   t := TStringList.Create;
   d := TStringList.Create;
   t.LoadFromFile(name);
   y := 0;
   for i := 0 to Pred(t.Count-1) do
   begin
      if copy(t[i],1,10) = '__script__' then
         mode  := script
      else if copy(t[i],1,10) = '__sprite__' then
         mode := sprite
      else if (copy(t[i],1,2) = '__') then
         mode := none
      else if copy(t[i],1,4) = '.pas' then
         continue
      else 
         if mode = script then
         begin
            d.add(t[i])
         end
         else if mode = sprite then
         begin
            s := t[i];
            writeLn('$|','s');
            for x := 1 to Length(s) do
            begin
               n := StrToInt('$'+s[x]);
               write(IntToHex(n,1));
               mem[y*8*16+ (x-1)] := n;
               // al_put_blended_pixel(x-1, y, COLORS[n]);
               // al_put_pixel (x-1, y, COLORS[n]);
            end;
            inc(y);
         end;

   end;
   t.free;
   result := d.Text;
   d.free;
end;

end.

