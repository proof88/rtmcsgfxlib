object frm_loading: Tfrm_loading
  Left = 439
  Top = 127
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 76
  ClientWidth = 264
  Color = 14872303
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnl: TPanel
    Left = 0
    Top = 0
    Width = 264
    Height = 76
    Align = alClient
    BevelInner = bvLowered
    BevelWidth = 2
    Color = 14872303
    TabOrder = 0
    object lbl_info02: TLabel
      Left = 13
      Top = 56
      Width = 238
      Height = 13
      Caption = 'Powered by Timcseee GFX library made by PR00F'
    end
    object lbl_info: TLabel
      Left = 9
      Top = 8
      Width = 228
      Height = 16
      Caption = 'Initializing graphics subsystem ...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pbar: TProgressBar
      Left = 8
      Top = 32
      Width = 249
      Height = 17
      Min = 0
      Max = 10
      Smooth = True
      TabOrder = 0
    end
  end
end
