PROGRAM lite8;
(*
 * An example demonstrating different blending modes.
 *)
(*
  Copyright (c) 2012-2020 Guillermo Martínez J.

  This software is provided 'as-is', without any express or implied
  warranty. In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
 *)

{$IFDEF FPC}
  //{$IFDEF WINDOWS}{$R 'manifest.rc'}{$ENDIF}
{$ENDIF}


USES
  Allegro5, al5base, al5color, al5font, al5image, al5strings,
  math, api, pas_loader;

CONST
  FPS = 30;

VAR
  FontBitmap, Pattern: ALLEGRO_BITMAPptr;
  Font: ALLEGRO_FONTptr;
  EventQueue: ALLEGRO_EVENT_QUEUEptr;
  Background, TextClr, Black, Red: ALLEGRO_COLOR;
  Timer, Counter: DOUBLE;
  Tics,LastTick : longint;
  TextX, TextY: SINGLE;
  TheTimer1s: ALLEGRO_TIMERptr;

  // API
  //var
    //KEYS_DOWN: array[0..ALLEGRO_KEY_MAX] of boolean;

  //function btn(b:byte):boolean;
  //begin
  //  result := KEYS_DOWN[b];
  //end;

  // THE GAME CODE
  var
    x,y: integer;
  procedure _init();
  begin
    x:=64;
    y:=64;
  end;

procedure _update();
 begin
   //if btn(ALLEGRO_KEY_LEFT) then X := X - 1;
   //if btn(ALLEGRO_KEY_RIGHT) then X := X + 1;
   if btn(0) then X -= 1;
   if btn(1) then X += 1;

   if btn(2) then Y := Y - 1;
   if btn(3) then Y := Y + 1;
 end;

 procedure _draw();
 begin
   //cls();
   //al_put_pixel (x, y, Red);
   pset(x,y,1)
 end;



  FUNCTION ExampleBitmap (CONST w, h: INTEGER): ALLEGRO_BITMAPptr;
  VAR
    i, j: INTEGER;
    mx, my, a, d, sat, hue: SINGLE;
    State: ALLEGRO_STATE;
    //Lock: ALLEGRO_LOCKED_REGIONptr;
    Pattern: ALLEGRO_BITMAPptr;
  BEGIN
    mx := w * 0.5;
    my := h * 0.5;
    Pattern := al_create_bitmap (w, h);
    al_store_state (State, ALLEGRO_STATE_TARGET_BITMAP);
    al_set_target_bitmap (Pattern);
{ Ignore message:
ex_blit.pas(67,5) Note: Local variable "Lock" is assigned but never used
  It is initialized at "Init". }
  //Lock := al_lock_bitmap (Pattern, ALLEGRO_PIXEL_FORMAT_ANY, ALLEGRO_LOCK_WRITEONLY);
  al_lock_bitmap (Pattern, ALLEGRO_PIXEL_FORMAT_ANY, ALLEGRO_LOCK_WRITEONLY);
    FOR i := 0 TO w - 1 DO
    BEGIN
      FOR j := 0 TO h - 1 DO
      BEGIN
	a := arctan2 (i - mx, j - my);
	d := sqrt (power (i - mx, 2) + power (j - my, 2));
	sat := power (1 - 1 / (1 + d * 0.1), 5);
	hue := 3 * a * 180 / ALLEGRO_PI;
	hue := (hue / 360 - floor (hue / 360)) * 360;
	al_put_pixel (i, j, al_color_hsv (hue, sat, 1));
      END;
    END;
    //al_put_pixel (0, 0, Black);
    al_unlock_bitmap (Pattern);
    al_restore_state (State);
    ExampleBitmap := Pattern;
  END;



  PROCEDURE SetXY (CONST x, y: SINGLE);
  BEGIN
    TextX := x;
    TextY := y;
  END;



  PROCEDURE GetXY (OUT x, y: SINGLE);
  BEGIN
    x := TextX;
    y := TextY;
  END;



  PROCEDURE Print (CONST Fmt: AL_STR; CONST Args: ARRAY OF CONST);
  VAR
    th: INTEGER;
  BEGIN
    th := al_get_font_line_height (Font);
    al_set_blender (ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
    al_draw_text (Font, TextClr, TextX, TextY, 0, al_str_format (Fmt, Args));
    TextY := TextY + th;
  END;



  PROCEDURE StartTimer ();
  BEGIN
    Timer := Timer - al_get_time;
    Counter := Counter + 1;
  END;



  PROCEDURE StopTimer ();
  BEGIN
    Timer := Timer + al_get_time;
  END;



  FUNCTION GetFPS  (inbitmap:boolean=false): SINGLE;
  BEGIN
    IF Timer = 0 THEN EXIT (0.0);
    GetFPS := Counter / Timer;
  END;


  //procedure cls();
  //begin
  //  al_clear_to_color (Background);
  //end;



  PROCEDURE Draw;
  VAR
    x, y: SINGLE;
    iw, ih {, FormatLock }: INTEGER;
    Screen, Temp: ALLEGRO_BITMAPptr;
    {  Lock: ALLEGRO_LOCKED_REGIONptr;
    Data: POINTER; }
  BEGIN
    iw := al_get_bitmap_width (Pattern);
    ih := al_get_bitmap_height (Pattern);
    al_set_blender (ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO);
    // CLS()
    al_clear_to_color (Background);
    Screen := al_get_target_bitmap;

    SetXY (8, 8);

  { Test 2. }
    //Print ('Screen -> Bitmap -> Screen (%.1f fps) @%d', [GetFPS(), Tics]);
    //GetXY (x, y);
    //al_draw_bitmap (Pattern, x, y, 0);

    // al_set_new_bitmap_flags (ALLEGRO_MEMORY_BITMAP);
    // al_set_new_bitmap_flags (ALLEGRO_VIDEO_BITMAP);
    Temp := al_create_bitmap (iw, ih);
StartTimer();
//      Temp := ExampleBitmap (iw, ih);

    al_set_target_bitmap (Temp);
//   al_clear_to_color (Red);
  //  al_draw_bitmap_region (Screen, x, y, iw, ih, 0, 0, 0);
  al_draw_bitmap_region (Pattern, 0,0,iw, ih, 0, 0, 0);
  al_draw_bitmap_region (Pattern, -60,-60,iw, ih, 0, 0, 0);
  al_draw_bitmap_region (Pattern, 120,120,iw, ih, 10, 10, 0);
     //al_draw_scaled_bitmap(Pattern,0,0,iw,ih,0,0,64,64,0);

   _draw();
       Print ('Bitmap @%2d ^%d', [ Tics, LastTick]);

    al_set_target_bitmap (Screen);
//    al_draw_bitmap (Temp, x + 8 + iw, y, 0);
    al_draw_scaled_bitmap(temp,0,0,iw,ih,0,0,384,384,0);



    StopTimer();
    //SetXY (x, y + ih);
    Print ('Bitmap -> Screen (%.1f fps) @%2d ^%d', [GetFPS(), Tics, LastTick]);

    al_destroy_bitmap (Temp);

  END;



  PROCEDURE Tick;
  BEGIN
    Tics := Tics + 1;
    _update();
    Draw;
    al_flip_display;
  END;



  PROCEDURE Run;
  VAR
    Event: ALLEGRO_EVENT;
    NeedDraw: BOOLEAN;
  BEGIN
    NeedDraw := TRUE;

    REPEAT
      IF NeedDraw AND al_is_event_queue_empty (EventQueue) THEN
      BEGIN
        Tick;
        NeedDraw := FALSE;
      END;
      al_wait_for_event (EventQueue, @Event);
      CASE Event.ftype OF
        ALLEGRO_EVENT_DISPLAY_CLOSE:
          EXIT;
        ALLEGRO_EVENT_KEY_DOWN:
          begin
            IF Event.keyboard.keycode = ALLEGRO_KEY_ESCAPE THEN
              EXIT;
            //KEYS_DOWN[Event.keyboard.keycode] := true;

          end;
        //ALLEGRO_EVENT_KEY_UP:
          //begin
            //KEYS_DOWN[Event.keyboard.keycode] := False;
          //end;
        ALLEGRO_EVENT_TIMER:
        begin
          if Event.timer.source = TheTimer1s then
          begin
            LastTick := Tics;
            Tics := 0;
          end
          else
             NeedDraw := TRUE;
        end;
      END;
      //_update()
    UNTIL FALSE;
  END;



  PROCEDURE Init;
  var
    Ranges: ARRAY [0..1] OF LONGINT = (32,126);
  BEGIN
    //Font := al_load_font ('data/fixed_font.tga', 0, 0);
    //IF Font = NIL THEN
       //WriteLn (ErrOutput, 'data/fixed_font.tga not found');
    FontBitmap := al_load_bitmap ('data/font-3x5.png');
    IF FontBitmap = NIL THEN WriteLn (ErrOutput, 'Failed to load font-3x5.png.');
    Font := al_grab_font_from_bitmap (FontBitmap, 1, Ranges);
    Background := al_color_name ('beige');
    TextClr := al_color_name ('black');
    Black := al_color_name ('black');
    Red := al_map_rgba_f (1, 0, 0, 1);
    Pattern := ExampleBitmap (128, 128);
    Tics := 0;
    LastTick := 0;
    _init();
  END;

// further read: https://lawrencebarsanti.wordpress.com/2009/11/28/introduction-to-pascal-script/

VAR
  Display: ALLEGRO_DISPLAYptr;
  TheTimer: ALLEGRO_TIMERptr;
  pas : string;
BEGIN
  Writeln('halo bah');
  Writeln(ErrOutput, 'halo bah2');
  pas := load( 'proto1.lite.txt');
  write(pas);

  IF NOT al_init THEN  WriteLn (ErrOutput, 'Could not init Allegro.');

  al_install_keyboard;
  al_init_image_addon;
  al_init_font_addon;

  Display := al_create_display (384, 384);
  IF Display = NIL THEN WriteLn (ErrOutput, 'Could not create display');

  Init;

  TheTimer := al_create_timer (1 / FPS);
  TheTimer1s := al_create_timer (1);

  EventQueue := al_create_event_queue;
  al_register_event_source (EventQueue, al_get_keyboard_event_source);
  al_register_event_source (EventQueue, al_get_display_event_source (Display));
  al_register_event_source (EventQueue, al_get_timer_event_source (TheTimer));
  al_register_event_source (EventQueue, al_get_timer_event_source (TheTimer1s));
  al_start_timer (TheTimer);
  al_start_timer (TheTimer1s);
  Run;

  al_destroy_event_queue (EventQueue);
END.
