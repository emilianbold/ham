@echo off
set PATH="%~dp0";"%~dp0\nt-x86"
REM !! DO NOT add quotes below !!
set HAM_HOME=%~dp0\..
"%~dp0\nt-x86\bash.exe" "%~dp0\ham-grep" --no-heading --color never %*
