$INSTALL_DIR = "C:\Program Files\stltostp"
$EXECUTABLE_NAME = "stltostp.exe"
$REPO_URL = "https://github.com/Ballistyxx/stl-to-step"
$FOLDER_NAME = "stl-to-stp"

# Function to check for errors
function Check-Error {
    param($Message)
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: $Message" -ForegroundColor Red
        exit 1
    }
}

# Ensure running as Administrator
$adminCheck = [System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run PowerShell as Administrator." -ForegroundColor Red
    exit 1
}

# Install Git if not installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed. Please install Git and try again." -ForegroundColor Red
    exit 1
}

# Install CMake if not installed
if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Host "CMake is not installed. Please install CMake and try again." -ForegroundColor Red
    exit 1
}

# Rename folder if it already exists
if (Test-Path $FOLDER_NAME) {
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    Rename-Item -Path $FOLDER_NAME -NewName "$FOLDER_NAME-$timestamp"
}

# Clone repository
git clone $REPO_URL $FOLDER_NAME
Check-Error "Failed to clone repository."

# Enter repository
Set-Location $FOLDER_NAME

# Create build directory
New-Item -ItemType Directory -Path "build" -Force | Out-Null
Set-Location build

# Run CMake and build
cmake ..
Check-Error "CMake configuration failed."

cmake --build . --config Release
Check-Error "Build failed."

# Ensure install directory exists
New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null

# Move executable to install directory
Move-Item -Path ".\$EXECUTABLE_NAME" -Destination "$INSTALL_DIR\$EXECUTABLE_NAME" -Force
Check-Error "Failed to move executable to $INSTALL_DIR"

# Add to system PATH
$CurrentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
if ($CurrentPath -notlike "*$INSTALL_DIR*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$INSTALL_DIR;$CurrentPath", [System.EnvironmentVariableTarget]::Machine)
    Write-Host "Added $INSTALL_DIR to system PATH. Restart your terminal to use $EXECUTABLE_NAME."
}

# Cleanup
Set-Location ../..
Remove-Item -Recurse -Force $FOLDER_NAME
Write-Host "$EXECUTABLE_NAME successfully installed!" -ForegroundColor Green
