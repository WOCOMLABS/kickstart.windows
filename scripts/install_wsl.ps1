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
$installedDistrosOutput = wsl --list --verbose 2>&1
if ($installedDistrosOutput -like "*no installed distributions*") {
    Write-Host "No installed WSL distributions found."
    $installedDistros = $null
} else {
    Write-Host $installedDistrosOutput
    $installedDistros = $installedDistrosOutput -split "`n" | Select-Object -Skip 1
}

if ($installedDistros) {
    # Check if any distributions are running
    $runningDistros = $installedDistros | Where-Object { $_ -like "*Running*" }
    if ($runningDistros) {
        Write-Host "The following WSL distributions are currently running:"
        $runningDistros | ForEach-Object { Write-Host $_ }

        $userChoice = Read-Host "Do you want to export and unregister these distributions before proceeding with a new installation? (yes/no)"
        if ($userChoice -eq "yes") {
            foreach ($distro in $runningDistros) {
                $distroName = ($distro -split '\s+')[0]
                $exportPath = "$env:USERPROFILE\$distroName-export.tar"
                Export-WSLDistribution -distroName $distroName -exportPath $exportPath
                wsl --unregister $distroName
            }
        } else {
            Write-Host "Operation aborted by user."
            exit
        }
    }
}

# List available distributions for installation
Write-Host "Listing available WSL distributions..."
$availableDistrosOutput = wsl --list --online 2>&1
if ($availableDistrosOutput -like "*No valid distributions found*" -or $availableDistrosOutput -like "*Error: 0x80370102*") {
    Write-Host "No valid distributions found."
    Write-Host "Please ensure that WSL is updated and try running the script again."
    exit
} else {
    Write-Host $availableDistrosOutput
    $availableDistros = $availableDistrosOutput -split "`n" | Select-Object -Skip 1
}

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
    Write-Host "Please ensure that WSL is updated and try running the script again."
}
