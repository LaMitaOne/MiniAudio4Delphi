unit Unit1;

{==============================================================================*
 *  MiniAudio4Delphi - Demo Application
 *------------------------------------------------------------------------------
 *  This unit demonstrates the basic usage of the MiniAudio4Delphi wrapper.
 *  It shows how to dynamically allocate memory for the engine and sounds,
 *  how to initialize them, and how to play audio files with basic panning.
 *==============================================================================}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, MiniAudio4Delphi;

type
  TForm1 = class(TForm)
    btnLeft: TButton;
    btnCenter: TButton;
    btnRight: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnCenterClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
  private
    Engine: ma_engine; // Internally an untyped Pointer
    Sound: ma_sound;   // Internally an untyped Pointer
    procedure PlayPan(Pan: Single);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  Result: Integer;
begin
  Caption := 'MiniAudio Wrapper Test';

  // 1. Dynamically allocate the exact memory size required by the C structs
  // This avoids porting massive internal C headers to Delphi.
  GetMem(Engine, ma_engine_sizeof());
  GetMem(Sound, ma_sound_sizeof());

  // 2. Initialize the Audio Engine (Pass the allocated memory directly)
  Result := ma_engine_init(nil, Engine);
  if Result <> MA_SUCCESS then
    ShowMessage('Failed to initialize Audio Engine! Error Code: ' + IntToStr(Result));
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // Clean up before exiting
  if Sound <> nil then
    ma_sound_uninit(Sound);

  if Engine <> nil then
  begin
    ma_engine_uninit(Engine);

    // Free the dynamically allocated memory
    FreeMem(Sound);
    FreeMem(Engine);
  end;
end;

procedure TForm1.PlayPan(Pan: Single);
var
  Result: Integer;
  FilePath: string;
begin
  // Note: Adjust this path to point to a valid audio file on your system
  FilePath := 'D:\test.wav';
  if not FileExists(FilePath) then
  begin
    ShowMessage('test.wav not found!');
    Exit;
  end;

  // Important: Uninit the previous sound before loading a new one
  ma_sound_uninit(Sound);

  // Load sound from file
  Result := ma_sound_init_from_file(Engine, PAnsiChar(AnsiString(FilePath)), 0, nil, nil, Sound);
  if Result <> MA_SUCCESS then
  begin
    ShowMessage('Could not load sound! Error Code: ' + IntToStr(Result));
    Exit;
  end;

  // Set Panning (-1.0 = Left, 0.0 = Center, 1.0 = Right)
  ma_sound_set_pan(Sound, Pan);

  // Set Volume to 100%
  ma_sound_set_volume(Sound, 1.0);

  // Play!
  ma_sound_start(Sound);
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

end.
