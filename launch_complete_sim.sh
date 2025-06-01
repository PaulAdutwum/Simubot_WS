#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Launching Complete SimuBot Simulation ===${NC}"

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

# Launch the complete simulation
echo "Launching complete simulation..."
docker exec -it inspiring_chatelet bash -c "
source /opt/ros/humble/setup.bash
source /home/ros2/simu_ws/install/setup.bash
export DISPLAY=host.docker.internal:0
export TURTLEBOT3_MODEL=waffle_pi

echo -e '${GREEN}Starting Gazebo with TurtleBot3...${NC}'
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py &
GAZEBO_PID=\$!

echo 'Waiting for Gazebo to start...'
sleep 10

echo -e '${GREEN}Starting SimuBot nodes...${NC}'
ros2 launch simubot_launch simubot_nodes.launch.py &
SIMUBOT_PID=\$!

echo -e '${GREEN}Simulation is running!${NC}'
echo 'Press Ctrl+C to stop the simulation'

# Wait for user to stop
wait \$GAZEBO_PID \$SIMUBOT_PID
" 