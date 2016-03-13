object Form2: TForm2
  Left = 389
  Top = 186
  Width = 573
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
    Top = 129
    Width = 565
    Height = 319
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
    Width = 565
    Height = 129
    Align = alTop
    TabOrder = 1
    DesignSize = (
      565
      129)
    object Label3: TLabel
      Left = 8
      Top = 8
      Width = 67
      Height = 13
      Caption = 'Default Printer'
    end
    object Label1: TLabel
      Left = 8
      Top = 75
      Width = 59
      Height = 13
      Caption = 'Temp Folder'
    end
    object lblTmpFolder: TLabel
      Left = 96
      Top = 75
      Width = 60
      Height = 13
      Caption = 'lblTmpFolder'
    end
    object Label4: TLabel
      Left = 8
      Top = 32
      Width = 30
      Height = 13
      Caption = 'Kertas'
      FocusControl = btnClose
    end
    object Label2: TLabel
      Left = 8
      Top = 54
      Width = 26
      Height = 13
      Caption = 'Fonts'
      Visible = False
    end
    object btnClose: TBitBtn
      Left = 489
      Top = 99
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkClose
    end
    object btnPrint: TBitBtn
      Left = 413
      Top = 99
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Print'
      TabOrder = 1
      OnClick = btnPrintClick
    end
    object btnOpenFile: TBitBtn
      Left = 291
      Top = 99
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Open Text File'
      TabOrder = 2
      OnClick = btnOpenFileClick
    end
    object btnStart: TBitBtn
      Left = 8
      Top = 99
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 3
      OnClick = btnStartClick
    end
    object btnStop: TBitBtn
      Left = 85
      Top = 99
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 4
      OnClick = btnStopClick
    end
    object btnFolder: TBitBtn
      Left = 487
      Top = 65
      Width = 77
      Height = 25
      Caption = 'Get Folder'
      TabOrder = 5
      OnClick = btnFolderClick
    end
    object cboPrinters: TComboBox
      Left = 96
      Top = 5
      Width = 369
      Height = 21
      Style = csDropDownList
      Enabled = False
      ItemHeight = 13
      TabOrder = 6
      OnChange = cboPrintersChange
    end
    object btnPrinter: TBitBtn
      Left = 489
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Printer Setup'
      TabOrder = 7
      OnClick = btnPrinterClick
    end
    object cboPaper: TComboBox
      Left = 96
      Top = 29
      Width = 177
      Height = 21
      Style = csDropDownList
      Enabled = False
      ItemHeight = 13
      TabOrder = 8
      OnChange = cboPrintersChange
    end
    object cboFonts: TComboBox
      Left = 96
      Top = 51
      Width = 177
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 9
      Visible = False
      OnChange = cboPrintersChange
    end
    object chkCondensed: TCheckBox
      Left = 276
      Top = 32
      Width = 97
      Height = 17
      Caption = 'Condensed'
      TabOrder = 10
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'PRN File|*.prn|Text File|*.txt'
    Left = 216
    Top = 105
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
    Left = 368
    Top = 192
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
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 416
    Top = 128
  end
end
