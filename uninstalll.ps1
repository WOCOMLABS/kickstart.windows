# Kickstart Windows & WSL Uninstall

$directoryPath = "$env:USERPROFILE\dev\kickstart.windows"
& "$directoryPath\scripts\uninstall_wsl.ps1"
& "$directoryPath\scripts\uninstall_dev.ps1"

Write-Host "Bye!"
