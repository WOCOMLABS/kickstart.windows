Write-Host "Starting uninstallation process..." -ForegroundColor Cyan

# Uninstall applications
function Uninstall-Application {
    param (
        [string]$appName,
        [string]$wingetId
    )
    Write-Host "Uninstalling $appName..."
    try {
        Start-Process -FilePath "winget" -ArgumentList "uninstall --id $wingetId" -Wait -NoNewWindow -ErrorAction Stop
        Write-Host "$appName uninstalled successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to uninstall $appName. It may not be installed or winget encountered an issue." -ForegroundColor Red
    }
}

# Uninstall Git, GitHub CLI, Starship, and JetBrains Toolbox
Uninstall-Application "Git" "Git.Git"
Uninstall-Application "GitHub CLI" "GitHub.cli"
Uninstall-Application "Starship" "Starship.Starship"
Uninstall-Application "JetBrains Toolbox" "JetBrains.Toolbox"
Uninstall-Application "Docker Desktop" "Docker.DockerDesktop"

# Remove PowerShell profile
Write-Host "Removing PowerShell profile..."
if (Test-Path $PROFILE) {
    try {
        Remove-Item -Path $PROFILE -Force
        Write-Host "PowerShell profile deleted successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to delete PowerShell profile. Details: $_" -ForegroundColor Red
    }
} else {
    Write-Host "No PowerShell profile found to delete." -ForegroundColor Yellow
}

# Remove Git configuration file
Write-Host "Removing Git configuration file..."
$gitConfigPath = "$env:USERPROFILE\.gitconfig"
if (Test-Path $gitConfigPath) {
    try {
        Remove-Item -Path $gitConfigPath -Force
        Write-Host "Git configuration file deleted successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to delete Git configuration file. Details: $_" -ForegroundColor Red
    }
} else {
    Write-Host "No Git configuration file found to delete." -ForegroundColor Yellow
}

Write-Host "Uninstallation process completed." -ForegroundColor Cyan
