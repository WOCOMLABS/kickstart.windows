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

# Ensure the script path exists
$scriptDir = "$env:USERPROFILE\dev\scripts"
if (-not (Test-Path -Path $scriptDir)) {
    New-Item -Path $scriptDir -ItemType Directory
}

# Download and run the repository setup script
$setupScriptUrl = "https://raw.githubusercontent.com/WOCOMLABS/kickstart.windows/main/download_and_extract_repo.ps1"
$setupScriptPath = "$scriptDir\download_and_extract_repo.ps1"

Invoke-WebRequest -Uri $setupScriptUrl -OutFile $setupScriptPath
# & $setupScriptPath

# Run installation scripts from the extracted repository
$repoExtractPath = "$env:USERPROFILE\dev\kickstart.windows"
cd $repoExtractPath
.\scripts\install_chocolatey.ps1
.\scripts\install_wsl.ps1

Write-Host "Setup completed successfully!"