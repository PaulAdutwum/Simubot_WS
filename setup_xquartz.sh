#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Setting up XQuartz for Docker ===${NC}"

# Check if XQuartz is installed
if [ ! -d "/Applications/Utilities/XQuartz.app" ]; then
    echo -e "${RED}XQuartz is not installed. Please install it first:${NC}"
    echo "brew install --cask xquartz"
    exit 1
fi

# Get the IP address of the host machine
HOST_IP=$(ipconfig getifaddr en0)
if [ -z "$HOST_IP" ]; then
    HOST_IP=$(ipconfig getifaddr en1)
fi

if [ -z "$HOST_IP" ]; then
    echo -e "${RED}Error: Could not determine host IP address${NC}"
    exit 1
fi

echo "Using host IP: $HOST_IP"

# Kill any existing XQuartz processes
echo "Restarting XQuartz..."
pkill -f XQuartz
sleep 2

# Start XQuartz
open -a XQuartz
sleep 3

# Set the DISPLAY environment variable
export DISPLAY=:0

# Enable X11 forwarding
echo "Enabling X11 forwarding..."
xhost + localhost
xhost + $HOST_IP

# Test X11 forwarding
echo "Testing X11 connection..."
docker exec -it inspiring_chatelet bash -c "
export DISPLAY=host.docker.internal:0
xeyes
"

echo -e "${GREEN}=== XQuartz Setup Complete ===${NC}"
echo "If you see a pair of eyes, X11 forwarding is working correctly."
echo "You can now run the simulation with: ./launch_gazebo.sh" 