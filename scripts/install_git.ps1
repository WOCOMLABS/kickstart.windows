if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Git..."
    winget install --id Git.Git -e --source winget
    $userName = Read-Host -Prompt "Enter your Git user name for your windows machine"
    $userEmail = Read-Host -Prompt "Enter your Git user email for your windows machine"
    Write-Host "Configuring Git..."
    git config --global user.name "$userName"
    git config --global user.email "$userEmail"
    git config --global init.defaultBranch main
    git config --global --unset credential.helper
    git config --global credential.helper store
}

Write-Host "Installing GitHub CLI..."
winget install -e --id GitHub.cli
Write-Host "Installing Starship..."
winget install -e --id Starship.Starship
