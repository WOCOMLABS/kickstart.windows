# Define the directory path
$directoryPath = "$env:USERPROFILE\dev\kickstart.windows"

# Ensure the target directory exists
$targetDirectory = "$env:USERPROFILE\dev"
if (-not (Test-Path -Path $targetDirectory)) {
    Write-Host "Creating dev ..."
    New-Item -Path $targetDirectory -ItemType Directory -Force
}

# Function to download and extract the repository
function Download-And-Extract-Repo {
    param (
        [string]$repoUrl,
        [string]$zipPath,
        [string]$extractPath
    )

    Write-Host "Downloading repository..."
    Invoke-WebRequest -Uri $repoUrl -OutFile $zipPath

    Write-Host "Extracting repository..."
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

    # Move extracted contents to the desired directory
    Move-Item -Path "$extractPath\kickstart.windows-main\*" -Destination $extractPath -Force
    Remove-Item -Path "$extractPath\kickstart.windows-main" -Recurse -Force

    # Clean up the zip file
    Remove-Item -Path $zipPath -Force
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

    Write-Host "Repository downloaded and extracted successfully!"
} else {
    Write-Host "Repository already exists at $directoryPath"
}

# Ensure the install.ps1 script is executable
$installScriptPath = "$directoryPath\install.ps1"
if (Test-Path -Path $installScriptPath) {
    Write-Host "Execution Setup ..."
    & $installScriptPath
} else {
    Write-Host "init.ps1 script not found at $installScriptPath"
}
