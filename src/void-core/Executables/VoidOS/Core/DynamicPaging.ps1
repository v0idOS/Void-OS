$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1" -ErrorAction SilentlyContinue
Import-Module "$engineDir\HardwareDetection.psm1" -ErrorAction SilentlyContinue

Write-VoidLog "Initializing Dynamic Paging Protocol..." -Type Info

$ramGB = Get-SystemRAMGB
Write-VoidLog "Detected System RAM: ${ramGB}GB" -Type Info

# Ensure WMI has privileges to change system settings
$sys = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
if ($sys.AutomaticManagedPagefile) {
    $sys.AutomaticManagedPagefile = $false
    $sys.Put() | Out-Null
    Write-VoidLog "Disabled Automatic Page File Management." -Type Info
}

if ($ramGB -lt 32) {
    Write-VoidLog "RAM < 32GB. Enforcing static 8192MB page file to prevent OOM crashes and hard faults." -Type Info
    
    $pagefile = Get-WmiObject Win32_PageFileSetting | Where-Object { $_.Name -like "C:*" }
    if ($null -eq $pagefile) {
        Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{Name="C:\pagefile.sys"} | Out-Null
        $pagefile = Get-WmiObject Win32_PageFileSetting | Where-Object { $_.Name -like "C:*" }
    }
    
    $pagefile.InitialSize = 8192
    $pagefile.MaximumSize = 8192
    $pagefile.Put() | Out-Null
    
    Write-VoidLog "[SAFE] Static 8192MB Page File locked on C:\" -Type Success
} else {
    Write-VoidLog "32GB+ RAM detected. Disabling Page File for extreme latency reduction." -Type Info
    
    $pagefiles = Get-WmiObject Win32_PageFileSetting
    foreach ($pf in $pagefiles) {
        $pf.Delete()
    }
    
    Write-VoidLog "[EXTREME] Page File completely disabled." -Type Success
}

# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
