@echo off
cls
::Very elegant
set BR=br.chat.si.riotgames.com
set EUNE=eun1.chat.si.riotgames.com
set EUW=euw1.chat.si.riotgames.com
set JP=jp1.chat.si.riotgames.com
set LAN=la1.chat.si.riotgames.com
set LAS=la2.chat.si.riotgames.com
set NA=na2.chat.si.riotgames.com
set OCE=oc1.chat.si.riotgames.com
set PH=ph1.chat.si.riotgames.com
set RU=ru1.chat.si.riotgames.com
set SG=sg1.chat.si.riotgames.com
set TH=th1.chat.si.riotgames.com
set TR=tr1.chat.si.riotgames.com
set TW=tw1.chat.si.riotgames.com
set VN=vn1.chat.si.riotgames.com
(set SERVER=%EUW%)
::Please note that the code self destructs if you alter the line count above this message

net session >nul 2>&1
if %ERRORLEVEL% == 0 (goto start) else (goto noadmin)

:noadmin
echo You have no power here!
echo (No admin priviledges detected)
timeout /t 3

echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%TEMP%\getadmin.vbs"
"%TEMP%\getadmin.vbs"
del "%TEMP%\getadmin.vbs"
exit /B

:start
cls
echo This script adds a Windows firewall rules to block outgoing data to
echo League of Legends chat server, effectively making you appear offline
echo [1] Add firewall rule (appear offline)
echo [2] Remove all firewall rules (appear online)
echo [3] Change server, currently: %SERVER%
set /p "ANS= Enter a menu option: "

if /i %ANS% == 1 goto offline
if /i %ANS% == 2 goto online
if /i %ANS% == 3 goto changeserver
goto unknown

:offline
cls
echo This will take a second or two

for /f "tokens=1,3 delims=[] " %%A in ('ping -n 1 %server% -4') do (IF %%A==Pinging (set IP4=%%B))
for /f "tokens=1,3 delims=[] " %%A in ('ping -n 1 %server% -6') do (IF %%A==Pinging (set IP6=%%B))
if [%IP6%] == [] (set "STR=%IP4%") else (set "STR=%IP4%,%IP6%")
netsh advfirewall firewall add rule name="lolchat" dir=out remoteip=%STR% protocol=TCP action=block

echo.
echo Blocked IP address(es): %STR%
echo You are now seen as offline.
echo.
timeout /t 7
goto start

:online
cls
netsh advfirewall firewall delete rule name="lolchat"
echo.
echo You are now seen as online.
echo.
timeout /t 3
goto start

:unknown
cls
echo Unknown option, try again.
timeout /t 2
goto start

:changeserver
cls
echo Select server from the following options:
echo BR EUNE EUW JP LAN LAS NA OCE PH RU SG TH TR TW VN
echo Leave blank to return
set /p "ANS= Enter a server (case sensitive): "

if %ANS% == BR goto rw
if %ANS% == EUNE goto rw
if %ANS% == EUW goto rw
if %ANS% == JP goto rw
if %ANS% == LAN goto rw
if %ANS% == LAS goto rw
if %ANS% == NA goto rw
if %ANS% == PH goto rw
if %ANS% == RU goto rw
if %ANS% == SG goto rw
if %ANS% == TH goto rw
if %ANS% == TR goto rw
if %ANS% == TW goto rw
if %ANS% == VN goto rw
goto start

::Rewrite file with the newly chosen server as default server (line 19)
:rw
set THISF=%~f0
set TEMPF=%THISF%.tmp
if exist %TEMPF% del /F %TEMPF%
setlocal enabledelayedexpansion
set /A ITER=1
for /F "delims=?" %%a in (%THISF%) do (
   echo.%%a>> "%TEMPF%"
   set /A ITER+=1
   if !ITER! GEQ 19 GOTO :el
)

:el
endlocal
@echo.(set SERVER=%%%ANS%%%)>> "%TEMPF%"
more +19 < "%THISF%">> "%TEMPF%"
(
copy /y "%TEMPF%" "%THISF%"
del "%TEMPF%"
%0
)
