#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== SimuBot Visual Simulation ===${NC}"
echo -e "${YELLOW}Starting simulation + web dashboard...${NC}"

# Function to cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}Stopping all processes...${NC}"
    kill $DASHBOARD_PID 2>/dev/null
    docker exec inspiring_chatelet bash -c "pkill -f gazebo; pkill -f ros2" 2>/dev/null
    echo -e "${GREEN}All processes stopped.${NC}"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Start the web dashboard in background
echo -e "${BLUE}Starting web dashboard...${NC}"
python3 create_web_dashboard.py &
DASHBOARD_PID=$!

# Give dashboard time to start
sleep 2

# Start the simulation
echo -e "${BLUE}Starting simulation...${NC}"
docker exec -it inspiring_chatelet bash -c "
source /opt/ros/humble/setup.bash
source /home/ros2/simu_ws/install/setup.bash
export TURTLEBOT3_MODEL=waffle_pi

echo -e '${GREEN}Starting Gazebo physics simulation...${NC}'
gzserver /opt/ros/humble/share/turtlebot3_gazebo/worlds/turtlebot3_world.world &
SERVER_PID=\$!

sleep 5

echo -e '${GREEN}Spawning TurtleBot3...${NC}'
ros2 run gazebo_ros spawn_entity.py -entity waffle_pi -file /opt/ros/humble/share/turtlebot3_gazebo/models/turtlebot3_waffle_pi/model.sdf -x -2.0 -y -0.5 -z 0.01 &

sleep 3

echo -e '${GREEN}Starting robot state publisher...${NC}'
ros2 run robot_state_publisher robot_state_publisher --ros-args -p robot_description:=\\\"\\\$(cat /opt/ros/humble/share/turtlebot3_description/urdf/turtlebot3_waffle_pi.urdf)\\\" &

sleep 2

echo -e '${GREEN}Starting SimuBot nodes...${NC}'
ros2 launch simubot_launch simubot_nodes.launch.py &

echo -e '${BLUE}=== SIMULATION READY! ===${NC}'
echo -e '${YELLOW}🌐 Open your browser and go to: http://localhost:8080${NC}'
echo -e '${YELLOW}📊 You will see a live dashboard showing:${NC}'
echo -e '   • System status (Gazebo, Vision, Decision nodes)'
echo -e '   • Robot position and movement'
echo -e '   • Object detections from vision system'
echo -e '   • Active ROS nodes and topics'
echo -e ''
echo -e '${GREEN}Dashboard auto-refreshes every 3 seconds${NC}'
echo -e '${RED}Press Ctrl+C to stop everything${NC}'

# Keep simulation running
while true; do
    sleep 1
done
" &

# Wait for simulation to end
wait

# Cleanup
cleanup 