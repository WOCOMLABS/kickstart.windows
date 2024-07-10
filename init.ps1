# Kickstart WSL Setup

# Function to install PowerShell and restart script in Windows Terminal
function Install-PowerShell {
    Write-Host "Installing PowerShell..."
    winget install --id Microsoft.Powershell --source winget
    Write-Host "Restarting PowerShell in Windows Terminal..."
    Start-Sleep -Seconds 3
    Start-Process -FilePath "wt.exe" -ArgumentList "pwsh -NoExit -File `"$PSCommandPath`""
    exit
}

# Set execution policy temporarily
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Check if running in PowerShell Core
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Install-PowerShell
}

# Execute installation scripts
.\scripts\install_chocolatey.ps1
.\scripts\install_wsl.ps1


Write-Host "Setup completed successfully!"