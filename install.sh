#!/bin/bash

# Define installation directory
INSTALL_DIR="/usr/local/bin"
EXECUTABLE_NAME="stltostp"
REPO_URL="https://github.com/w3gen/stl-to-stp-converter-API"

# Detect OS
ios=$(uname -s)

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Clone repository if not present
if [ ! -d "stl-to-stp-converter-API" ]; then
    git clone "$REPO_URL" stl-to-stp
    check_error "Failed to clone repository."
fi
mv install.sh stl-to-stp/
cd stl-to-stp || check_error "Failed to enter repository directory."
mkdir -p build && cd build || check_error "Failed to create or enter build directory."

# Install dependencies (Ubuntu)
if [[ "$ios" == "Linux"* ]]; then
    sudo apt update && sudo apt install -y cmake make g++
    check_error "Failed to install dependencies."
fi

# Build the software (assuming a Makefile or similar build system)
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
    source ~/.bashrc
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
