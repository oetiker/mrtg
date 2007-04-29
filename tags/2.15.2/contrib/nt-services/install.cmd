@ECHO OFF
REM
IF NOT /%OS%/ == /Windows_NT/ GOTO NOT_NT
IF /%SystemDrive%/ == // GOTO NOT_SystemDrive
IF /%SystemRoot%/ == // GOTO NOT_SystemRoot
REM
REM
IF NOT EXIST 5Mrtg.Exe GOTO NOT_5Mrtg
IF NOT EXIST 5Mrtg.Reg GOTO NOT_Reg
REM
REM
REM SystemDrive=C:
REM SystemRoot=C:\WINNT
REM
START 5mrtg.Reg
REM
COPY /Y 5mrtg.Exe %SystemRoot%\System32
%SystemDrive%
CD %SystemRoot%\System32
5mrtg.Exe -install
NET START mrtg5
CD \
REM
GOTO FIN
REM
REM
:NOT_NT
ECHO This is NOT Windows NT
GOTO FIN
REM
:NOT_SystemDrive
ECHO SystemDrive NOT defined
GOTO FIN
REM
:NOT_SystemRoot
ECHO SystemRoot NOT defined
GOTO FIN
REM
:NOT_5Mrtg
ECHO 5mrtg.exe NOT found
GOTO FIN
REM
:NOT_Reg
ECHO 5mrtg.Reg NOT found
GOTO FIN
REM
:FIN
REM -=EOF=-
