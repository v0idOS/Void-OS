param([switch]$DryRun)
$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1"

if (-not $DryRun) {
    $scheme = (powercfg -getactivescheme).Split(' ')[3]
    powercfg -setacvalueindex $scheme 2a737441-1930-4402-8d77-b2bea737a32e 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
    powercfg -setdcvalueindex $scheme 2a737441-1930-4402-8d77-b2bea737a32e 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
    powercfg -setactive $scheme
    
    # Restore Power Throttling to Windows Default
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -ErrorAction SilentlyContinue
}
Write-VoidLog "[RESTORE] USB Selective Suspend and Power Throttling restored to Windows Default" -Type Success
