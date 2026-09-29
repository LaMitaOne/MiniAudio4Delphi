object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object lblstatus: TLabel
    Left = 56
    Top = 376
    Width = 44
    Height = 15
    Caption = 'lblstatus'
  end
  object btnLeft: TButton
    Left = 40
    Top = 80
    Width = 75
    Height = 25
    Caption = 'left'
    TabOrder = 0
    OnClick = btnLeftClick
  end
  object btnCenter: TButton
    Left = 240
    Top = 48
    Width = 75
    Height = 25
    Caption = 'center'
    TabOrder = 1
    OnClick = btnCenterClick
  end
  object btnRight: TButton
    Left = 464
    Top = 80
    Width = 75
    Height = 25
    Caption = 'right'
    TabOrder = 2
    OnClick = btnRightClick
  end
  object btnInit: TButton
    Left = 40
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Init'
    TabOrder = 3
    OnClick = btnInitClick
  end
  object btnStopFlyby: TButton
    Left = 40
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Stop flyby'
    TabOrder = 4
    OnClick = btnStopFlybyClick
  end
  object btnStartFlyby: TButton
    Left = 40
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Start flyby'
    TabOrder = 5
    OnClick = btnStartFlybyClick
  end
  object btnLoadSound: TButton
    Left = 40
    Top = 232
    Width = 75
    Height = 25
    Caption = 'load sound'
    TabOrder = 6
    OnClick = btnLoadSoundClick
  end
  object OpenDialog1: TOpenDialog
    Left = 288
    Top = 160
  end
end
