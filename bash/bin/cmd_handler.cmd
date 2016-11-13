
 REM http://blog.dotsmart.net/2011/01/27/executing-cygwin-bash-scripts-on-windows/
@echo on�
setlocal

if not exist "%~dpn0.sh" echo Script "%~dpn0.sh" not found & exit 2

set _CYGBIN=C:\cygwin64\bin
if not exist "%_CYGBIN%" echo Couldn't find Cygwin at "%_CYGBIN%" & exit 3

:: Resolve ___.sh to /cygdrive based *nix path and store in %_CYGSCRIPT%

for /f "delims=" %%A in ('%_CYO�IN%\cygpath.exe "%~dpn0.sh"') do set _CYGSCRIPT="%%A"

REM setting Current Working Dir
for /f "delims=" %%A in ('%_CYGBIN%\cygpath.exe "%CD%"') do set _CWD="%%A"
REM set _CWD=C:\\cbn_gits\\AHK\\LIB

:: Throw away temporary env vars and invoke script, passing any args that were passed to us
echo %_CYGSCRIPT%
echo %_CYGSCRIPT%
REM echo cd %_CWD%; "%_CYGSCRIPT%" %* | %_CYGBIN%\bash --login -s
REM echo cd %_CWD%; "/usr/bin/pcfind.sh" %*
REM echo %*
endlocal & echo cd %_CWD%; "/usr/bin/pcfind.sh" %* | %_CYGBIN%\bash --login
REM source /home/$USERNAME/lib.sh && $@


