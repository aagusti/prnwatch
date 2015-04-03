object Form1: TForm1
  Left = 249
  Top = 182
  Width = 510
  Height = 540
  Caption = 'Form1'
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
    Top = 79
    Width = 502
    Height = 430
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 502
    Height = 79
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 27
      Width = 79
      Height = 13
      Caption = 'Folder to Monitor'
    end
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
    object txtFolder: TEdit
      Left = 96
      Top = 25
      Width = 281
      Height = 21
      TabOrder = 0
      Text = 'txtFolder'
      OnChange = txtFolderChange
    end
    object Button1: TButton
      Left = 380
      Top = 21
      Width = 75
      Height = 25
      Caption = 'Set Folder'
      TabOrder = 1
      OnClick = Button1Click
    end
    object btnClose: TBitBtn
      Left = 220
      Top = 50
      Width = 75
      Height = 25
      TabOrder = 2
      OnClick = btnCloseClick
      Kind = bkClose
    end
    object btnPrint: TBitBtn
      Left = 136
      Top = 50
      Width = 75
      Height = 25
      Caption = 'Print'
      TabOrder = 3
      OnClick = btnPrintClick
    end
    object btnOpenFile: TBitBtn
      Left = 8
      Top = 50
      Width = 121
      Height = 25
      Caption = 'Open Text File'
      TabOrder = 4
      OnClick = btnOpenFileClick
    end
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
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 97
  end
end
