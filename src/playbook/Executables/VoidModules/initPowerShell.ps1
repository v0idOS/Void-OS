$windir = [Environment]::GetFolderPath('Windows')

# Add Void's PowerShell modules
$env:PSModulePath += ";$windir\VoidModules\Scripts\Modules"