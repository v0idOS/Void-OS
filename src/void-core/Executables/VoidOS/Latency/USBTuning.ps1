param([switch]$DryRun)
$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1"

if (-not $DryRun) {
    $scheme = (powercfg -getactivescheme).Split(' ')[3]
    powercfg -setacvalueindex $scheme 2a737441-1930-4402-8d77-b2bea737a32e 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    powercfg -setdcvalueindex $scheme 2a737441-1930-4402-8d77-b2bea737a32e 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    powercfg -setactive $scheme

    # Disable Power Throttling globally to prevent ntoskrnl.exe DPC spikes
    if (-not (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling")) {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Force | Out-Null
    }
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1 -PropertyType DWORD -Force | Out-Null
}
Write-VoidLog "[SAFE] USB Selective Suspend and Power Throttling globally disabled to lower DPC Latency" -Type Success
