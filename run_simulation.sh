#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== SimuBot Simulation Runner ===${NC}"
echo ""

# Check if Docker container is running
if ! docker ps | grep -q inspiring_chatelet; then
    echo -e "${RED}Error: Docker container 'inspiring_chatelet' is not running!${NC}"
    echo "Please start the container first."
    exit 1
fi

echo -e "${YELLOW}Entering Docker container and setting up ROS2 environment...${NC}"

# Create a script inside the container to run everything
docker exec -it inspiring_chatelet bash -c '
# Kill any existing processes
pkill -f gazebo || true
pkill -f gzserver || true
pkill -f gzclient || true
pkill -f ros2 || true

# Source ROS2
source /opt/ros/humble/setup.bash

# Navigate to workspace
cd /home/ros2/simu_ws

# Clean build artifacts to ensure fresh start
echo "Cleaning previous build artifacts..."
rm -rf build/ install/ log/

# Build packages
echo "Building packages..."
colcon build --symlink-install

# Source the workspace
source install/setup.bash

# Export necessary environment variables
export TURTLEBOT3_MODEL=waffle_pi
export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/opt/ros/humble/share/turtlebot3_gazebo/models
export GAZEBO_PLUGIN_PATH=$GAZEBO_PLUGIN_PATH:/opt/ros/humble/lib/gazebo_plugins
export GAZEBO_MASTER_URI=http://localhost:11345
export GAZEBO_IP=127.0.0.1

echo ""
echo "=== Environment Setup Complete ==="
echo "ROS_DISTRO: $ROS_DISTRO"
echo "TURTLEBOT3_MODEL: $TURTLEBOT3_MODEL"
echo "GAZEBO_MODEL_PATH: $GAZEBO_MODEL_PATH"
echo ""

# Check if Gazebo packages are installed
if ! ros2 pkg list | grep -q gazebo_ros; then
    echo "Installing Gazebo packages..."
    sudo apt update
    sudo apt install -y ros-humble-gazebo-ros-pkgs ros-humble-turtlebot3-gazebo
fi

# Launch the simulation
echo "Launching SimuBot simulation..."
echo "This will start:"
echo "  - Gazebo with TurtleBot3 world"
echo "  - Vision node (object detection)"
echo "  - Decision engine"
echo ""

# Run with error handling
ros2 launch simubot_launch simubot_full.launch.py
' 