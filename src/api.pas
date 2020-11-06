unit api;

interface

//uses
  //Classes, SysUtils;

procedure cls(color:byte=0);
procedure pset(x,y, color:byte);
procedure print(txt:string; x,y: integer; color:byte); overload;
procedure print(txt:string; x,y: integer); overload;
procedure print(txt:string); overload;
function  btn(keycode:byte):boolean;          //https://pico-8.fandom.com/wiki/Btn
function  btnp(keycode:byte):boolean;         //The btnp() function is similar to btn() except that it only reports that a button is on if it was not pressed during the previous frame. In other words, it returns true only if a given button was pressed just now, and does not report true again for the same button in the next frame even if it is held down.
//function  stat(b:byte):integer;
procedure spr(n,x,y: byte);

implementation

{$INCLUDE api_implementation.inc}



