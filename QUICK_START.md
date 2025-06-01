# SimuBot Quick Start Guide

## Overview

SimuBot is a ROS2-based robot simulation that combines computer vision with autonomous decision-making using TurtleBot3 in Gazebo.

## Prerequisites

- Docker installed and running
- X11 forwarding enabled (for GUI applications like Gazebo)
- Docker container `inspiring_chatelet` running

## Quick Start Scripts

I've created three helper scripts to make running the simulation easy:

### 1. **check_setup.sh** - Diagnostic Tool

Checks if all required packages and dependencies are installed.

```bash
./check_setup.sh
```

### 2. **enter_container.sh** - Container Access

Enter the Docker container with ROS2 environment pre-configured.

```bash
./enter_container.sh
```

### 3. **run_simulation.sh** - Launch Simulation

Automatically builds the workspace and launches the full simulation.

```bash
./run_simulation.sh
```

## First Time Setup

1. **Run diagnostics** to see what needs to be installed:

   ```bash
   ./check_setup.sh
   ```

2. **If packages are missing**, enter the container and install them:

   ```bash
   ./enter_container.sh
   # Inside container:
   sudo apt update
   sudo apt install -y ros-humble-gazebo-ros-pkgs ros-humble-turtlebot3-gazebo
   sudo apt install -y python3-opencv
   exit
   ```

3. **Launch the simulation**:
   ```bash
   ./run_simulation.sh
   ```

## What the Simulation Does

When running, you'll see:

- **Gazebo**: 3D simulation environment with TurtleBot3 robot
- **Vision Node**: Processes camera images (currently stubbed)
- **Decision Engine**: Makes movement decisions based on detected objects

## Troubleshooting

### Display Issues

If Gazebo doesn't open, ensure X11 forwarding is enabled:

```bash
# On macOS:
xhost +local:docker

# On Linux:
xhost +local:root
```

### Build Errors

If the build fails, try cleaning and rebuilding:

```bash
./enter_container.sh
# Inside container:
rm -rf build/ install/ log/
colcon build --symlink-install
```

### Missing Topics/Nodes

Check if all nodes are running:

```bash
./enter_container.sh
# Inside container:
ros2 node list
ros2 topic list
```

## Manual Control (Optional)

To manually control the robot while the simulation is running:

```bash
# In a new terminal:
./enter_container.sh
# Inside container:
ros2 run turtlebot3_teleop teleop_keyboard
```

## Next Steps

Once the basic simulation is running, you can:

1. Implement real object detection in `src/simubot_vision/simubot_vision/vision_node.py`
2. Enhance decision logic in `src/simubot_decision/src/decision_engine.cpp`
3. Add more sensors or modify the robot model

## System Architecture

```
Camera (/camera/image_raw)
    ↓
Vision Node (Object Detection)
    ↓
/object_detections topic
    ↓
Decision Engine
    ↓
/cmd_vel (Robot Movement Commands)
```
