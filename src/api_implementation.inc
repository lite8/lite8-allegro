USES
  SysUtils {format string},
  Allegro5, al5base, api_helper,al5font;

{$mode delphi}

function btn(keycode:byte):boolean;
var //keyState: ALLEGRO_KEYBOARD_STATE;
  kbd: al_int; // allegro known keyboard key
  i : integer;
begin
  case keycode of
    0 : kbd := ALLEGRO_KEY_LEFT;
    1 : kbd := ALLEGRO_KEY_RIGHT;
    2 : kbd := ALLEGRO_KEY_UP;
    3 : kbd := ALLEGRO_KEY_DOWN;

    //debug

    10 : kbd := ALLEGRO_KEY_PGUP;
    11 : kbd := ALLEGRO_KEY_PGDN;
    12 : kbd := ALLEGRO_KEY_PAD_MINUS;
    13 : kbd := ALLEGRO_KEY_PAD_PLUS;

    else kbd := -1;
  end;
  // Check keyboard input
  //al_get_keyboard_state(keyState);
  //result := al_key_down(keyState, kbd);
  result := al_key_down(CURRENT_KBDSTATE, kbd)
  {write('btn',keycode,' ',length(keyState.__key_down__internal__));
  for i := 0 to length(keyState.__key_down__internal__)-1 do
      write(' ',keyState.__key_down__internal__[i]);
  writeln(result)}
end;

function btnp(keycode:byte):boolean;
var
  kbd: al_int; // allegro known keyboard key
begin
  case keycode of
    0 : kbd := ALLEGRO_KEY_LEFT;
    1 : kbd := ALLEGRO_KEY_RIGHT;
    2 : kbd := ALLEGRO_KEY_UP;
    3 : kbd := ALLEGRO_KEY_DOWN;
  end;
  result := al_key_down(CURRENT_KBDSTATE, kbd) and not al_key_down(PRIOR_KBDSTATE, kbd) ;
end;

procedure color(colour:byte);
begin
  CURRENT_COLOR := colour;
end;

procedure pset(x,y, color:byte);
begin
  //al_put_pixel (x, y, COLORS[color]);
  al_put_blended_pixel(x, y, COLORS[color]);
end;

procedure printxyc(txt:string; x,y: integer; color:byte);
begin
  CURRENT_COLOR := color;
  printxy(txt,x,y);
end;

procedure printxy(txt:string; x,y: integer); //overload;
begin
  TextX := x;
  TextY := y;
  print(txt);

  //printxyc(txt, x, Y, CURRENT_COLOR)
end;

procedure print(txt:string); //overload;
var
    th: INTEGER;
begin
  //printxyc(txt, TextX, TextY, CURRENT_COLOR)
  th := al_get_font_line_height (Font);
  al_set_blender (ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
  al_draw_text (Font, COLORS[CURRENT_COLOR], TextX, TextY, 0, txt);
  TextY := TextY + th+1;
  //writeln('mem:',mem[0],', ',mem[1]);
end;


procedure spr_old_working_imp(n,x,y: byte);  // n = 16
var e,j,xs,ys,c : byte;
    AC: single;
begin
  xs := n mod 16;
  ys := n div 16;
  for j := 0 to 7 do
  begin
    for e:= 0 to 7 do
    begin
      c := mem[(xs* 16*8) + e + (ys*16*8*8) + (j*16*8)];
      pset(x+e,y+j, c);
      //write(c,' ');
      //write(format('%-2.2f, %-2.2f, %-2.2f, %-2.2f', [colors[c].r, colors[c].g, colors[c].b, colors[c].a]),' ')
    end;
    //writeln;
  end;
  //writeln;
end;

procedure spr(n,x,y: byte);  // n = 16
var xs,ys : byte;
begin
  xs := n mod 16;
  ys := n div 16;
  al_draw_bitmap_region(SpritesheetBmp, xs*8, ys*8, 8,8, x,y, 0);
end;

procedure cls();
begin
  al_clear_to_color (COLORS[CURRENT_COLOR]);
end;

procedure clsc(color:byte);
begin
  CURRENT_COLOR := color;
  cls()
end;

function time():double;
begin
  result := Time_;
end;

end.
