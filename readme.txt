Since version 1.26.0, mpg123 no longer supports Windows XP. And because this
binding was primarily created for use on this system, 1.25.13 will be the last
version supported. I will no longer maintain and develop this code, unless 
a compatibility with WinXP is resolved (not probable). 

--- mpg123 bindings ---

This is a direct translation of bindings to libmpg123 and libout123 libraries
(which are both parts of mpg123 project, more info here: https://www.mpg123.de/)
into pascal. It is written for dynamic linking and loading (DLL) and is
compatible with both Delphi and FPC.

--- files ---

Only files in root directory are direct part of this project. Files in
subdirectories were taken from mpg123 project and are therefore not my work.
They are provided only for completeness, since the binding depends on them.

--- licensing ---

All pascal files (*.pas, *.inc) are licensed under the terms of Mozilla Public
License Version 2.0 - see file license.txt.
Other files (in subdirectories) are licensed under their own licenses - see
appropriate subdirectory for readme and licensing details.

--- authors, contacts, copyright ---

©2020 František Milt, all rights reserved - frantisek.milt@gmail.com