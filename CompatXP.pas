unit CompatXP;

interface

Function InstallHook: Boolean;
procedure UnInstallHook;

implementation

uses
  Windows, SysUtils,
  AuxTypes;

const
  ReplacedCodeSize = 5;

type
  TOriginalFunc = Function(hModule: HMODULE; lpProcName: PChar): Pointer; stdcall;

var
  HookCounter:  Integer = 0;
  FunctionAddr: Pointer;
{
  first five bytes are the original code, followed by jump to an original
  function just after the changed code
}
  OrigAndRedir: packed array[0..9] of Byte;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function HookProc(hModule: HMODULE; lpProcName: PChar): Pointer; stdcall;
begin
WriteLn(Format('%x %s',[hModule,(lpProcName)]));
Result := TOriginalFunc(@OrigAndRedir)(hModule,lpProcName);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function InstallHook: Boolean;
var
  Dummy:          DWORD;
  OldProtection:  DWORD;
begin
Result := False;
If InterlockedIncrement(HookCounter) <= 1 then
  begin
    // this all assumes the original function is at least 5 bytes long
    FunctionAddr := GetProcAddress(GetModuleHandle('kernel32.dll'),'GetProcAddress');
    If VirtualProtect(@OrigAndRedir,SizeOf(OrigAndRedir),PAGE_EXECUTE_READWRITE,Dummy) and
       VirtualProtect(FunctionAddr,ReplacedCodeSize,PAGE_EXECUTE_READWRITE,OldProtection) then
      begin
        Move(FunctionAddr^,OrigAndRedir,ReplacedCodeSize);
        OrigAndRedir[ReplacedCodeSize] := $E9;  // JMP rel32
        Pointer(Addr(OrigAndRedir[ReplacedCodeSize + 1])^) :=
          Pointer((PtrInt(FunctionAddr) + ReplacedCodeSize) -
                  (PtrInt(@OrigAndRedir) + SizeOf(OrigAndRedir)));
        // change the code to JMP HookProc
        PByte(FunctionAddr)^ := $E9;
        PPtrInt(PtrUInt(FunctionAddr) + 1)^ := PtrInt(Addr(HookProc)) - PtrInt(FunctionAddr) - ReplacedCodeSize;
        If VirtualProtect(FunctionAddr,ReplacedCodeSize,OldProtection,OldProtection) then
          Result := FlushInstructionCache(GetCurrentProcess,FunctionAddr,ReplacedCodeSize);
      end;
  end
else Result := True;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure UnInstallHook;
begin
//Pointer(AddrPtr^) := OrigAddr;
end;

end.
