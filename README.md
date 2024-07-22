# Kickstart Windows Setup

This guide will help you set up your Windows Subsystem for Linux (WSL) environment with all necessary tools and configurations. Follow the steps below to get started.

## Steps to Setup

1. **Install Latest PowerShell (if not already installed):**

    Open PowerShell as an administrator and run the following command:
    ```powershell
    winget install --id Microsoft.Powershell --source winget
    ```

2. **Install Chocolatey:**

    If Chocolatey is not already installed, open PowerShell as an administrator and run the following command:
    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    ```

3. **Install Git:**

    Once Chocolatey is installed, you can install Git by running the following command in PowerShell:
    ```powershell
    choco install git -y
    ```

 3. **Install Chocolatey Gui:**

    Once Chocolatey is installed, you can install Chocolatey Gui by running the following command in PowerShell:
    ```powershell
     choco install chocolateygui -y
    ```   

4. **Clone the Repository:**

    Now that Git is installed, clone this repository by running:
    ```powershell
    git clone https://github.com/WOCOMLABS/kickstart.windows.git "$env:USERPROFILE\kickstart\kickstart.windows"
    ```

5. **Run the Setup Script:**

    Navigate to the cloned repository and run the setup script:
    ```powershell
    cd %USERPROFILE%\kickstart\kickstart.windows
    .\init.ps1
    ```

## Automated Setup

Alternatively if your windows is a fresh install, you can run the following command in PowerShell to automate the entire setup process (including installing Chocolatey and Git, and then cloning and running the setup script):

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression -Command (curl -H "Cache-Control: no-cache" -H "Pragma: no-cache" 'https://raw.githubusercontent.com/WOCOMLABS/kickstart.windows/main/scripts/download_and_extract_repository.ps1?t=' + (Get-Date).Ticks | Out-String)
```

the script will prompt you to 
set your git username && git user email

later will install ubuntu and you will be asked to create a user and set its password
