@echo off

for /f "skip=3 delims=" %%a in ('bcdedit /enum {current}') do (echo %%a)
echo]
echo Press any key to exit...
pause > nul
exit /b
# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
