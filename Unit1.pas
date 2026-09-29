unit Unit1;

{==============================================================================*
 *  MiniAudio4Delphi - Ultimate Demo Application
 *------------------------------------------------------------------------------
 *  This unit demonstrates the capabilities of the MiniAudio4Delphi wrapper.
 *  It is the first complete Delphi wrapper for the miniaudio library.
 *
 *  Features Demonstrated:
 *  1. Dynamic memory allocation for massive C-structs via ma_*_sizeof().
 *  2. Basic 2D Panning (Left, Center, Right) using simple playback.
 *  3. Advanced 3D Spatial Audio (HRTF) Flyby using a background thread.
 *  4. High-precision timer (TStopwatch/QPC) for frame-exact 3D updates.
 *==============================================================================}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, MiniAudio4Delphi, System.Diagnostics, System.SyncObjs, Winapi.MMSystem;

type
  TForm1 = class(TForm)
    btnInit: TButton;
    btnLoadSound: TButton;
    btnLeft: TButton;
    btnCenter: TButton;
    btnRight: TButton;
    btnStartFlyby: TButton;
    btnStopFlyby: TButton;
    OpenDialog1: TOpenDialog;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure btnLoadSoundClick(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnCenterClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure btnStartFlybyClick(Sender: TObject);
    procedure btnStopFlybyClick(Sender: TObject);
  private
    Engine: ma_engine;
    Sound: ma_sound;
    FAudioThread: TThread;
    FLock: TCriticalSection;
    FIsPlaying: Boolean;

    procedure PlayPan(Pan: Single);
    procedure StartFlybyThread;
    procedure StopFlybyThread;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

{ ==============================================================================
  INITIALIZATION & CLEANUP
  ============================================================================== }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := 'MiniAudio4Delphi - Ultimate Demo';
  Engine := nil;
  Sound := nil;
  FLock := TCriticalSection.Create;
  FIsPlaying := False;
  lblStatus.Caption := 'Ready. Initialize Audio Engine first.';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  StopFlybyThread;
  if Sound <> nil then
  begin
    ma_sound_uninit(Sound);
    FreeMem(Sound);
  end;
  if Engine <> nil then
  begin
    ma_engine_uninit(Engine);
    FreeMem(Engine);
  end;
  FreeAndNil(FLock);
end;

{ ==============================================================================
  AUDIO ENGINE INIT
  ============================================================================== }

procedure TForm1.btnInitClick(Sender: TObject);
var
  Result: Integer;
begin
  // 1. Dynamically allocate the exact memory size required by the C structs
  // This avoids porting massive internal C headers to Delphi.
  GetMem(Engine, ma_engine_sizeof());

  // 2. Initialize the Audio Engine (Pass the allocated memory directly)
  Result := ma_engine_init(nil, Engine);
  if Result <> MA_SUCCESS then
  begin
    ShowMessage('Failed to initialize Audio Engine! Error Code: ' + IntToStr(Result));
    FreeMem(Engine);
    Engine := nil;
    Exit;
  end;

  // Set Listener (The "Ear") at Origin (0,0,0), looking forward (0,0,-1)
  ma_engine_listener_set_position(Engine, 0, 0, 0);
  ma_engine_listener_set_direction(Engine, 0, 0, -1);
  ma_engine_listener_set_world_up(Engine, 0, 1, 0);

  lblStatus.Caption := 'Audio Engine initialized! Listener ready.';
end;

procedure TForm1.btnLoadSoundClick(Sender: TObject);
var
  Result: Integer;
begin
  if Engine = nil then
  begin
    ShowMessage('Initialize the engine first!');
    Exit;
  end;

  OpenDialog1.Filter := 'Audio Files (*.wav;*.mp3;*.flac)|*.wav;*.mp3;*.flac';
  if OpenDialog1.Execute then
  begin
    // Allocate memory for sound struct if not already done
    if Sound = nil then
      GetMem(Sound, ma_sound_sizeof())
    else
      ma_sound_uninit(Sound); // Uninit previous before loading new

    // Load sound from file
    Result := ma_sound_init_from_file(Engine, PAnsiChar(AnsiString(OpenDialog1.FileName)), 0, nil, nil, Sound);
    if Result <> MA_SUCCESS then
    begin
      ShowMessage('Could not load sound! Error Code: ' + IntToStr(Result));
      Exit;
    end;

    // Enable spatialization for 3D audio
    ma_sound_set_spatialization_enabled(Sound, 1);
    // Loop the sound so it plays continuously during the flyby
    ma_sound_set_looping(Sound, 1);

    lblStatus.Caption := 'Sound loaded! Ready to test Pan or Flyby.';
  end;
end;

{ ==============================================================================
  2D PANNING DEMO
  ============================================================================== }

procedure TForm1.PlayPan(Pan: Single);
begin
  if Sound = nil then
  begin
    ShowMessage('Load a sound file first!');
    Exit;
  end;

  // Stop flyby if it is running to prevent thread conflicts
  StopFlybyThread;
  ma_sound_stop(Sound);

  // Reset 3D position to center for standard 2D panning
  ma_sound_set_position(Sound, 0, 0, 0);

  // Set Panning (-1.0 = Left, 0.0 = Center, 1.0 = Right)
  ma_sound_set_pan(Sound, Pan);
  // Set Volume to 100%
  ma_sound_set_volume(Sound, 1.0);

  // Play!
  ma_sound_start(Sound);
  lblStatus.Caption := 'Playing 2D Panned Sound...';
end;

procedure TForm1.btnLeftClick(Sender: TObject);
begin
  PlayPan(-1.0);
end;

procedure TForm1.btnCenterClick(Sender: TObject);
begin
  PlayPan(0.0);
end;

procedure TForm1.btnRightClick(Sender: TObject);
begin
  PlayPan(1.0);
end;

{ ==============================================================================
  3D SPATIAL AUDIO FLYBY DEMO
  ============================================================================== }

procedure TForm1.btnStartFlybyClick(Sender: TObject);
begin
  if Sound = nil then
  begin
    ShowMessage('Load a sound file first!');
    Exit;
  end;

  FIsPlaying := True;
  // Start playing the sound (it will loop)
  ma_sound_start(Sound);

  StartFlybyThread;
  lblStatus.Caption := 'Flyby running... Listen to it orbit!';
end;

procedure TForm1.btnStopFlybyClick(Sender: TObject);
begin
  StopFlybyThread;
  if Sound <> nil then
    ma_sound_stop(Sound);
  lblStatus.Caption := 'Flyby stopped.';
end;

procedure TForm1.StartFlybyThread;
begin
  if Assigned(FAudioThread) then Exit;

  // Use timeBeginPeriod to make Sleep(1) highly accurate on Windows
  timeBeginPeriod(1);

  FAudioThread := TThread.CreateAnonymousThread(
    procedure
    var
      Timer: TStopwatch;
      Freq: Int64;
      TargetTicks, NowTicks, SpinTicks: Int64;
      CurrentTime, Angle: Double;
      X, Y, Z, PitchFactor: Single;
    begin
      Timer := TStopwatch.Create;
      Timer.Reset;
      Timer.Start;
      Freq := Timer.Frequency;
      SpinTicks := (2000000 * Freq) div 1000000000; // 2ms spin window

      TargetTicks := Timer.GetTimestamp;

      // Configure Sound for Maximum 3D Impact!
      // 1. Disable distance attenuation so it stays loud at all times
      ma_sound_set_attenuation_model(Sound, ma_attenuation_model_none);
      // 2. Push base volume to 150% (Because we want spectacle!)
      ma_sound_set_volume(Sound, 1.5);
      // 3. Activate Doppler Effect (Pitch changes based on velocity towards/away from listener)
      ma_sound_set_doppler_factor(Sound, 2.0);

      while FIsPlaying do
      begin
        // Calculate time elapsed in seconds
        CurrentTime := Timer.Elapsed.TotalSeconds;

        // Calculate a tight circular path directly around the listener
        // Completes one revolution every 4 seconds (Fast orbit!)
        Angle := (CurrentTime / 4.0) * 2 * Pi;

        // 3D Coordinates:
        // X = Left/Right (Tight radius of 3 units)
        // Y = Up/Down (Slight bobbing of 1 unit)
        // Z = Forward/Backward (Crucial for front/back distinction)
        X := Sin(Angle) * 3.0;
        Y := Sin(Angle * 2.0) * 1.0;
        Z := Cos(Angle) * 3.0;

        // Update the sound's 3D position in the engine
        ma_sound_set_position(Sound, X, Y, Z);

        // Dynamic Pitch Shifting!
        // Let the pitch swing between 0.8x and 1.2x based on the orbit angle.
        // This creates a "Wobble" or "Hovercraft" effect as it flies around you.
        PitchFactor := 1.0 + (0.2 * Sin(Angle * 2.0));
        ma_sound_set_pitch(Sound, PitchFactor);

        // Wait for 10ms (Update 100 times per second for smooth spatialization)
        TargetTicks := TargetTicks + (Freq div 100);
        NowTicks := Timer.GetTimestamp;
        if TargetTicks <= NowTicks then
          TargetTicks := NowTicks + (Freq div 100);

        // Hybrid Sleep/Spin wait strategy (Low CPU, high precision)
        while (TargetTicks - Timer.GetTimestamp) > SpinTicks do
          Sleep(1);
        while Timer.GetTimestamp < TargetTicks do ;
      end;
    end);

  FAudioThread.FreeOnTerminate := False;
  FAudioThread.Start;
end;

procedure TForm1.StopFlybyThread;
begin
  if not Assigned(FAudioThread) then Exit;

  FIsPlaying := False;
  FAudioThread.WaitFor;
  FreeAndNil(FAudioThread);

  timeEndPeriod(1);
end;

end.
