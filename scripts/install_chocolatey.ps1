# Install Chocolatey
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

Write-Host "Installing Winfetch..."
choco install winfetch -y
Write-Host "Installing Git..."
choco install git -y
.\setup_git.ps1
Write-Host "Installing Starship..."
choco install starship -y
Write-Host "Installing Chocolatey Gui..."
choco install chocolateygui -y