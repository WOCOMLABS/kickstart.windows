# Kickstart Windows Setup

This guide will help you set up your Windows Subsystem for Linux (WSL) environment with all necessary tools and configurations. Follow the steps below to get started.

## Steps to Setup

1. **Install Latest PowerShell (if not already installed):**

    Open PowerShell as an administrator and run the following command:
    ```powershell
    winget install --id Microsoft.Powershell --source winget
    ```

2. **Install Git:**

    ```powershell
    winget install --id Git.Git -e --source winget
    ```

 3. **Setup Git Config:**
    ```powershell
    git config --global user.name "Name" 
    git config --global user.email "name.lastname@domain.com"
    git config --global init.defaultBranch main
    git config --global --unset credential.helper
    git config --global credential.helper store
    ```   

4. **Clone the Repository:**

    Now that Git is installed, clone this repository by running:
    ```powershell
    git clone https://github.com/WOCOMLABS/kickstart.windows.git "$env:USERPROFILE\dev\kickstart\kickstart.windows"
    ```

5. **Run the Setup Script:**

    Navigate to the cloned repository and run the setup script:
    ```powershell
    cd $env:USERPROFILE\dev\kickstart\kickstart.windows
    .\install.ps1
    ```

## Automated Setup

Alternatively if your windows is a fresh install, you can run the following command in PowerShell to automate the entire setup process (including installing Chocolatey and Git, and then cloning and running the setup script):

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression -Command (curl -H "Cache-Control: no-cache" -H "Pragma: no-cache" 'https://raw.githubusercontent.com/WOCOMLABS/kickstart.windows/main/scripts/download_and_extract_repository.ps1?t=' + (Get-Date).Ticks | Out-String)
```

the script will prompt you to 
set your git username && git user email

later will install ubuntu and you will be asked to create a user and set its password

----

## Once in Ubuntu 

setup your git ( Optional )
```bash
git config --global user.name "Jonh Doe" && \
git config --global user. Email john.doe@domain.com && \
git config --global --unset credential.helper && \
git config --global credential.helper store

```

clone the repo into wsl  

----

> [!TIP]
> You are on a new ubuntu install just use this command

```bash
git clone https://github.com/WOCOMLABS/wsl.kickstart ~/.config/wocom && \
cd ~/.config/wocom && \
chmod u+x init.sh init_jvm.sh init_js.sh && \
./init.sh
```