param(
    [ValidateSet('Enable', 'Disable')]
    [string]$Action = 'Disable'
)

$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1" -ErrorAction SilentlyContinue

# The ACPI Control Method Battery hardware ID usually contains PNP0C0A
$batteryDevice = Get-PnpDevice -FriendlyName "*ACPI-Compliant Control Method Battery*" -ErrorAction SilentlyContinue

if ($null -eq $batteryDevice) {
    if (Get-Command Write-VoidLog -ErrorAction SilentlyContinue) {
        Write-VoidLog "[EXPERIMENTAL] ACPI Battery Driver not found. Skipping." -Type Skipped
    }
    exit
}

if ($Action -eq 'Disable') {
    Disable-PnpDevice -InstanceId $batteryDevice.InstanceId -Confirm:$false -ErrorAction SilentlyContinue
    if (Get-Command Write-VoidLog -ErrorAction SilentlyContinue) {
        Write-VoidLog "[EXPERIMENTAL] ACPI Battery Driver DISABLED. Battery icon hidden. ACPI Latency dropped." -Type Success
    }
} else {
    Enable-PnpDevice -InstanceId $batteryDevice.InstanceId -Confirm:$false -ErrorAction SilentlyContinue
    if (Get-Command Write-VoidLog -ErrorAction SilentlyContinue) {
        Write-VoidLog "[EXPERIMENTAL] ACPI Battery Driver ENABLED. Battery icon restored." -Type Success
    }
}
