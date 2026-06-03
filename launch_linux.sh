#!/bin/bash

killall socat 2>/dev/null
sleep 1          # give the killing of socat a moment 
socat TCP-LISTEN:6010,reuseaddr,fork UNIX-CONNECT:/tmp/.X11-unix/X0 2>/dev/null &
sleep 1          # give socat a moment to bind the port

# ========================== HOST DIRECTORY CONFIGURATION ====================
# If HOST_DESIGN_DIR is passed from the outside, use it. 
# Otherwise, default to ~/fpga_design
HOST_DESIGN_DIR="${HOST_DESIGN_DIR:-$HOME/fpga-designs}"

# Create the host directory if it doesn't exist yet
mkdir -p "$HOST_DESIGN_DIR"
# ============================================================================

# ========================== DOCKER_TAG CONFIGURATION ========================
# If DOCKER_TAG is passed from the outside, use it. Otherwise, default to 25.1
DOCKER_TAG="${DOCKER_TAG:-25.1}"

# Generate a temporary Xauthority file with a cookie valid for host.docker.internal
XAUTH_TMP=$(mktemp "$HOME/.xauth_tmp_XXXXX") 
xauth nlist "$DISPLAY" | sed 's/^..../ffff/' | xauth -f "$XAUTH_TMP" nmerge -

xhost +localhost

# Extract MAC from HOSTID= field specifically
HOSTID=$(grep -i HOSTID "$HOME/licenses/questa.lic" \
         | grep -oP 'HOSTID=\K[0-9a-fA-F]+' \
         | head -1 \
         | sed 's/../&:/g;s/:$//')

echo "Using MAC address: $HOSTID"

# Kill and remove any existing quartus-lite containers
docker kill $(docker ps -q --filter ancestor=quartus-lite:25.1) 2>/dev/null
docker rm $(docker ps -aq --filter ancestor=quartus-lite:25.1) 2>/dev/null

# pull the image from Docker Hub
docker pull ctalarico/qtqs_tools:$DOCKER_TAG

docker run -it \
    --mac-address="$HOSTID" \
    -e DISPLAY=host.docker.internal:10 \
    -e XAUTHORITY=/tmp/.Xauthority \
    -v "$XAUTH_TMP":/tmp/.Xauthority:ro \
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

