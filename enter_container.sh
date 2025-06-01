#!/bin/bash

echo "Entering Docker container with ROS2 environment..."
docker exec -it inspiring_chatelet bash -c "
source /opt/ros/humble/setup.bash
cd /home/ros2/simu_ws
if [ -d 'install' ]; then
    source install/setup.bash
fi
export TURTLEBOT3_MODEL=waffle_pi
echo ''
echo '=== ROS2 Environment Ready ==='
echo 'ROS_DISTRO: $ROS_DISTRO'
echo 'Workspace: /home/ros2/simu_ws'
echo 'TURTLEBOT3_MODEL: $TURTLEBOT3_MODEL'
echo ''
echo 'Useful commands:'
echo '  ros2 topic list              - List all ROS topics'
echo '  ros2 node list               - List all running nodes'
echo '  ros2 launch simubot_launch simubot_full.launch.py  - Launch simulation'
echo ''
exec bash
" 