# Define a reusable function to install applications using winget
function Install-Application {
    param (
        [string]$appName,
        [string]$wingetId
    )
    Write-Host "Installing $appName..."
    try {
        Start-Process -FilePath "winget" -ArgumentList "install --id $wingetId -e --source winget" -Wait -NoNewWindow -ErrorAction Stop
        Write-Host "$appName installed successfully."
    } catch {
        Write-Host "Error: Failed to install $appName. Please check if winget is installed or the application ID is correct." -ForegroundColor Red
    }
}

# Install required applications
Install-Application "Git" "Git.Git"
Install-Application "GitHub CLI" "GitHub.cli"
Install-Application "Starship" "Starship.Starship"
Install-Application "JetBrains Toolbox" "JetBrains.Toolbox"

# Check and enable Starship in PowerShell profile
function Enable-Starship {
    Write-Host "Checking if Starship is properly set up..."
    try {
        # Check if Starship is installed
        if (!(Get-Command starship -ErrorAction SilentlyContinue)) {
            Write-Host "Error: Starship is not installed or not in PATH." -ForegroundColor Red
            return
        }

        # Check if Starship is already initialized in the PowerShell profile
        $profilePath = $PROFILE
        if (!(Test-Path $profilePath)) {
            Write-Host "PowerShell profile not found. Creating profile..."
            New-Item -ItemType File -Path $profilePath -Force | Out-Null
        }

        $profileContent = Get-Content $profilePath -ErrorAction SilentlyContinue
        if ($profileContent -notcontains 'Invoke-Expression (&starship init powershell)') {
            Write-Host "Adding Starship initialization to PowerShell profile..."
            Add-Content -Path $profilePath -Value 'Invoke-Expression (&starship init powershell)'
            Write-Host "Starship initialized successfully in PowerShell profile."
        } else {
            Write-Host "Starship is already initialized in PowerShell profile."
        }
    } catch {
        Write-Host "Error: Failed to enable Starship. Ensure Starship is installed correctly." -ForegroundColor Red
    }
}

Enable-Starship

# Update the PATH environment variable
Write-Host "Updating PATH environment variable..."
try {
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
    $newPath = $machinePath + ";" + $userPath
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
    Write-Host "PATH updated successfully."
} catch {
    Write-Host "Error: Failed to update PATH environment variable." -ForegroundColor Red
}

# Configure Git
Write-Host "Configuring Git..."
try {
    $userName = Read-Host -Prompt "Enter your Git user name for your Windows machine"
    $userEmail = Read-Host -Prompt "Enter your Git user email for your Windows machine"

    git config --global user.name "$userName"
    git config --global user.email "$userEmail"
    git config --global init.defaultBranch main
    git config --global --unset credential.helper
    git config --global credential.helper store

    Write-Host "Git configured successfully with the provided user name and email."
} catch {
    Write-Host "Error: Failed to configure Git. Ensure Git is installed and the commands are correct." -ForegroundColor Red
}

Write-Host "All tasks completed successfully!" -ForegroundColor Green
