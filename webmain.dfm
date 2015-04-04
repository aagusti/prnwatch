object Form2: TForm2
  Left = 389
  Top = 186
  Width = 576
  Height = 479
  Caption = 'Web2DM'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 81
    Width = 568
    Height = 367
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '--LOG--')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 568
    Height = 81
    Align = alTop
    TabOrder = 1
    DesignSize = (
      568
      81)
    object Label3: TLabel
      Left = 8
      Top = 3
      Width = 67
      Height = 13
      Caption = 'Default Printer'
    end
    object lblPrinter: TLabel
      Left = 96
      Top = 3
      Width = 30
      Height = 13
      Caption = 'Printer'
    end
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 59
      Height = 13
      Caption = 'Temp Folder'
    end
    object Label2: TLabel
      Left = 96
      Top = 24
      Width = 60
      Height = 13
      Caption = 'lblTmpFolder'
    end
    object btnClose: TBitBtn
      Left = 492
      Top = 51
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkClose
    end
    object btnPrint: TBitBtn
      Left = 416
      Top = 51
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Print'
      TabOrder = 1
      OnClick = btnPrintClick
    end
    object btnOpenFile: TBitBtn
      Left = 294
      Top = 51
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Open Text File'
      TabOrder = 2
    end
    object btnStart: TBitBtn
      Left = 8
      Top = 51
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 3
      OnClick = btnStartClick
    end
    object BitBtn1: TBitBtn
      Left = 85
      Top = 51
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 4
      OnClick = BitBtn1Click
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 97
  end
  object IdHTTPServer1: TIdHTTPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 8282
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    OnCommandGet = IdHTTPServer1CommandGet
    Left = 384
    Top = 8
  end
  object DirectoryWatch1: TDirectoryWatch
    Directory = 'C:\'
    NotifyFilters = [nfFilename, nfLastWrite]
    WatchSubDirs = False
    Active = False
    OnChange = DirectoryWatch1Change
    Left = 96
    Top = 97
  end
end
