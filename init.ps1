# Kickstart Windows & WSL Setup

# Function to install PowerShell and restart script in Windows Terminal
function Install-PowerShell {
    Write-Host "Installing PowerShell..."
    winget install --id Microsoft.Powershell --source winget
    Write-Host "Restarting PowerShell in Windows Terminal..."
    Start-Sleep -Seconds 3
    Start-Process -FilePath "wt.exe" -ArgumentList "pwsh -NoExit -Command `"& {`"$PSCommandPath`"}`""
    exit
}

# Set execution policy temporarily
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Check if running in PowerShell Core
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Install-PowerShell
}

$directoryPath = "$env:USERPROFILE\dev\kickstart.windows"
& "$directoryPath\scripts\install_git.ps1"
& "$directoryPath\scripts\install_wsl.ps1"

Write-Host "Setup completed successfully!"
