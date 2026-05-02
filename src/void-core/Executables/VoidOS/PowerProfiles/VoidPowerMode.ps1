param(
    [ValidateSet("Auto", "Performance", "Battery")]
    [string]$Mode = "Auto"
)

$logPath = "C:\VoidOS_Logs\PowerMode.log"
New-Item -ItemType Directory -Path (Split-Path $logPath) -Force | Out-Null

function Get-ActiveSchemeGuid {
    $output = powercfg /getactivescheme
    if ($output -match '([a-fA-F0-9-]{36})') {
        return $matches[1]
    }

    throw "Unable to parse active power scheme GUID."
}

function Set-PerfMode {
    $scheme = Get-ActiveSchemeGuid
    powercfg /setacvalueindex $scheme SUB_PROCESSOR PROCTHROTTLEMAX 100
    powercfg /setacvalueindex $scheme SUB_PROCESSOR PERFEPP 0
    powercfg /setdcvalueindex $scheme SUB_PROCESSOR PROCTHROTTLEMAX 100
    powercfg /setdcvalueindex $scheme SUB_PROCESSOR PERFEPP 15
    powercfg /setactive $scheme
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord
    "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] PERFORMANCE applied" | Add-Content $logPath
}

function Set-BatteryMode {
    $scheme = Get-ActiveSchemeGuid
    powercfg /setdcvalueindex $scheme SUB_PROCESSOR PROCTHROTTLEMAX 85
    powercfg /setdcvalueindex $scheme SUB_PROCESSOR PERFEPP 80
    powercfg /setdcvalueindex $scheme SUB_PROCESSOR CPMINCORES 10
    powercfg /setdcvalueindex $scheme SUB_PROCESSOR CPMAXCORES 60
    powercfg /setactive $scheme
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 2 -Type DWord
    "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] BATTERY applied" | Add-Content $logPath
}

if ($Mode -eq "Performance") {
    Set-PerfMode
    exit 0
}

if ($Mode -eq "Battery") {
    Set-BatteryMode
    exit 0
}

$onBattery = (Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue |
    Where-Object { $_.BatteryStatus -in 1, 4, 5, 11 }) -ne $null

if ($onBattery) {
    Set-BatteryMode
} else {
    Set-PerfMode
}

# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
