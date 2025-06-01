#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Launching Headless SimuBot Simulation ===${NC}"

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

echo -e "${YELLOW}Starting simulation in headless mode...${NC}"
echo -e "${YELLOW}This will run Gazebo physics without GUI and use RViz2 for visualization${NC}"

# Launch the headless simulation
docker exec -it inspiring_chatelet bash -c "
source /opt/ros/humble/setup.bash
source /home/ros2/simu_ws/install/setup.bash
export DISPLAY=host.docker.internal:0
export TURTLEBOT3_MODEL=waffle_pi

echo -e '${GREEN}1. Starting Gazebo server (headless)...${NC}'
gzserver /opt/ros/humble/share/turtlebot3_gazebo/worlds/turtlebot3_world.world &
SERVER_PID=\$!

echo 'Waiting for Gazebo server to start...'
sleep 5

echo -e '${GREEN}2. Spawning TurtleBot3...${NC}'
ros2 run gazebo_ros spawn_entity.py -entity waffle_pi -file /opt/ros/humble/share/turtlebot3_gazebo/models/turtlebot3_waffle_pi/model.sdf -x -2.0 -y -0.5 -z 0.01 &
SPAWN_PID=\$!

sleep 3

echo -e '${GREEN}3. Starting robot state publisher...${NC}'
ros2 run robot_state_publisher robot_state_publisher --ros-args -p robot_description:=\"\$(cat /opt/ros/humble/share/turtlebot3_gazebo/models/turtlebot3_waffle_pi/model.sdf)\" &
STATE_PID=\$!

sleep 2

echo -e '${GREEN}4. Starting SimuBot nodes...${NC}'
ros2 launch simubot_launch simubot_nodes.launch.py &
SIMUBOT_PID=\$!

sleep 3

echo -e '${GREEN}5. Starting RViz2 for visualization...${NC}'
rviz2 -d /opt/ros/humble/share/turtlebot3_gazebo/rviz/tb3_gazebo.rviz &
RVIZ_PID=\$!

echo -e '${GREEN}=== Simulation Running! ===${NC}'
echo -e '${YELLOW}You should see:${NC}'
echo -e '  - RViz2 window with robot visualization'
echo -e '  - SimuBot nodes processing data'
echo -e '  - Physics simulation running in background'
echo ''
echo -e '${YELLOW}Press Enter to stop the simulation...${NC}'
read

echo 'Stopping simulation...'
kill \$SERVER_PID \$SPAWN_PID \$STATE_PID \$SIMUBOT_PID \$RVIZ_PID 2>/dev/null
pkill -f gazebo 2>/dev/null
pkill -f rviz2 2>/dev/null
echo 'Simulation stopped.'
" 