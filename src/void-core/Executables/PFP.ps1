Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile((Get-Item '.\user.png'))

$resolutions = @{
    "user.png" = 448
    "user.bmp" = 448
    "guest.png" = 448
    "guest.bmp" = 448
    "user-192.png" = 192
    "user-48.png" = 48
    "user-40.png" = 40
    "user-32.png" = 32
}

# Clear cached Public AccountPictures to prevent old images from showing up
$publicCache = "C:\Users\Public\AccountPictures"
if (Test-Path $publicCache) {
    Remove-Item -Path "$publicCache\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# Aggressively seize control of the User Account Pictures folder and nuke existing files
$pfpFolder = "$([Environment]::GetFolderPath('CommonApplicationData'))\Microsoft\User Account Pictures"
if (Test-Path $pfpFolder) {
    takeown /f $pfpFolder /r /d y | Out-Null
    icacls $pfpFolder /grant administrators:F /t /q | Out-Null
    Remove-Item -Path "$pfpFolder\*" -Force -Recurse -ErrorAction SilentlyContinue
}

# Set default profile pictures
foreach ($image in $resolutions.Keys) {
    $resolution = $resolutions[$image]

    $a = New-Object System.Drawing.Bitmap($resolution, $resolution)
    $graph = [System.Drawing.Graphics]::FromImage($a)
    $graph.DrawImage($img, 0, 0, $resolution, $resolution)
    
    $targetPath = "$pfpFolder\$image"
    $a.Save($targetPath)
}

# Forcefully apply the default picture to all users by setting the UseDefaultTile policy
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
Set-ItemProperty -Path $registryPath -Name "UseDefaultTile" -Value 1 -Type DWord -Force