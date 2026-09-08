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
end
