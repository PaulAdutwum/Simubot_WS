#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== SimuBot Setup Diagnostics ===${NC}"
echo ""

# Check if Docker container is running
if ! docker ps | grep -q inspiring_chatelet; then
    echo -e "${RED}Error: Docker container 'inspiring_chatelet' is not running!${NC}"
    exit 1
fi

docker exec -it inspiring_chatelet bash -c '
# Source ROS2
source /opt/ros/humble/setup.bash

echo "=== Docker Container Info ==="
echo "Container: $(hostname)"
echo "User: $(whoami)"
echo ""

echo "=== ROS2 Environment ==="
echo "ROS_DISTRO: $ROS_DISTRO"
echo "ROS_VERSION: $ROS_VERSION"
echo ""

echo "=== Checking Workspace ==="
cd /home/ros2/simu_ws
echo "Workspace path: $(pwd)"
echo "Contents:"
ls -la
echo ""

echo "=== Checking Required Packages ==="
packages=(
    "gazebo_ros_pkgs"
    "turtlebot3_gazebo"
    "turtlebot3_description"
    "cv_bridge"
    "sensor_msgs"
    "geometry_msgs"
)

missing_packages=()
for pkg in "${packages[@]}"; do
    if ros2 pkg list | grep -q $pkg; then
        echo "✓ $pkg - installed"
    else
        echo "✗ $pkg - NOT installed"
        missing_packages+=($pkg)
    fi
done

echo ""
echo "=== Checking Python Dependencies ==="
python3 -c "
import sys
print(f\"Python version: {sys.version.split()[0]}\")
packages = [\"cv2\", \"cv_bridge\", \"rclpy\"]
for pkg in packages:
    try:
        if pkg == \"cv2\":
            import cv2
            print(f\"✓ OpenCV ({pkg}) - version {cv2.__version__}\")
        else:
            __import__(pkg)
            print(f\"✓ {pkg} - installed\")
    except ImportError:
        print(f\"✗ {pkg} - NOT installed\")
"

echo ""
echo "=== Checking if workspace is built ==="
if [ -d "install" ]; then
    echo "✓ Workspace has been built"
    echo "Packages in install directory:"
    ls install/ | grep -E "simubot|custom_msgs" | while read pkg; do
        echo "  - $pkg"
    done
else
    echo "✗ Workspace needs to be built"
fi

echo ""
if [ ${#missing_packages[@]} -gt 0 ]; then
    echo "=== Missing packages need to be installed ==="
    echo "Run this command in the container to install missing packages:"
    echo "sudo apt update && sudo apt install -y ros-humble-gazebo-ros-pkgs ros-humble-turtlebot3-gazebo ros-humble-turtlebot3-description"
fi
' 