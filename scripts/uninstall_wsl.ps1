Write-Host "Starting WSL uninstallation process..." -ForegroundColor Cyan

# Function to check if a WSL distribution exists
function Check-WSLDistribution {
    param (
        [string]$distroName
    )
    $distroList = wsl --list --verbose | ForEach-Object { $_.Trim() }
    return $distroList -match $distroName
}

# Function to uninstall a WSL distribution
function Uninstall-WSL {
    param (
        [string]$distroName
    )

    if (Check-WSLDistribution -distroName $distroName) {
        Write-Host "Found WSL distribution: $distroName. Proceeding with uninstallation..." -ForegroundColor Yellow

        # Shut down WSL
        Write-Host "Shutting down WSL..."
        try {
            wsl --shutdown
            Write-Host "WSL shut down successfully." -ForegroundColor Green
        } catch {
            Write-Host "Error: Failed to shut down WSL. Details: $_" -ForegroundColor Red
        }

        # Terminate the WSL distribution
        Write-Host "Terminating WSL distribution: $distroName..."
        try {
            wsl --terminate $distroName
            Write-Host "WSL distribution $distroName terminated successfully." -ForegroundColor Green
        } catch {
            Write-Host "Error: Failed to terminate $distroName. Details: $_" -ForegroundColor Red
        }

        # Unregister the WSL distribution
        Write-Host "Unregistering WSL distribution: $distroName..."
        try {
            wsl --unregister $distroName
            Write-Host "WSL distribution $distroName unregistered successfully." -ForegroundColor Green
        } catch {
            Write-Host "Error: Failed to unregister $distroName. Details: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "WSL distribution $distroName does not exist or is already unregistered." -ForegroundColor Yellow
    }
}

# Specify the distribution name
$distroName = "Ubuntu-24.04"

# Call the uninstall function
Uninstall-WSL -distroName $distroName

Write-Host "WSL uninstallation process completed." -ForegroundColor Cyan
