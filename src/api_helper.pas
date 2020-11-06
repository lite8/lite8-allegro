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
  Classes, SysUtils, Allegro5, al5color;

var
  COLORS: array[0..2] of ALLEGRO_COLOR;
  CURRENT_KBDSTATE : ALLEGRO_KEYBOARD_STATE;    //this frame only
  PRIOR_KBDSTATE   : ALLEGRO_KEYBOARD_STATE;    //prior frame

implementation

initialization
  COLORS[0] := al_color_name ('black');
  COLORS[1] := al_color_name ('yellow');
  COLORS[2] := al_color_name ('blue');

end.

