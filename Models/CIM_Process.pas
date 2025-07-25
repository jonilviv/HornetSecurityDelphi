unit CIM_Process;

interface
  uses CIM_LogicalElement, ExecutionState;

type
  // Processes (CIM)
  // https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/cim-process
  TCIM_Process = class abstract(TCIM_LogicalElement)
  private
    FCreationClassName: string;
    FCreationDate: TDateTime;
    FCreationDateValid: Boolean;

    FCSCreationClassName: string;
    FCSName: string;

    FExecutionState: TExecutionState;
    FExecutionStateValid: Boolean;

    FHandle: Cardinal;

    FKernelModeTime: Int64; // TimeSpan → 64-бітовий мілісекундний еквівалент

    FOSCreationClassName: string;
    FOSName: string;

    FPriority: Cardinal;
    FPriorityValid: Boolean;

    FTerminationDate: TDateTime;
    FTerminationDateValid: Boolean;

    FUserModeTime: Int64;
    FWorkingSetSize: UInt64;
    FWorkingSetSizeValid: Boolean;
  public
    // Name of the class or subclass used in the creation of an instance. Max length = 256.
    property CreationClassName: string read FCreationClassName write FCreationClassName;

    // Time that the process began executing.
    property CreationDate: TDateTime read FCreationDate write FCreationDate;
    property CreationDateValid: Boolean read FCreationDateValid write FCreationDateValid;

    // Scoping computer system's creation class name. Max length = 256.
    property CSCreationClassName: string read FCSCreationClassName write FCSCreationClassName;

    // Scoping computer system's name. Max length = 256.
    property CSName: string read FCSName write FCSName;

    // Current operating condition of the process.
    property ExecutionState: TExecutionState read FExecutionState write FExecutionState;
    property ExecutionStateValid: Boolean read FExecutionStateValid write FExecutionStateValid;

    // Identifies the process (process handle). Max length = 256.
    property Handle: Cardinal read FHandle write FHandle;

    // Time in kernel mode (milliseconds or 100-nanosecond units).
    property KernelModeTime: Int64 read FKernelModeTime write FKernelModeTime;

    // Scoping operating system's creation class name. Max length = 256.
    property OSCreationClassName: string read FOSCreationClassName write FOSCreationClassName;

    // Scoping operating system's name. Max length = 256.
    property OSName: string read FOSName write FOSName;

    // Urgency or importance for process execution.
    property Priority: Cardinal read FPriority write FPriority;
    property PriorityValid: Boolean read FPriorityValid write FPriorityValid;

    // Time that the process was stopped or terminated.
    property TerminationDate: TDateTime read FTerminationDate write FTerminationDate;
    property TerminationDateValid: Boolean read FTerminationDateValid write FTerminationDateValid;

    // Time in user mode (milliseconds or 100-nanosecond units).
    property UserModeTime: Int64 read FUserModeTime write FUserModeTime;

    // Amount of memory in bytes needed for efficient execution.
    property WorkingSetSize: UInt64 read FWorkingSetSize write FWorkingSetSize;
    property WorkingSetSizeValid: Boolean read FWorkingSetSizeValid write FWorkingSetSizeValid;
  end;

implementation

end.
