object FConf: TFConf
  Left = 534
  Top = 195
  BorderStyle = bsToolWindow
  Caption = 'TCP-Datenausgabetest: Streckenkilometrierung'
  ClientHeight = 107
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 143
    Top = 5
    Width = 290
    Height = 94
    Caption = ' TCP-Verbindung '
    TabOrder = 0
    object laServer: TLabel
      Left = 9
      Top = 31
      Width = 34
      Height = 13
      Caption = 'Server:'
    end
    object Label5: TLabel
      Left = 9
      Top = 60
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object edServer: TEdit
      Left = 62
      Top = 29
      Width = 134
      Height = 21
      TabOrder = 0
      Text = 'localhost'
    end
    object cbPort: TComboBox
      Left = 62
      Top = 58
      Width = 134
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = '1435'
      Items.Strings = (
        '1435')
    end
  end
  object cbOnTop: TCheckBox
    Left = 5
    Top = 84
    Width = 97
    Height = 17
    Caption = 'Im Vordergrund'
    TabOrder = 1
    OnClick = cbOnTopClick
  end
  object CliSocket: TWSocket
    LineMode = False
    LineLimit = 65536
    LineEnd = #13#10
    LineEcho = False
    LineEdit = False
    Proto = 'tcp'
    LocalAddr = '0.0.0.0'
    LocalPort = '0'
    MultiThreaded = False
    MultiCast = False
    MultiCastIpTTL = 1
    ReuseAddr = False
    ComponentOptions = []
    ListenBacklog = 5
    ReqVerLow = 1
    ReqVerHigh = 1
    FlushTimeout = 60
    SendFlags = wsSendNormal
    LingerOnOff = wsLingerOn
    LingerTimeout = 0
    SocksLevel = '5'
    SocksAuthentication = socksNoAuthentication
    Left = 212
    Top = 19
  end
  object CliSocketBuffer: TCiaBuffer
    InitialSize = 4096
    SwapLen = False
    Left = 240
    Top = 19
  end
end
