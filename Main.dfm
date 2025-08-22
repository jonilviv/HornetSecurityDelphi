object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'FormMain'
  ClientHeight = 858
  ClientWidth = 1159
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 353
    Top = 0
    Height = 858
    ExplicitLeft = 1408
    ExplicitTop = 600
    ExplicitHeight = 100
  end
  object Splitter2: TSplitter
    Left = 713
    Top = 0
    Height = 858
    ExplicitLeft = 880
    ExplicitTop = 456
    ExplicitHeight = 100
  end
  object TreeViewMain: TTreeView
    Left = 0
    Top = 0
    Width = 353
    Height = 858
    Align = alLeft
    AutoExpand = True
    HotTrack = True
    Indent = 19
    ReadOnly = True
    SortType = stText
    TabOrder = 0
    OnChange = TreeViewMainChange
    Items.NodeData = {
      070200000009540054007200650065004E006F00640065003100000000000000
      00000000FFFFFFFFFFFFFFFF000000000000000000000000000109500072006F
      0063006500730073006500730000002F0000000000000000000000FFFFFFFFFF
      FFFFFF000000000000000000000000000108530065007300730069006F006E00
      7300}
  end
  object ListViewDetails: TListView
    Left = 356
    Top = 0
    Width = 357
    Height = 858
    Align = alLeft
    Columns = <
      item
        Caption = 'Property'
        MaxWidth = 150
        MinWidth = 150
        Width = 150
      end
      item
        AutoSize = True
        Caption = 'Value'
      end>
    TabOrder = 1
    ViewStyle = vsReport
  end
  object Panel1: TPanel
    Left = 716
    Top = 0
    Width = 443
    Height = 858
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 2
    object memoMain: TMemo
      Left = 1
      Top = 1
      Width = 441
      Height = 789
      Align = alClient
      Lines.Strings = (
        'memoMain')
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object progressBarMain: TProgressBar
      Left = 1
      Top = 790
      Width = 441
      Height = 26
      Align = alBottom
      Position = 50
      Step = 1
      TabOrder = 1
    end
    object CalculateSHA256Button: TButton
      Left = 1
      Top = 816
      Width = 441
      Height = 41
      Align = alBottom
      Caption = 'Calculate SHA256'
      TabOrder = 2
      OnClick = CalculateSHA256ButtonClick
    end
  end
  object TimerMain: TTimer
    Interval = 10000
    OnTimer = TimerMainTimer
    Left = 528
    Top = 416
  end
end
