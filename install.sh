#!/bin/bash

# Define installation directory
INSTALL_DIR="/usr/local/bin"
EXECUTABLE_NAME="stltostp"
REPO_URL="https://github.com/Ballistyxx/stl-to-step"

# Detect OS
ios=$(uname -s)

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        rm -rf "$foldername"
        exit 1
    fi
}

# Function to install missing dependencies on Linux
install_dependencies() {
    if [[ "$ios" == "Linux"* ]]; then
        echo "Checking for required dependencies..."
        
        # Check if make is installed
        if ! command -v make &> /dev/null; then
            echo "Installing make..."
            sudo apt update && sudo apt install -y make
            check_error "Failed to install make."
        fi
        
        # Check if cmake is installed
        if ! command -v cmake &> /dev/null; then
            echo "Installing cmake..."
            sudo apt update && sudo apt install -y cmake
            check_error "Failed to install cmake."
        fi
        
        echo "All required dependencies are installed."
    fi
}

# Clone repository with unique folder name if needed
if [ -d "stl-to-stp" ]; then
    foldername="stl-to-stp-$(date +%s)"
else
    foldername="stl-to-stp"
fi

git clone "$REPO_URL" "$foldername"
check_error "Failed to clone repository."
mv install.sh "$foldername"/
cd "$foldername" || check_error "Failed to enter repository directory."

# Install dependencies
install_dependencies

# Create build directory
mkdir -p build && cd build || check_error "Failed to create or enter build directory."

# Build the software
cmake ..
make -j$(nproc)
check_error "Build failed. Ensure you have necessary dependencies."

# Move the executable to the appropriate directory
if [[ "$ios" == Linux* ]]; then
    sudo mv "$EXECUTABLE_NAME" "$INSTALL_DIR/"
    check_error "Failed to move executable to $INSTALL_DIR."

    # Ensure the binary is in PATH
    if ! command -v "$EXECUTABLE_NAME" &> /dev/null; then
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> ~/.bashrc
        source ~/.bashrc
    fi
    
    # Remove build files after installation
    cd ../../
    rm -rf "$foldername"
elif [[ "$ios" == MINGW* ]] || [[ "$ios" == CYGWIN* ]]; then
    # Windows Git Bash or Cygwin: Install to a user-accessible location
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
    cp "$EXECUTABLE_NAME" "$INSTALL_DIR/"
    check_error "Failed to copy executable to $INSTALL_DIR."

    # Add to PATH in .bashrc or .bash_profile
    if ! grep -q "export PATH=\"$INSTALL_DIR:\$PATH\"" ~/.bashrc; then
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> ~/.bashrc
    fi
    if ! grep -q "export PATH=\"$INSTALL_DIR:\$PATH\"" ~/.bash_profile; then
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> ~/.bash_profile
    fi
    source ~/.bashrc || source ~/.bash_profile
else
    echo "Unsupported OS: $ios"
    exit 1
fi

# Confirm installation
if command -v "$EXECUTABLE_NAME" &> /dev/null; then
    echo "$EXECUTABLE_NAME successfully installed."
else
    echo "Installation failed. Try restarting your terminal."
    exit 1
fi
