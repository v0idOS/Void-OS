param (
    [string]$Browser
)
if (!$Browser) {
    $ArgString = "`"${Env:WinDir}\VoidModules\Scripts\taskbarPins.ps1`""
    $Action = New-ScheduledTaskAction -Execute "powershell.exe" `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File $ArgString `"$Browser`""
    $Trigger = New-ScheduledTaskTrigger -AtLogon
    $Principal = New-ScheduledTaskPrincipal -GroupId "Users" -RunLevel Highest

    Register-ScheduledTask -TaskName "TaskBarPinsDefault" -Action $Action -Trigger $Trigger -Principal $Principal -Force
}
else {
    $ArgString = "`"${Env:WinDir}\VoidModules\Scripts\taskbarPins.ps1`""
    $Action = New-ScheduledTaskAction -Execute "powershell.exe" `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File $ArgString `"$Browser`""
    $Trigger = New-ScheduledTaskTrigger -AtLogon
    $Principal = New-ScheduledTaskPrincipal -GroupId "Users" -RunLevel Highest

    Register-ScheduledTask -TaskName "TaskBarPins" -Action $Action -Trigger $Trigger -Principal $Principal -Force
}




# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
