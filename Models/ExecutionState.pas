unit ExecutionState;

interface

type
  // Execution state of a process (CIM_ExecutionState)
  TExecutionState = (
    esUnknown = 0,
    esOther = 1,
    esReady = 2,
    esRunning = 3,
    esBlocked = 4,
    esSuspendedBlocked = 5,
    esSuspendedReady = 6,
    esTerminated = 7,
    esStopped = 8,
    esGrowing = 9
    );

implementation

end.
