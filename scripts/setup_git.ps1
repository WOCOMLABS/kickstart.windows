# Setup Git
$userName = Read-Host -Prompt "Enter your Git user name for your windows machine"
$userEmail = Read-Host -Prompt "Enter your Git user email for your windows machine"
Write-Host "Configuring Git..."
git config --global user.name "$userName"
git config --global user.email "$userEmail"
git config --global --unset credential.helper
git config --global credential.helper store