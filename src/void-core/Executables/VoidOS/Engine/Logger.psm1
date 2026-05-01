function Write-VoidLog {
    param(
        [Parameter(Mandatory=$true)][string]$Message,
        [ValidateSet('Success', 'Skipped', 'Error', 'Info')][string]$Type = 'Info'
    )
    $logDir = "C:\VoidOS_Logs"
    if (-not (Test-Path $logDir)) { New-Item -Path $logDir -ItemType Directory -Force | Out-Null }
    $logFile = "$logDir\Optimization_$(Get-Date -Format 'yyyy-MM-dd').log"
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    $color = switch ($Type) {
        'Success' { 'Green' }
        'Skipped' { 'Yellow' }
        'Error'   { 'Red' }
        'Info'    { 'Cyan' }
    }
    
    $logMessage = "[$timestamp] [$Type] $Message"
    Write-Host $logMessage -ForegroundColor $color
    Add-Content -Path $logFile -Value $logMessage
}
Export-ModuleMember -Function Write-VoidLog
