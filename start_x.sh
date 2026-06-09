#!/bin/bash

# export HOST_DESIGN_DIR="$HOME/ghome/fpga-designs"
# export DOCKER_TAG="latest"
 
OS=$(uname)
 
if [ "$OS" = "Darwin" ]; then
    echo "macOS detected — running launch_mac.sh"
    bash "$(dirname "$0")/launch_mac_wsl_qtqs_tools.sh"
 
elif [ "$OS" = "Linux" ]; then
    # WSL also reports "Linux" — check for WSL-specific indicators
    if grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
        echo "WSL detected — running launch_wsl.sh"
        bash "$(dirname "$0")/launch_mac_wsl_qtqs_toos.sh"
    else
        echo "Linux detected — running launch_linux.sh"
        bash "$(dirname "$0")/launch_linux_qtqs_tools.sh"
    fi
 
else
    echo "Unsupported OS: $OS"
    exit 1
fi
