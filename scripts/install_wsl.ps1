# Function to export a running WSL distribution
function Export-WSLDistribution {
    param (
        [string]$distroName,
        [string]$exportPath
    )
    Write-Host "Exporting WSL distribution '$distroName' to '$exportPath'..."
    wsl --export $distroName $exportPath
    Write-Host "Export completed for '$distroName'."
}

# List installed WSL distributions
Write-Host "Listing installed WSL distributions..."
$installedDistros = wsl --list --verbose
Write-Host $installedDistros

# Check if any distributions are running
$runningDistros = $installedDistros | Where-Object { $_ -match "Running" }
if ($runningDistros) {
    Write-Host "The following WSL distributions are currently running:"
    $runningDistros | ForEach-Object { Write-Host $_ }
    
    $userChoice = Read-Host "Do you want to export and unregister these distributions before proceeding with a new installation? (yes/no)"
    if ($userChoice -eq "yes") {
        foreach ($distro in $runningDistros) {
            $distroName = ($distro -split '\s+')[1]
            $exportPath = "$env:USERPROFILE\$distroName-export.tar"
            Export-WSLDistribution -distroName $distroName -exportPath $exportPath
            wsl --unregister $distroName
        }
    } else {
        Write-Host "Operation aborted by user."
        exit
    }
}

# List available distributions for installation
Write-Host "Listing available WSL distributions..."
$availableDistros = wsl --list --online | Where-Object { $_ -match "Ubuntu" }
if ($availableDistros) {
    Write-Host "Available WSL distributions:"
    $availableDistros | ForEach-Object { Write-Host $_ }
    $defaultDistro = "Ubuntu-24.04"
    $distroChoice = Read-Host -Prompt "Enter the WSL distribution to install (default: $defaultDistro)"
    if (-not $distroChoice) { $distroChoice = $defaultDistro }

    # Install WSL
    Write-Host "Installing WSL with $distroChoice..."
    wsl --install -d $distroChoice
} else {
    Write-Host "No valid distributions found."
}