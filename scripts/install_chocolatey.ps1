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
$userName = Read-Host -Prompt "Enter your Git user name for your windows machine"
$userEmail = Read-Host -Prompt "Enter your Git user email for your windows machine"
Write-Host "Configuring Git..."
git config --global user.name "$userName"
git config --global user.email "$userEmail"
git config --global --unset credential.helper
git config --global credential.helper store
Write-Host "Installing GitHub CLI..."
choco install gh -y
Write-Host "Installing Starship..."
choco install starship -y
Write-Host "Installing Chocolatey Gui..."
choco install chocolateygui -y
