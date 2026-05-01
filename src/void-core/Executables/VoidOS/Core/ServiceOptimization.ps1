param([switch]$DryRun)
$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1"
Import-Module "$engineDir\HardwareDetection.psm1"

Write-VoidLog "Starting Core Service Optimization..." -Type Info

# SysMain
if (Test-ServiceExists "SysMain") {
    if (-not $DryRun) { Set-Service -Name "SysMain" -StartupType Manual }
    Write-VoidLog "[SAFE] SysMain (SuperFetch) set to Manual to prevent disk spikes" -Type Success
} else { Write-VoidLog "[SAFE] SysMain not found" -Type Skipped }

# DPS
if (Test-ServiceExists "DPS") {
    if (-not $DryRun) { Set-Service -Name "DPS" -StartupType Manual }
    Write-VoidLog "[SAFE] DPS (Diagnostic Policy) set to Manual" -Type Success
} else { Write-VoidLog "[SAFE] DPS not found" -Type Skipped }

# DiagTrack
if (Test-ServiceExists "DiagTrack") {
    if (-not $DryRun) { Set-Service -Name "DiagTrack" -StartupType Disabled }
    Write-VoidLog "[SAFE] DiagTrack (Telemetry) completely disabled" -Type Success
} else { Write-VoidLog "[SAFE] DiagTrack not found" -Type Skipped }
