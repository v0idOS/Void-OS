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
    "wisvc"         # Windows Insider Service
)

foreach ($svc in $servicesToDisable) {
    if (Test-ServiceExists $svc) {
        if (-not $DryRun) { Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue }
        Write-VoidLog "[EXTREME] $svc service disabled completely" -Type Success
    } else {
        Write-VoidLog "[SAFE] $svc not found" -Type Skipped
    }
}
