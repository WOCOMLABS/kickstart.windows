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
}

# Variables for downloading and extracting the repository
$repoZipUrl = "https://github.com/WOCOMLABS/kickstart.windows/archive/refs/heads/main.zip"
$repoZipPath = "$env:USERPROFILE\dev\kickstart.windows.zip"
$repoExtractPath = "$env:USERPROFILE\dev\kickstart.windows"

# Download and extract the repository
Download-And-Extract-Repo -repoUrl $repoZipUrl -zipPath $repoZipPath -extractPath $repoExtractPath