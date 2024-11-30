# Define the directory path
$directoryPath = "$env:USERPROFILE\dev\kickstart.windows"

# Ensure the target directory exists
$targetDirectory = "$env:USERPROFILE\dev"
if (-not (Test-Path -Path $targetDirectory)) {
    Write-Host "Creating 'dev' directory..."
    New-Item -Path $targetDirectory -ItemType Directory -Force
}

# Function to download and extract the repository
function Download-And-Extract-Repo {
    param (
        [string]$repoUrl,
        [string]$zipPath,
        [string]$extractPath
    )

    try {
        Write-Host "Downloading repository from $repoUrl..."
        Invoke-WebRequest -Uri $repoUrl -OutFile $zipPath -UseBasicParsing

        Write-Host "Extracting repository to $extractPath..."
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

        # Move extracted contents to the desired directory
        if (Test-Path -Path "$extractPath\kickstart.windows-main") {
            Move-Item -Path "$extractPath\kickstart.windows-main\*" -Destination $extractPath -Force
            Remove-Item -Path "$extractPath\kickstart.windows-main" -Recurse -Force
        }

        Write-Host "Cleaning up temporary files..."
        Remove-Item -Path $zipPath -Force

        Write-Host "Repository downloaded and extracted successfully!"
    } catch {
        Write-Host "Error: Failed to download or extract the repository. $_" -ForegroundColor Red
        exit 1
    }
}

# Check if the repository directory exists
if (-not (Test-Path -Path $directoryPath)) {
    Write-Host "Repository does not exist. Proceeding with download and extraction..."

    # Variables for downloading and extracting the repository
    $repoZipUrl = "https://github.com/WOCOMLABS/kickstart.windows/archive/refs/heads/main.zip"
    $repoZipPath = "$env:USERPROFILE\dev\kickstart.windows.zip"
    $repoExtractPath = "$env:USERPROFILE\dev\kickstart.windows"

    # Download and extract the repository
    Download-And-Extract-Repo -repoUrl $repoZipUrl -zipPath $repoZipPath -extractPath $repoExtractPath
} else {
    Write-Host "Repository already exists at $directoryPath."
}

# Ensure the install.ps1 script is executable
$installScriptPath = "$directoryPath\install.ps1"
if (Test-Path -Path $installScriptPath) {
    Write-Host "Executing setup script: $installScriptPath..."
    try {
        & $installScriptPath
        Write-Host "Setup script executed successfully."
    } catch {
        Write-Host "Error: Failed to execute the setup script. $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Setup script not found at $installScriptPath. Exiting." -ForegroundColor Red
    exit 1
}
