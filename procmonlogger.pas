{$codepage utf8}
unit ProcMonLogger;
{$mode objfpc}{$H+}
interface

uses
  Windows;

function CTL_CODE(DeviceType, Function_, Method, Access: DWORD): DWORD;

const
  METHOD_BUFFERED = 0;
  FILE_WRITE_ACCESS = $0002;
  FILE_DEVICE_PROCMON_LOG = $00009535;


var
  g_hDevice: THandle = INVALID_HANDLE_VALUE;
  IOCTL_EXTERNAL_LOG_DEBUGOUT: DWORD;

function OpenProcessMonitorLogger: THandle;
procedure CloseProcessMonitorLogger;
function ProcMonDebugOutput(const pszOutputString: PWideChar): Boolean;

implementation

function CTL_CODE(DeviceType, Function_, Method, Access: DWORD): DWORD;
begin
  Result := (DeviceType shl 16) or (Access shl 14) or (Function_ shl 2) or Method;
end;

function OpenProcessMonitorLogger: THandle;
begin
  if g_hDevice = INVALID_HANDLE_VALUE then
  begin
    g_hDevice := CreateFileW('\\.\Global\ProcmonDebugLogger', GENERIC_WRITE, FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  end;
  Result := g_hDevice;
end;

procedure CloseProcessMonitorLogger;
begin
  if g_hDevice <> INVALID_HANDLE_VALUE then
  begin
    CloseHandle(g_hDevice);
    g_hDevice := INVALID_HANDLE_VALUE;
  end;
end;

function ProcMonDebugOutput(const pszOutputString: PWideChar): Boolean;
var
  iLen, iOutLen: DWORD;
  dwLastError: DWORD;
begin
  if not Assigned(pszOutputString) then
  begin
    SetLastError(ERROR_INVALID_PARAMETER);
    Result := False;
    Exit;
  end;

  if OpenProcessMonitorLogger <> INVALID_HANDLE_VALUE then
  begin
    iLen := Length(pszOutputString) * SizeOf(WideChar);
    Result := DeviceIoControl(g_hDevice, IOCTL_EXTERNAL_LOG_DEBUGOUT, pszOutputString, iLen, nil, 0, iOutLen, nil);

    if not Result then
    begin
      dwLastError := GetLastError;
      if dwLastError = ERROR_INVALID_PARAMETER then
      begin
        SetLastError(ERROR_WRITE_FAULT);
      end;
    end;
  end
  else
  begin
    SetLastError(ERROR_BAD_DRIVER);
    Result := False;
  end;
end;

initialization
  IOCTL_EXTERNAL_LOG_DEBUGOUT := CTL_CODE(FILE_DEVICE_PROCMON_LOG, $81, METHOD_BUFFERED, FILE_WRITE_ACCESS);

end.

