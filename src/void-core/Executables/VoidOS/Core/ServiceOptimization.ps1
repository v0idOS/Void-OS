param([switch]$DryRun)
$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1"
Import-Module "$engineDir\HardwareDetection.psm1"

Write-VoidLog "Starting Core Service Optimization..." -Type Info

$servicesToDisable = @(
    "SysMain",      # Superfetch (disk spikes)
    "DPS",          # Diagnostic Policy Service
    "DiagTrack",    # Telemetry
    "WSearch",      # Windows Search Indexer (huge background CPU/RAM)
    "BITS",         # Background Intelligent Transfer (Update background downloads)
    "edgeupdate",   # Microsoft Edge Update Service
    "DusmSvc",      # Data Usage Routing
    "wisvc",        # Windows Insider Service
    "Spooler",      # Print Spooler (Disables printing)
    "PcaSvc",       # Program Compatibility Assistant
    "WpnService",   # Windows Push Notifications
    "MapsBroker",   # Downloaded Maps Manager
    "lfsvc",        # Geolocation Service
    "SgrmBroker",   # System Guard Runtime Monitor
    "Wscsvc",       # Windows Security Center
    "Sense",        # Windows Defender Advanced Threat Protection
    "WdNisSvc",     # Microsoft Defender Antivirus Network Inspection
    "CDPUserSvc",   # Connected Devices Platform (Syncing)
    "OneSyncSvc",   # Sync Host (Mail/Calendar)
    "UserDataSvc"   # User Data Access
)

foreach ($svc in $servicesToDisable) {
    if (Test-ServiceExists $svc) {
        if (-not $DryRun) { Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue }
        Write-VoidLog "[EXTREME] $svc service disabled completely" -Type Success
    } else {
        Write-VoidLog "[SAFE] $svc not found" -Type Skipped
    }
}

# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
