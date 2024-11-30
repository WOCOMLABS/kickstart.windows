Write-Host "Starting WSL installation process..." -ForegroundColor Cyan

# Function to check if WSL is installed
function Check-WSL {
    Write-Host "Checking if WSL is installed..."
    try {
        $wslVersion = wsl --version 2>&1
        if ($wslVersion -match "Microsoft") {
            Write-Host "WSL is installed." -ForegroundColor Green
            return $true
        } else {
            Write-Host "WSL is not installed. Proceeding with installation..." -ForegroundColor Yellow
            return $false
        }
    } catch {
        Write-Host "Error: Failed to check WSL installation. Details: $_" -ForegroundColor Red
        return $false
    }
}

# Function to install WSL
function Install-WSL {
    Write-Host "Installing WSL..."
    try {
        wsl --install
        Write-Host "WSL installed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to install WSL. Please ensure your system supports WSL and virtualization is enabled. Details: $_" -ForegroundColor Red
        exit 1
    }
}

# Function to install a specific WSL distribution
function Install-WSLDistribution {
    param (
        [string]$distroName
    )
    Write-Host "Installing WSL distribution: $distroName..."
    try {
        wsl --install $distroName
        Write-Host "WSL distribution $distroName installed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to install WSL distribution $distroName. Details: $_" -ForegroundColor Red
        exit 1
    }
}

# Check if WSL is installed
if (-not (Check-WSL)) {
    Install-WSL
}

# Install Ubuntu 24.04
$distroName = "Ubuntu-24.04"
Install-WSLDistribution -distroName $distroName

Write-Host "WSL installation process completed." -ForegroundColor Cyan

