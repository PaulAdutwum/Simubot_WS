#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Testing Gazebo Display ===${NC}"

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

# Enable X11 forwarding
echo "Enabling X11 forwarding..."
xhost + localhost
xhost + $HOST_IP

# Test simple X11 first
echo "Testing X11 with a simple application..."
docker exec -it inspiring_chatelet bash -c "
export DISPLAY=host.docker.internal:0
export LIBGL_ALWAYS_INDIRECT=1
xclock &
sleep 3
pkill xclock
"

# Launch Gazebo with debug info
echo "Launching Gazebo with debug..."
docker exec -it inspiring_chatelet bash -c "
source /opt/ros/humble/setup.bash
source /home/ros2/simu_ws/install/setup.bash
export DISPLAY=host.docker.internal:0
export LIBGL_ALWAYS_INDIRECT=1
export GAZEBO_MASTER_URI=http://localhost:11345
export TURTLEBOT3_MODEL=waffle_pi

echo 'Starting Gazebo server only first...'
gzserver /opt/ros/humble/share/turtlebot3_gazebo/worlds/turtlebot3_world.world &
SERVER_PID=\$!

sleep 5

echo 'Now starting Gazebo client...'
gzclient --verbose &
CLIENT_PID=\$!

echo 'Gazebo should now be visible. Press Enter to stop...'
read
kill \$SERVER_PID \$CLIENT_PID
" 