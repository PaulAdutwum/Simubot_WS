#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Launching SimuBot Simulation ===${NC}"

# Enable X11 forwarding
xhost +local:docker

# Kill any existing processes
docker exec -it inspiring_chatelet bash -c '
pkill -f gazebo || true
pkill -f gzserver || true
pkill -f gzclient || true
pkill -f ros2 || true

# Source ROS2 and workspace
source /opt/ros/humble/setup.bash
cd /home/ros2/simu_ws
source install/setup.bash

# Set environment variables
export TURTLEBOT3_MODEL=waffle_pi
export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/opt/ros/humble/share/turtlebot3_gazebo/models
export GAZEBO_PLUGIN_PATH=$GAZEBO_PLUGIN_PATH:/opt/ros/humble/lib/gazebo_plugins
export GAZEBO_MASTER_URI=http://localhost:11345
export GAZEBO_IP=127.0.0.1
export DISPLAY=host.docker.internal:0
export LIBGL_ALWAYS_INDIRECT=1

# Install additional dependencies if needed
sudo apt update
sudo apt install -y \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libgl1-mesa-dev \
    mesa-utils \
    x11-apps

echo -e "${YELLOW}Environment setup complete${NC}"
echo "ROS_DISTRO: $ROS_DISTRO"
echo "TURTLEBOT3_MODEL: $TURTLEBOT3_MODEL"
echo "DISPLAY: $DISPLAY"

# Launch the simulation
echo -e "${GREEN}Launching simulation...${NC}"
ros2 launch simubot_launch simubot_full.launch.py
' 