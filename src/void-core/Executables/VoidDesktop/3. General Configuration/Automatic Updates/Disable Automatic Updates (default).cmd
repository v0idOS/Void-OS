@echo off
set "settingName=AutomaticUpdates"
set "stateValue=0"
set "scriptPath=%~f0"

set "___args="%~f0" %*"
fltmc > nul 2>&1 || (
    echo Administrator privileges are required.
    powershell -c "Start-Process -Verb RunAs -FilePath 'cmd' -ArgumentList """/c $env:___args"""" 2> nul || (
        echo You must run this script as admin.
        if "%*"=="" pause
        exit /b 1
    )
    exit /b
)

reg add "HKLM\SOFTWARE\VoidOS\Services\%settingName%" /v state /t REG_DWORD /d %stateValue% /f > nul
reg add "HKLM\SOFTWARE\VoidOS\Services\%settingName%" /v path /t REG_SZ /d "%scriptPath%" /f > nul

:: Aggressive Windows Update Annihilation
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 2 /f > nul

:: Stop and disable background update services to reclaim RAM and drop processes
sc config wuauserv start= disabled > nul 2>&1
sc stop wuauserv > nul 2>&1
sc config UsoSvc start= disabled > nul 2>&1
sc stop UsoSvc > nul 2>&1

if "%~1" == "/justcontext" exit /b
if "%~1"=="/silent" exit /b

echo.
echo Automatic Updates have been disabled.
echo Press any key to exit...
pause > nul
exit /b

# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
