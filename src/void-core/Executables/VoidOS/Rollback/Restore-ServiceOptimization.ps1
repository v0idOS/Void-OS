param([switch]$DryRun)
$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1"
Import-Module "$engineDir\HardwareDetection.psm1"

if (Test-ServiceExists "SysMain") {
    if (-not $DryRun) { Set-Service -Name "SysMain" -StartupType Automatic }
    Write-VoidLog "[RESTORE] SysMain reverted to Automatic" -Type Success
}
if (Test-ServiceExists "DPS") {
    if (-not $DryRun) { Set-Service -Name "DPS" -StartupType Automatic }
    Write-VoidLog "[RESTORE] DPS reverted to Automatic" -Type Success
}
if (Test-ServiceExists "DiagTrack") {
    if (-not $DryRun) { Set-Service -Name "DiagTrack" -StartupType Automatic }
    Write-VoidLog "[RESTORE] DiagTrack reverted to Automatic" -Type Success
}
