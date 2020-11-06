unit api;

interface

//uses
  //Classes, SysUtils;

procedure cls(color:byte=0);
procedure pset(x,y, color:byte);
function  btn(keycode:byte):boolean;          //https://pico-8.fandom.com/wiki/Btn
//function  stat(b:byte):integer;

implementation

{$INCLUDE api_implementation.inc}



