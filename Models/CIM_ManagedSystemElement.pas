unit CIM_ManagedSystemElement;

interface

uses
  System.SysUtils;

type
  // Managed System Elements (CIM)
  // https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/cim-managedsystemelement
  TCIM_ManagedSystemElement = class abstract
  private
    FCaption: string;
    FDescription: string;
    FInstallDate: TDateTime;
    FInstallDateValid: Boolean;
    FName: string;
    FStatus: string;
    FStatusValid: Boolean;
  public

    // A short textual description of the object.
    // Required. Max length = 64.
    property Caption: string read FCaption write FCaption;

    // A textual description of the object.
    property Description: string read FDescription write FDescription;

    // Indicates when the object was installed.
    // Lack of a value does not indicate that the object is not installed.
    // [MappingStrings {"MIF.DMTF|ComponentID|001.5"}]
    property InstallDate: TDateTime read FInstallDate write FInstallDate;
    property InstallDateValid: Boolean read FInstallDateValid write FInstallDateValid;

    // Label by which the object is known.
    property Name: string read FName write FName;

    // String that indicates the current status of the object.
    // Optional. Max length = 10.
    property Status: string read FStatus write FStatus;
    property StatusValid: Boolean read FStatusValid write FStatusValid;
  end;

implementation

end.
