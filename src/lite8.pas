PROGRAM lite8;
(*
 * An example demonstration of fantasy-console
 * in lazarus/freepascal + allegro5.pas
 * by x2nie
 *)

(*
 * Inspired/Originally from ex_blit Lazarus/Delphi program
 * by Guillermo Martínez J.
 * https://sourceforge.net/projects/allegro-pas
 *)

(*

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
  math, api, api_helper, pas_loader, ps;

CONST
  FPS = 60;

VAR
  FontBitmap: ALLEGRO_BITMAPptr;
  //SpritesheetBmp: ALLEGRO_BITMAPptr;
  //Font: ALLEGRO_FONTptr;
  EventQueue: ALLEGRO_EVENT_QUEUEptr;
  Background, TextClr, Black, Red: ALLEGRO_COLOR;
  Timer, Counter: DOUBLE;
  Tics,LastTick : longint;
  //TextX, TextY: SINGLE;
  TheTimer1s: ALLEGRO_TIMERptr;

  _init, _update, _draw : TProc;

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
  procedure __init();
  begin
    x:=64;
    y:=64;
    //spr(0,x,y);
  end;

procedure __update();
 begin
   //if btn(ALLEGRO_KEY_LEFT) then X := X - 1;
   //if btn(ALLEGRO_KEY_RIGHT) then X := X + 1;
   //if btnp(0) then X -= 1;
   //if btnp(1) then X += 1;
   //
   //if btn(2) then Y := Y - 1;
   //if btn(3) then Y := Y + 1;
 end;

 procedure __draw();
 begin
   //cls();
   //al_put_pixel (x, y, Red);
   //print('w',x,y);
   //spr(0,x,y);
   //pset(x,y,10);
 end;



  FUNCTION BuildSpritesheetBitmap (CONST w, h: INTEGER): ALLEGRO_BITMAPptr;
  VAR
    x,y: INTEGER;
    mx, my, a, d, sat, hue: SINGLE;
    State: ALLEGRO_STATE;
    //Lock: ALLEGRO_LOCKED_REGIONptr;
    tempBmp: ALLEGRO_BITMAPptr;
  BEGIN
    //mx := w * 0.5;
    //my := h * 0.5;
    tempBmp := al_create_bitmap (w, h);
    al_store_state (State, ALLEGRO_STATE_TARGET_BITMAP);
    al_set_target_bitmap (tempBmp);
{ Ignore message:
ex_blit.pas(67,5) Note: Local variable "Lock" is assigned but never used
  It is initialized at "Init". }
  //Lock := al_lock_bitmap (tempBmp, ALLEGRO_PIXEL_FORMAT_ANY, ALLEGRO_LOCK_WRITEONLY);
  al_lock_bitmap (tempBmp, ALLEGRO_PIXEL_FORMAT_ANY, ALLEGRO_LOCK_WRITEONLY);
    FOR y := 0 TO h - 1 DO
    BEGIN
      FOR x := 0 TO w - 1 DO
      BEGIN
	//a := arctan2 (i - mx, j - my);
	//d := sqrt (power (i - mx, 2) + power (j - my, 2));
	//sat := power (1 - 1 / (1 + d * 0.1), 5);
	//hue := 3 * a * 180 / ALLEGRO_PI;
	//hue := (hue / 360 - floor (hue / 360)) * 360;
	//al_put_pixel (i, j, al_color_hsv (hue, sat, 1));
        al_put_pixel(x, y, COLORS[ mem[y*8*16+ (x)] ]);
      END;
    END;
    //al_put_pixel (0, 0, Black);
    al_unlock_bitmap (tempBmp);
    al_restore_state (State);
    result := tempBmp;
  END;



  //PROCEDURE SetXY (CONST x, y: SINGLE);
  //BEGIN
  //  TextX := x;
  //  TextY := y;
  //END;



  //PROCEDURE GetXY (OUT x, y: SINGLE);
  //BEGIN
  //  x := TextX;
  //  y := TextY;
  //END;



  //PROCEDURE Print (CONST Fmt: AL_STR; CONST Args: ARRAY OF CONST);
  //VAR
  //  th: INTEGER;
  //BEGIN
  //  th := al_get_font_line_height (Font);
  //  al_set_blender (ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
  //  al_draw_text (Font, TextClr, TextX, TextY, 0, al_str_format (Fmt, Args));
  //  TextY := TextY + th;
  //END;



  PROCEDURE StartTimer ();
  BEGIN
    Timer := Timer - al_get_time;
    Counter := Counter + 1;
  END;



  PROCEDURE StopTimer ();
  BEGIN
    Timer := Timer + al_get_time;
  END;



  FUNCTION GetFPS  (): SINGLE;
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
    x, y,fps: SINGLE;
    iw, ih {, FormatLock }: INTEGER;
    Screen, Temp: ALLEGRO_BITMAPptr;
    {  Lock: ALLEGRO_LOCKED_REGIONptr;
    Data: POINTER; }
  BEGIN
    fps := GetFPS();
    //iw := al_get_bitmap_width (SpritesheetBmp);
    //ih := al_get_bitmap_height (SpritesheetBmp);
    iw := 128;
    ih := 128;
//    al_set_blender (ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO);
    // CLS()
    //al_clear_to_color (Background);
    Screen := al_get_target_bitmap;

    //SetXY (8, 8);

  { Test 2. }
    //Print ('Screen -> Bitmap -> Screen (%.1f fps) @%d', [GetFPS(), Tics]);
    //GetXY (x, y);
    //al_draw_bitmap (SpritesheetBmp, x, y, 0);

    // al_set_new_bitmap_flags (ALLEGRO_MEMORY_BITMAP);
    // al_set_new_bitmap_flags (ALLEGRO_VIDEO_BITMAP);
    Temp := al_create_bitmap (iw, ih);
StartTimer();
//      Temp := ExampleBitmap (iw, ih);

    al_set_target_bitmap (Temp);
//al_lock_bitmap (Temp, ALLEGRO_PIXEL_FORMAT_ANY, ALLEGRO_LOCK_WRITEONLY);

    //al_clear_to_color (Red);
    //  al_draw_bitmap_region (Screen, x, y, iw, ih, 0, 0, 0);
    //al_draw_bitmap_region (SpritesheetBmp, 0,0,iw, ih, 0, 0, 0);
    //al_draw_bitmap_region (SpritesheetBmp, -60,-60,iw, ih, 0, 0, 0);
    //al_draw_bitmap_region (SpritesheetBmp, 120,120,iw, ih, 10, 10, 0);
     //al_draw_scaled_bitmap(SpritesheetBmp,0,0,iw,ih,0,0,64,64,0);



     if assigned(_draw) then
        _draw()
     //else __draw()
     else printxyc('no _draw()!',16,16,5)
         ;
     al_draw_bitmap (SpritesheetBmp, 0, 0, 0);
       //Print ('Bitmap @%2d ^%d', [ Tics, LastTick]);
       //   Print ('Bitmap',0,0);
//al_unlock_bitmap (Temp);
Printxyc(al_str_format('(%.1f fps) @%2d ^%d', [fps, Tics, LastTick]), 1, 64-10, 3);

    al_set_target_bitmap (Screen);
    //    al_draw_bitmap (Temp, x + 8 + iw, y, 0);
    al_draw_scaled_bitmap(temp,0,0,iw,ih,0,0,384,384,0);



    StopTimer();
    //SetXY (x, y + ih);
    //Print ('Bitmap -> Screen (%.1f fps) @%2d ^%d', [GetFPS(), Tics, LastTick]);
    //Print(al_str_format('Bitmap -> Screen (%.1f fps) @%2d ^%d', [GetFPS(), Tics, LastTick]), 10, 10, 1);

    al_destroy_bitmap (Temp);

  END;



  PROCEDURE Tick;

  BEGIN
    Tics := Tics + 1;
    PRIOR_KBDSTATE := CURRENT_KBDSTATE;      //save old
    al_get_keyboard_state(CURRENT_KBDSTATE); //get new

    if assigned(_update) then
       _update()
    //else   __update()
    ;
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
    //Background := al_color_name ('beige');
    //TextClr := al_color_name ('black');
    //Black := al_color_name ('black');
    //Red := al_map_rgba_f (1, 0, 0, 1);
    SpritesheetBmp := BuildSpritesheetBitmap (8*16, 24);
    Tics := 0;
    LastTick := 0;
    if assigned(_init) then
       _init()
    //else  __init()
  END;

// further read: https://lawrencebarsanti.wordpress.com/2009/11/28/introduction-to-pascal-script/

VAR
  Display: ALLEGRO_DISPLAYptr;
  TheTimer: ALLEGRO_TIMERptr;
  script : string;
  pas : TPS;
BEGIN
  //Writeln('halo bah');
  //Writeln(ErrOutput, 'halo bah2');
  script := load( 'proto2.lite.txt');
  writeln('---------');
  writeln(script);


  IF NOT al_init THEN  WriteLn (ErrOutput, 'Could not init Allegro.');

  al_install_keyboard;
  al_init_image_addon;
  al_init_font_addon;

  Display := al_create_display (384, 384);
  IF Display = NIL THEN WriteLn (ErrOutput, 'Could not create display');

  //Init;

  reset_(); //api helper

  //ps script
  pas := TPS.create(script);
  IF NOT pas.Init THEN  WriteLn (ErrOutput, 'Could not init Pascal Script!');

  IF NOT pas.GetProc('_init', _init) THEN  WriteLn (ErrOutput, 'Could not found "_init" func.');
  IF NOT pas.GetProc('_update', _update) THEN  WriteLn (ErrOutput, 'Could not found "_update" func.');
  IF NOT pas.GetProc('_draw', _draw) THEN  WriteLn (ErrOutput, 'Could not found "_draw" func.');

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
