unit api_helper;
(*
 * contains const,var,function
 * that is not part of api
 * but are needed to make api work properly
 * author: x2nie @2020-11-06
 *)

{$mode delphi}

interface

uses
  Classes, SysUtils, Allegro5, al5color, al5Font;

{.$X+}

// RELATED TO PICO8 =====================
var
   Mem: array [0 .. 1024*32 - 1] of Byte;
   TextX : byte absolute mem[$5f26];
   TextY : byte absolute mem[$5f27];
   CURRENT_COLOR: byte absolute mem[$5f25];

// RELATED TO ALLEGRO =====================
var
  COLORS: array[0..2] of ALLEGRO_COLOR;
  CURRENT_KBDSTATE : ALLEGRO_KEYBOARD_STATE;    //this frame only
  PRIOR_KBDSTATE   : ALLEGRO_KEYBOARD_STATE;    //prior frame
  //TextX, TextY: integer;///SINGLE;
  Font: ALLEGRO_FONTptr;


// learning --------------------------
// http://www.gnu-pascal.de/gpc/absolute.html

implementation

initialization
  //TextX:=0;
  //TextY:=0;
  fillchar(mem,sizeof(mem),0);                  //set block as all zero
  COLORS[0] := al_color_name ('black');
  COLORS[1] := al_color_name ('yellow');
  COLORS[2] := al_color_name ('blue');

end.

