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
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Winapi.Windows,
  Winapi.Messages,
  Winapi.Wtsapi32,
  Win32_Process;

type
  TFormMain = class(TForm, IMainView)
    TreeViewMain: TTreeView;
    Splitter1: TSplitter;
    ListViewDetails: TListView;
    Splitter2: TSplitter;
    Panel1: TPanel;
    memoMain: TMemo;
    progressBarMain: TProgressBar;
    CalculateSHA256Button: TButton;
    TimerMain: TTimer;

    procedure TimerMainTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CalculateSHA256ButtonClick(Sender: TObject);
    procedure TreeViewMainChange(Sender: TObject; Node: TTreeNode);

    procedure FormDestroy(Sender: TObject);
  private
    FOnTimerTick: TTimerTickEvent;
    FOnCalculateSHA256: TCalculateSHA256Event;
    FOnSelectionChanged: TSelectionChangedEvent;
    FProcessRootNode: TTreeNode;
    FSessionsRootNode: TTreeNode;

  type
    TNodeData = class
    public
      Kind: TNodeKind;
      Obj: TObject; // holds TWin32_Process for nkProcess
      Session: TSessionInfo; // valid for nkSession
    end;

  procedure AttachProcessNodeData(ANode: TTreeNode; const AProcess: TWin32_Process);
  procedure AttachSessionNodeData(ANode: TTreeNode; const ASession: TSessionInfo);
  procedure FreeChildrenNodeData(ARoot: TTreeNode);

  public
    procedure SetOnTimerTick(const AHandler: TTimerTickEvent);
    procedure SetOnCalculateFilesHash256(const AHandler: TCalculateSHA256Event);
    procedure SetOnTreeSelectionChanged(const AHandler: TSelectionChangedEvent);

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
    procedure ShowProperties(const rows: TArray<string>);
    procedure ClearProperties;
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

procedure TFormMain.SetOnTreeSelectionChanged(const AHandler: TSelectionChangedEvent);
begin
  FOnSelectionChanged := AHandler;
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
  TreeViewMain.Items.BeginUpdate;
  try
    FreeChildrenNodeData(FProcessRootNode);
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

          AttachProcessNodeData(newNode, process);
          nodeMap.AddOrSetValue(process.ProcessId, newNode);
        end;
    finally
      processMap.Free;
      nodeMap.Free;
    end;
  finally
    TreeViewMain.Items.EndUpdate;
  end;
end;

procedure TFormMain.SetSessionsNodes(sessions: TArray<TSessionInfo>);
var
  Session: TSessionInfo;
  s: string;
begin
  TreeViewMain.Items.BeginUpdate;
  try
    FreeChildrenNodeData(FSessionsRootNode);
    FSessionsRootNode.DeleteChildren();
    s := FSessionsRootNode.Text;

    for Session in sessions do
      begin
        AttachSessionNodeData(TreeViewMain.Items.AddChild(FSessionsRootNode, Session.SessionId.ToString), Session);
      end;
  finally
    TreeViewMain.Items.EndUpdate;
  end;
end;

// Property grid / inspector
procedure TFormMain.ShowProperties(const rows: TArray<string>);
var
  i: Integer;
  item: TListItem;
  key, value: string;
  sepPos: Integer;
begin
  ListViewDetails.Items.BeginUpdate;

  try
    ListViewDetails.Items.Clear;

    for i := Low(rows) to High(rows) do
      begin
        sepPos := rows[i].IndexOf(':');

        if sepPos > 0
        then
          begin
            key := rows[i].Substring(0, sepPos);
            value := rows[i].Substring(sepPos + 1).Trim;
          end
        else
          begin
            key := '';
            value := rows[i];
          end;

        item := ListViewDetails.Items.Add;
        item.Caption := key;

        if item.SubItems.Count = 0
        then
          item.SubItems.Add(value)
        else
          item.SubItems[0] := value;
      end;
  finally
    ListViewDetails.Items.EndUpdate;
  end;
end;

procedure TFormMain.ClearProperties;
begin
  ListViewDetails.Items.Clear;
end;

procedure TFormMain.AttachProcessNodeData(ANode: TTreeNode; const AProcess: TWin32_Process);
var
  nd: TNodeData;
begin
  nd := TNodeData.Create;
  nd.Kind := nkProcess;
  nd.Obj := AProcess;
  ANode.Data := nd;
end;

procedure TFormMain.AttachSessionNodeData(ANode: TTreeNode; const ASession: TSessionInfo);
var
  nd: TNodeData;
begin
  nd := TNodeData.Create;
  nd.Kind := nkSession;
  nd.Session := ASession;
  ANode.Data := nd;
end;

procedure TFormMain.FreeChildrenNodeData(ARoot: TTreeNode);
var
  Node: TTreeNode;
  nd: TNodeData;
begin
  Node := ARoot.getFirstChild;

  while Node <> nil do
    begin
      if Node.Data <> nil
      then
        begin
          nd := TNodeData(Node.Data);
          nd.Free;
          Node.Data := nil;
        end;

      Node := Node.getNextSibling;
    end;
end;

procedure TFormMain.TreeViewMainChange(Sender: TObject; Node: TTreeNode);
var
  nd: TNodeData;
  proc: TWin32_Process;
  sel: TTreeSelection;
begin
  if (Node = nil) or (Node = FProcessRootNode) or (Node = FSessionsRootNode) or (Node.Data = nil)
  then
    begin
      if Assigned(FOnSelectionChanged)
      then
        begin
          sel.Kind := nkNone;
          FOnSelectionChanged(sel);
        end;

      Exit;
    end;

  nd := TNodeData(Node.Data);

  case nd.Kind of
    nkProcess:
      begin
        proc := TWin32_Process(nd.Obj);

        if Assigned(FOnSelectionChanged)
        then
          begin
            sel.Kind := nkProcess;
            sel.process := proc;
            FOnSelectionChanged(sel);
          end;
      end;
    nkSession:
      begin
        if Assigned(FOnSelectionChanged)
        then
          begin
            sel.Kind := nkSession;
            sel.Session := nd.Session;
            FOnSelectionChanged(sel);
          end;
      end;
  else
    if Assigned(FOnSelectionChanged)
    then
      begin
        sel.Kind := nkNone;
        FOnSelectionChanged(sel);
      end;
  end;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FreeChildrenNodeData(FProcessRootNode);
  FreeChildrenNodeData(FSessionsRootNode);
end;

end.
