param(
    [switch]$DryRun,
    [switch]$Rollback
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$engineDir = Join-Path $PSScriptRoot "Engine"
Import-Module "$engineDir\Logger.psm1" -ErrorAction Stop

Write-VoidLog "Initializing Void OS Engine v1.0..." -Type Info

if ($DryRun) {
    Write-VoidLog "WARNING: Dry Run Mode Active. No changes will be made to the system." -Type Skipped
} elseif (-not $Rollback) {
    Write-VoidLog "Creating System Restore Point..." -Type Info
    try {
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "Void OS Setup Pre-Optimization" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-VoidLog "System Restore Point created successfully." -Type Success
    } catch {
        Write-VoidLog "Failed to create Restore Point: $($_.Exception.Message)" -Type Error
    }
}

if ($Rollback) {
    Write-VoidLog "Initiating Void OS Rollback Protocol..." -Type Info
    $scripts = Get-ChildItem -Path "$PSScriptRoot\Rollback" -Filter "*.ps1"
} else {
    Write-VoidLog "Initiating Void OS Optimization Protocol..." -Type Info
    $scripts = @()
    $scripts += Get-ChildItem -Path "$PSScriptRoot\Core" -Filter "*.ps1"
    $scripts += Get-ChildItem -Path "$PSScriptRoot\Performance" -Filter "*.ps1"
    $scripts += Get-ChildItem -Path "$PSScriptRoot\Latency" -Filter "*.ps1"
}

foreach ($script in $scripts) {
    Write-VoidLog "Executing: $($script.Name)" -Type Info
    $argsParams = @{}
    if ($DryRun) { $argsParams['DryRun'] = $true }
    & $script.FullName @argsParams
}

Write-VoidLog "Void OS Engine Execution Complete." -Type Success
