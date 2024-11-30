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

# Function to check and enable Starship in the PowerShell profile
function Enable-Starship {
    Write-Host "Checking if Starship is properly set up..."
    try {
        # Check if Starship is installed
        if (!(Get-Command starship -ErrorAction SilentlyContinue)) {
            Write-Host "Starship is not installed or not in PATH. Attempting installation..." -ForegroundColor Yellow
            Install-Application "Starship" "Starship.Starship"
        }

        # Verify Starship installation
        if (!(Get-Command starship -ErrorAction SilentlyContinue)) {
            Write-Host "Error: Starship installation failed or is not in PATH." -ForegroundColor Red
            return
        }

        # Check if PowerShell profile exists, create if not
        $profilePath = $PROFILE
        if (!(Test-Path $profilePath)) {
            Write-Host "PowerShell profile not found. Creating profile..."
            New-Item -ItemType File -Path $profilePath -Force | Out-Null
        }

        # Check and add Starship initialization to the profile
        $profileContent = Get-Content $profilePath -ErrorAction SilentlyContinue
        if ($profileContent -notcontains 'Invoke-Expression (&starship init powershell)') {
            Write-Host "Adding Starship initialization to PowerShell profile..."
            Add-Content -Path $profilePath -Value "`nInvoke-Expression (&starship init powershell)"
            Write-Host "Starship initialized successfully in PowerShell profile."
        } else {
            Write-Host "Starship is already initialized in PowerShell profile."
        }
    } catch {
        Write-Host "Error: Failed to enable Starship. Details: $_" -ForegroundColor Red
    }
}

# Function to update the PATH environment variable dynamically
function Update-Path {
    param (
        [string]$newEntry
    )
    Write-Host "Updating PATH environment variable..."
    try {
        # Check if running as Administrator
        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        if ($isAdmin) {
            $machinePath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
            if ($machinePath -notcontains $newEntry) {
                $updatedPath = $machinePath + ";" + $newEntry
                [System.Environment]::SetEnvironmentVariable("Path", $updatedPath, [System.EnvironmentVariableTarget]::Machine)
                Write-Host "Machine-level PATH updated successfully."
            } else {
                Write-Host "Machine-level PATH already contains the required entry."
            }
        } else {
            $userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
            if ($userPath -notcontains $newEntry) {
                $updatedPath = $userPath + ";" + $newEntry
                [System.Environment]::SetEnvironmentVariable("Path", $updatedPath, [System.EnvironmentVariableTarget]::User)
                Write-Host "User-level PATH updated successfully. Restart your session to apply changes."
            } else {
                Write-Host "User-level PATH already contains the required entry."
            }
        }
    } catch {
        Write-Host "Error: Failed to update PATH environment variable. Details: $_" -ForegroundColor Red
    }
}

# Function to configure Git
function Configure-Git {
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
        Write-Host "Error: Failed to configure Git. Ensure Git is installed and the commands are correct. Details: $_" -ForegroundColor Red
    }
}

# Main script execution

# Install required applications
Install-Application "Git" "Git.Git"
Install-Application "GitHub CLI" "GitHub.cli"
Install-Application "Starship" "Starship.Starship"
Install-Application "JetBrains Toolbox" "JetBrains.Toolbox"

# Enable Starship
Enable-Starship

# Add Starship to PATH
Update-Path -newEntry "C:\Users\$env:USERNAME\AppData\Local\Programs\starship"

# Configure Git
Configure-Git

Write-Host "All tasks completed successfully!" -ForegroundColor Green
