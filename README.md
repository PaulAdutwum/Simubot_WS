# SimuBot: Autonomous Robot Simulation with ROS 2 & Gazebo

**SimuBot** is a complete, end-to-end robotics demo showcasing perception, decision-making, and autonomous navigation in a 3D simulated environment. Built on ROS 2 Humble and Gazebo 11, SimuBot drives a TurtleBot3-inspired “TattooBot” through a dynamic arena, detecting obstacles and making real-time motion decisions. This project is designed to be **easily reproducible** on Ubuntu 22.04 (WSL2/VM/dual-boot) or any Linux machine, and can run headless or with a full Gazebo GUI.


## 🔥 Features

- **Custom ROS 2 Messages**  
  - `custom_msgs/msg/DetectedObject.msg`  
  - `custom_msgs/msg/DetectedObjectArray.msg`  
  - Automatically generated C++/Python interfaces via `rosidl_generate_interfaces`.

- **simubot_vision (Python)**  
  - Subscribes to `/camera/image_raw` via CV-Bridge.  
  - Publishes `DetectedObjectArray` on `/object_detections` (stubbed or real inference).  
  - Easily extendable to load a HuggingFace DETR or YOLOv8 model.

- **simubot_decision (C++)**  
  - Subscribes to `/object_detections`.  
  - Implements simple obstacle-avoidance: turn left if an obstacle is too close; otherwise drive forward.  
  - Publishes velocity commands (`geometry_msgs/Twist`) on `/cmd_vel`.

- **simubot_launch (Python)**  
  - Single launch file (`simubot_full.launch.py`) that:  
    1. Launches a headless Gazebo world with static boxes and a moving “person” cylinder.  
    2. Spawns a TurtleBot3-based “TattooBot” URDF with an added “tattoo arm” link.  
    3. Starts `vision_node` and `decision_engine` with `use_sim_time=true`.  
    4. Accepts a `gui` argument—`gui:=false` runs headless (`gzserver`), `gui:=true` includes `gzclient` for full GUI.

---

## 🌍 Real-World Problem Solved

SimuBot demonstrates core self-driving capabilities:
- **Perception → Detection:** Simulated camera captures images; vision node extracts object bounding boxes.  
- **Decision → Control:** Decision node consumes detections, applies obstacle-avoidance logic, and publishes drive commands.  
- **Simulation → Safety:** Everything runs in Gazebo, so there’s no risk to real hardware. This pipeline mirrors real industrial, logistics, and service-robot applications where autonomous navigation is critical.

---

## 🛠️ Tech Stack

- **ROS 2 Humble** – Node orchestration, messaging, and packaging.  
- **Gazebo 11** – 3D physics simulation, robot models, and world files.  
- **Python 3.10 / rclpy** – Vision node, launch files.  
- **C++17 / rclcpp** – Decision node, custom message bridging.  
- **CV-Bridge** – Converts ROS `sensor_msgs/Image` ↔ OpenCV.  
- **Custom ROS 2 Messages** – `DetectedObject` & `DetectedObjectArray` in `custom_msgs`.  
- **Build Tools & Dependencies**:  
  - `colcon` – Workspace building  
  - `rviz2` (optional) – Visualizing topics and TF  
  - `libgl1-mesa-dri` + `libgl1-mesa-glx` – Software OpenGL fallback for Gazebo  
  - (Optional) PyTorch / HuggingFace packages for real object detector integration  

---

## 📦 Installation & Quick Start

> All commands below assume Ubuntu 22.04 (native or WSL2) with an X server configured (e.g. VcXsrv on Windows).

### Prerequisites

1. **Ubuntu 22.04 (x86_64) or WSL2**  
2. **ROS 2 Humble Desktop-Full**  
3. **Gazebo 11 and TurtleBot3 packages**  
4. **CV-Bridge and colcon build tools**  
5. **X server for Gazebo GUI** (VcXsrv on Windows / XQuartz on macOS—GUI is optional)

---

### Workspace Setup

```bash
# 1. Update & install locales
sudo apt update
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# 2. Add ROS 2 Humble repository & keys
sudo apt install -y software-properties-common gnupg2 lsb-release curl
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu \
  $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

# 3. Install ROS 2 Humble desktop-full
sudo apt update
sudo apt install -y ros-humble-desktop

# 4. Install build tools & dependencies
sudo apt install -y \
  python3-colcon-common-extensions python3-pip python3-rosdep python3-vcstool \
  build-essential git cmake \
  libopencv-dev python3-opencv python3-cv-bridge \
  libgl1-mesa-dri libgl1-mesa-glx

# 5. Initialize rosdep
sudo rosdep init || true
rosdep update

# 6. Install Gazebo ROS packages and TurtleBot3
sudo apt install -y \
  ros-humble-gazebo-ros-pkgs \
  ros-humble-turtlebot3-gazebo \
  ros-humble-turtlebot3-msgs

# 7. Create and enter workspace
mkdir -p ~/simubot_ws/src
cd ~/simubot_ws/src

# 8. Clone or copy your four packages here:
#    - custom_msgs
#    - simubot_vision
#    - simubot_decision
#    - simubot_launch
#
#    Example (if hosted on GitHub):
# git clone https://github.com/YourUsername/custom_msgs.git
# git clone https://github.com/YourUsername/simubot_vision.git
# git clone https://github.com/YourUsername/simubot_decision.git
# git clone https://github.com/YourUsername/simubot_launch.git

#    If you already have these folders locally, simply copy them into ~/simubot_ws/src/
