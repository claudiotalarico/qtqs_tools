#!/bin/bash

# Start XQuartz if not running
open -a XQuartz 2>/dev/null
sleep 2

xhost +localhost

# =========================== HOST DIRECTORY CONFIGURATION ===================
HOST_DESIGN_DIR="${HOST_DESIGN_DIR:-$HOME/fpga-designs}"
mkdir -p "$HOST_DESIGN_DIR"
# ============================================================================

# Extract MAC from license file
HOSTID=$(grep -i HOSTID "$HOME/licenses/questa.lic" \
         | grep -oE 'HOSTID=[0-9a-fA-F]+' \
         | head -1 \
         | sed 's/HOSTID=//' \
         | sed 's/../&:/g;s/:$//')

echo "Using MAC address: $HOSTID"

# Kill and remove any existing quartus-lite containers
docker kill $(docker ps -q --filter ancestor=quartus-lite:25.1) >/dev/null 2>&1
docker rm $(docker ps -aq --filter ancestor=quartus-lite:25.1) >/dev/null 2>&1

docker run -it \
    --mac-address="$HOSTID" \
    --platform linux/amd64 \
    -e DISPLAY=host.docker.internal:0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e SALT_LICENSE_SERVER=/licenses/questa.lic \
    -e LM_LICENSE_FILE=/licenses/questa.lic \
    -v "$HOME/licenses/questa.lic":/licenses/questa.lic:ro \
    -v "$HOST_DESIGN_DIR":/fpga-designs \
    -e DOCKER_NAME=quartus-25.1 \
    quartus-lite:25.1 \
    /bin/bash -c "
        xfce4-terminal 2>/dev/null &
        echo '========================================='
        echo ' Docker ID:' \$(hostname)
        echo '========================================='
        exec /bin/bash
    "
