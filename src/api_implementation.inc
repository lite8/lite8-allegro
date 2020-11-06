USES
  Allegro5, al5base, api_helper;

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

procedure pset(x,y, color:byte);
begin
  al_put_pixel (x, y, COLORS[color]);
end;

procedure cls(color:byte);
begin
  al_clear_to_color (COLORS[color]);
end;



end.
