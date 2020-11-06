unit api_helper;

{$mode delphi}

interface

uses
  Classes, SysUtils, Allegro5, al5color;

var
  COLORS: array[0..2] of ALLEGRO_COLOR;

implementation

initialization
  COLORS[0] := al_color_name ('black');
  COLORS[1] := al_color_name ('yellow');
  COLORS[2] := al_color_name ('blue');

end.

