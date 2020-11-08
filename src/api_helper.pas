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

   Time_ : double;

// RELATED TO ALLEGRO =====================
var
  COLORS: array[0..15] of ALLEGRO_COLOR;
  CURRENT_KBDSTATE : ALLEGRO_KEYBOARD_STATE;    //this frame only
  PRIOR_KBDSTATE   : ALLEGRO_KEYBOARD_STATE;    //prior frame
  //TextX, TextY: integer;///SINGLE;
  Font: ALLEGRO_FONTptr;


// learning --------------------------
// http://www.gnu-pascal.de/gpc/absolute.html

procedure reset_;

procedure update_time;

implementation

procedure sprite1;
const m : array[0..3,0..7] of byte = (
      (0,0,4,4, 4,4,4,0),
      (0,0,14,14, 14,14,14,0),
      (0,14,15,7, 5,15,5,0),
      (0,14,15,15, 15,15,15,0)
      );
begin
  move(m[0][0], mem[$00*8], 8);
  move(m[1][0], mem[$10*8], 8);
  move(m[2][0], mem[$20*8], 8);
  move(m[3][0], mem[$30*8], 8);
end;

procedure reset_;
var c : integer;
begin
  //TextX:=0;
  //TextY:=0;
  fillchar(mem,sizeof(mem),0);                  //set block as all zero
  COLORS[0] := al_map_rgba( 0, 0, 0, 0 ); //al_color_name ('black');
  COLORS[1] := al_map_rgb( 29, 43, 83 );
  COLORS[2] := al_map_rgb( 126, 37, 83 );
  COLORS[3] := al_map_rgba( 0, 135, 81, 255 );

  COLORS[4] := al_map_rgba( 171, 82, 54, 255 );
  COLORS[5] := al_map_rgba( 95, 87, 79, 255 );
  COLORS[6] := al_map_rgba( 194, 195, 199, 255 );
  COLORS[7] := al_map_rgba( 255, 241, 232, 255 );

  COLORS[8] := al_map_rgba( 255, 0, 77, 255 );
  COLORS[9] := al_map_rgba( 255, 163, 0, 255 );
  COLORS[10] := al_map_rgba( 255, 240, 36, 255 );
  COLORS[11] := al_map_rgba( 0, 231, 86, 255 );

  COLORS[12] := al_map_rgba( 41, 173, 255, 255 );
  COLORS[13] := al_map_rgba( 131, 118, 156, 255 );
  COLORS[14] := al_map_rgba( 255, 119, 168, 255 );
  COLORS[15] := al_map_rgba( 255, 204, 170, 255 );

  //for c := 0 to 15 do
  //    writeln(format('%-2.8f, %-2.2f, %-2.2f, %-2.2f', [colors[c].r, colors[c].g, colors[c].b, colors[c].a]),' ');

  //demo
  sprite1();

end;

procedure update_time;
var
  TS : TTimeStamp;
  MS : Comp;
begin
  //https://www.freepascal.org/docs-html/rtl/sysutils/msecstotimestamp.html
  TS:=DateTimeToTimeStamp(Now);
  MS:=TimeStampToMSecs(TS);
  Time_ := MS / 1000;
end;

initialization
  //reset_();


end.

