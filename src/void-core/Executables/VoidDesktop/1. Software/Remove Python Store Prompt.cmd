@echo off

echo Attempting to remove Python executables from WindowsApps...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item -Path \"$env:LOCALAPPDATA\Microsoft\WindowsApps\python*.exe\" -Force -ErrorAction SilentlyContinue; if (Test-Path Alias:python) { Remove-Item Alias:python }; if (Test-Path Alias:python3) { Remove-Item Alias:python3 }"

echo -----------------------------------------
echo Cleanup completed.
pause
exit /b

# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
