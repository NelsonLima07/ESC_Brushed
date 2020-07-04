object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'CalibracaReciverRC'
  ClientHeight = 350
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 32
    Width = 369
    Height = 73
    TabOrder = 0
    object v: TLabel
      Left = 13
      Top = 8
      Width = 20
      Height = 13
      Caption = 'Min.'
    end
    object Label1: TLabel
      Left = 301
      Top = 8
      Width = 24
      Height = 13
      Caption = 'Max.'
    end
    object Label2: TLabel
      Left = 136
      Top = 55
      Width = 97
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TrackBar1: TTrackBar
      Left = 81
      Top = 23
      Width = 206
      Height = 26
      TabOrder = 0
    end
    object SpinEdit1: TSpinEdit
      Left = 13
      Top = 27
      Width = 54
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object SpinEdit2: TSpinEdit
      Left = 301
      Top = 27
      Width = 54
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 106
    Width = 369
    Height = 73
    TabOrder = 1
    object Label3: TLabel
      Left = 13
      Top = 8
      Width = 20
      Height = 13
      Caption = 'Min.'
    end
    object Label4: TLabel
      Left = 301
      Top = 8
      Width = 24
      Height = 13
      Caption = 'Max.'
    end
    object Label5: TLabel
      Left = 136
      Top = 55
      Width = 97
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TrackBar2: TTrackBar
      Left = 81
      Top = 23
      Width = 206
      Height = 26
      TabOrder = 0
    end
    object SpinEdit3: TSpinEdit
      Left = 13
      Top = 27
      Width = 54
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object SpinEdit4: TSpinEdit
      Left = 301
      Top = 27
      Width = 54
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 180
    Width = 369
    Height = 73
    TabOrder = 2
    object Label6: TLabel
      Left = 13
      Top = 8
      Width = 20
      Height = 13
      Caption = 'Min.'
    end
    object Label7: TLabel
      Left = 301
      Top = 8
      Width = 24
      Height = 13
      Caption = 'Max.'
    end
    object Label8: TLabel
      Left = 136
      Top = 55
      Width = 97
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TrackBar3: TTrackBar
      Left = 81
      Top = 23
      Width = 206
      Height = 26
      TabOrder = 0
    end
    object SpinEdit5: TSpinEdit
      Left = 13
      Top = 27
      Width = 54
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object SpinEdit6: TSpinEdit
      Left = 301
      Top = 27
      Width = 54
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 254
    Width = 369
    Height = 73
    TabOrder = 3
    object Label9: TLabel
      Left = 13
      Top = 8
      Width = 20
      Height = 13
      Caption = 'Min.'
    end
    object Label10: TLabel
      Left = 301
      Top = 8
      Width = 24
      Height = 13
      Caption = 'Max.'
    end
    object Label11: TLabel
      Left = 136
      Top = 55
      Width = 97
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TrackBar4: TTrackBar
      Left = 81
      Top = 23
      Width = 206
      Height = 26
      TabOrder = 0
    end
    object SpinEdit7: TSpinEdit
      Left = 13
      Top = 27
      Width = 54
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object SpinEdit8: TSpinEdit
      Left = 301
      Top = 27
      Width = 54
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
  end
  object Button1: TButton
    Left = 2
    Top = 2
    Width = 75
    Height = 25
    Caption = 'Config...'
    TabOrder = 4
  end
  object ComPort1: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = True
    Left = 392
    Top = 16
  end
end
