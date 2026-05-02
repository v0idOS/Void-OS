# speeds up powershell startup time by 10x
$env:path = "$([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory());" + $env:path
[AppDomain]::CurrentDomain.GetAssemblies().Location | ? {$_} | % {
    Write-Host "NGENing: $(Split-Path $_ -Leaf)" -ForegroundColor Yellow
    ngen install $_ | Out-Null
}
# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
