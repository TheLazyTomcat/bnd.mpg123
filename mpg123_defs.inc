{$IF not(Defined(WINDOWS) or Defined(MSWINDOWS))}
  {$MESSAGE FATAL 'Unsupported operating system.'}
{$IFEND}

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
{$H+}

{
  LARGE_FILES_SUPPORT

  When defined, type off_t is an alias for off64_t and default file handling
  functions (those with no suffix) are calling _64 suffixed library functions
  (e.g. mpg123_open calls lib:mpg123_open_64).
  When not defined, off_t is declared as long and non-suffixed functions are
  calling default library functions (e.g. mpg123_open calls lib:mpg123_open).

  Defined by default.
}
{$DEFINE LARGE_FILES_SUPPORT}

{
  LEAK_WARNINGS

  Some library functions are allocating and returning buffers where caller is
  responsible for their freeing. But this cannot be done in Delphi, so calling
  such function will introduce a memory leak.
  When this symbol is defined, such functions are marked with warning messages.

  Not defined by default.  
}
{.$DEFINE LEAK_WARNINGS}
