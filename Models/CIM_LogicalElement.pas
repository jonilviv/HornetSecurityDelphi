unit CIM_LogicalElement;

interface

uses
  CIM_ManagedSystemElement;

type
  // Logical Elements (CIM)
  // https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/cim-logicalelement
  TCIM_LogicalElement = class abstract(TCIM_ManagedSystemElement)
  end;

implementation

end.
