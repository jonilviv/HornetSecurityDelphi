unit Main;

interface

uses
  MainView,
  SessionInfo,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  System.Variants,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.WinXCtrls,
  Vcl.Grids,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Winapi.Windows,
  Winapi.Messages,
  Win32_Process;

type
  TFormMain = class(TForm, IMainView)
    TreeViewMain: TTreeView;
    Splitter1: TSplitter;
    DrawGrid1: TDrawGrid;
    Splitter2: TSplitter;
    Panel1: TPanel;
    memoMain: TMemo;
    progressBarMain: TProgressBar;
    CalculateSHA256Button: TButton;
    TimerMain: TTimer;

    procedure TimerMainTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CalculateSHA256ButtonClick(Sender: TObject);
  private
    FOnTimerTick: TTimerTickEvent;
    FOnCalculateSHA256: TCalculateSHA256Event;
    FProcessRootNode: TTreeNode;
    FSessionsRootNode: TTreeNode;
  public
    procedure SetOnTimerTick(const AHandler: TTimerTickEvent);
    procedure SetOnCalculateFilesHash256(const AHandler: TCalculateSHA256Event);

    // Progress Bar
    procedure ResetProgressBar;
    procedure InitProgressBar(MaxValue: Integer);
    procedure IncrementProgressBar(Progress: Integer);

    // Text
    procedure ResetText;
    procedure AddTextLine(const TextLine: string);

    // Buttons
    procedure DisableCalculateSHA256Button;
    procedure EnableCalculateSHA256Button;

    // TreeView update
    procedure SetProcessesNodes(processes: TArray<TWin32_Process>);
    procedure SetSessionsNodes(sessions: TArray<TSessionInfo>);

    // Property grid / inspector
    procedure SetProperty(const SelectedObject: TObject);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FProcessRootNode := TreeViewMain.Items[0];
  FSessionsRootNode := TreeViewMain.Items[1];
end;

procedure TFormMain.SetOnTimerTick(const AHandler: TTimerTickEvent);
begin
  FOnTimerTick := AHandler;
end;

procedure TFormMain.TimerMainTimer(Sender: TObject);
begin
  if Assigned(FOnTimerTick)
  then
    FOnTimerTick;
end;

// Progress Bar
procedure TFormMain.ResetProgressBar();
begin
  progressBarMain.Position := 0;
end;

procedure TFormMain.InitProgressBar(MaxValue: Integer);
begin
  progressBarMain.Max := MaxValue;
end;

procedure TFormMain.IncrementProgressBar(Progress: Integer);
begin
  progressBarMain.StepIt();
end;

// Text
procedure TFormMain.ResetText;
begin
  memoMain.Lines.Clear();
  Application.ProcessMessages;
end;

procedure TFormMain.AddTextLine(const TextLine: string);
begin
  memoMain.Lines.Add(TextLine);
  Application.ProcessMessages;
end;

// Buttons
procedure TFormMain.SetOnCalculateFilesHash256(const AHandler: TCalculateSHA256Event);
begin
  FOnCalculateSHA256 := AHandler;
end;

procedure TFormMain.CalculateSHA256ButtonClick(Sender: TObject);
begin
  if Assigned(FOnCalculateSHA256)
  then
    FOnCalculateSHA256;
end;

procedure TFormMain.DisableCalculateSHA256Button;
begin
  CalculateSHA256Button.Enabled := False;
end;

procedure TFormMain.EnableCalculateSHA256Button;
begin
  CalculateSHA256Button.Enabled := True;
end;

// TreeView update

procedure TFormMain.SetProcessesNodes(processes: TArray<TWin32_Process>);
var
  parentNode, newNode: TTreeNode;
  process: TWin32_Process;
  processMap: TDictionary<UInt32, TWin32_Process>;
  nodeMap: TDictionary<UInt32, TTreeNode>;
begin
  FProcessRootNode.DeleteChildren();

  processMap := TDictionary<UInt32, TWin32_Process>.Create;
  nodeMap := TDictionary<UInt32, TTreeNode>.Create;

  try
    for process in processes do
      begin
        if process.ProcessId <> 0
        then
          processMap.AddOrSetValue(process.ProcessId, process)
      end;

    for process in processes do
      begin
        if processMap.ContainsKey(process.ParentProcessId) and nodeMap.TryGetValue(process.ParentProcessId, parentNode)
        then
          newNode := TreeViewMain.Items.AddChild(parentNode, process.Name)
        else
          newNode := TreeViewMain.Items.AddChild(FProcessRootNode, process.Name);

        nodeMap.AddOrSetValue(process.ProcessId, newNode);
      end;
  finally

    processMap.Free;
    nodeMap.Free;
  end;

  // TreeViewMain.FullExpand;
  // TreeViewMain.Update;
end;

procedure TFormMain.SetSessionsNodes(sessions: TArray<TSessionInfo>);
var
  session: TSessionInfo;
  s: string;
begin
  FSessionsRootNode.DeleteChildren();
  s := FSessionsRootNode.Text;

  for session in sessions do
    begin
      TreeViewMain.Items.AddChild(FSessionsRootNode, session.SessionId.ToString);
    end;
end;

// Property grid / inspector
procedure TFormMain.SetProperty(const SelectedObject: TObject);
begin

end;

end.
