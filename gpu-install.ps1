#Requires -RunAsAdministrator

<#
 # Script to install NVIDIA GPU drivers on Windows Server 2022 Datacenter Edition.
 # This script is optimized for systems with known hardware configurations.
#>

# Check if the NVIDIA driver is already installed
function Check-Driver {
    try {
        & 'nvidia-smi.exe'
        Write-Output 'NVIDIA driver is already installed.'
        Exit
    }
    catch {
        Write-Output 'NVIDIA driver is not installed, proceeding with installation...'
    }
}

# Install the NVIDIA driver
function Install-Driver {
    Check-Driver

    $url = 'https://storage.googleapis.com/nvidia-drivers-us-public/GRID/vGPU17.1/551.78_grid_win10_win11_server2022_dch_64bit_international.exe'
    $file_dir = 'C:\NVIDIA-Driver\551.78_grid_driver.exe'
    $install_args = '/s /noeula /noreboot'

    # Ensure the directory for the driver exists
    $dirPath = 'C:\NVIDIA-Driver'
    if (!(Test-Path -Path $dirPath)) {
        New-Item -Path $dirPath -ItemType Directory | Out-Null
    }

    # Download the driver installer
    Write-Output 'Downloading the NVIDIA driver installer...'
    Invoke-WebRequest -Uri $url -OutFile $file_dir -UseBasicParsing

    # Install the driver
    Write-Output 'Installing the NVIDIA driver...'
    Start-Process -FilePath $file_dir -ArgumentList $install_args -Wait
    Write-Output 'Driver installation complete!'
}

# Start the driver installation process
Install-Driver
