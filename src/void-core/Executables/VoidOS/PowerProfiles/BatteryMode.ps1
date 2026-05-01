$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1"
Import-Module "$engineDir\HardwareDetection.psm1"

if (-not (Test-IsLaptop)) {
    Write-VoidLog "[SAFE] Battery Mode aborted. Not running on a laptop." -Type Skipped
    exit
}

Write-VoidLog "Applying Void OS Elite Battery Profile..." -Type Info
$scheme = (powercfg -getactivescheme).Split(' ')[3]

# Cap Max Frequency to 99% (Disables Turbo Boost)
powercfg -setdcvalueindex $scheme SUB_PROCESSOR PROCTHROTTLEMAX 99

# Energy Performance Preference (EPP) to 100 (Max Efficiency)
powercfg -setdcvalueindex $scheme SUB_PROCESSOR PERFEPP 100

powercfg -setactive $scheme

# Extreme ACPI Driver Reconnect
$extremeAcpiScript = Join-Path $PSScriptRoot "..\Experimental\ExtremeACPI.ps1"
if (Test-Path $extremeAcpiScript) {
    & $extremeAcpiScript -Action "Enable"
}

Write-VoidLog "[SAFE] Battery Mode Active: Turbo Disabled, Efficiency EPP." -Type Success
