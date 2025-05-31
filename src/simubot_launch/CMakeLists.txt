cmake_minimum_required(VERSION 3.5)
project(simubot_launch)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# ------------------------------------------------------------------------------
# 1) Findable CMake packages (pure-C++/CMake dependencies)
# ------------------------------------------------------------------------------

find_package(ament_cmake REQUIRED)
find_package(gazebo_ros REQUIRED)
find_package(turtlebot3_description REQUIRED)

# (We do NOT call find_package(simubot_vision) or find_package(simubot_decision)
#  because those are ament_python packages—they do not provide CMake config files.)

# ------------------------------------------------------------------------------
# 2) Install the launch/ directory into share/ so 'ros2 launch' can see it
# ------------------------------------------------------------------------------

install(
  DIRECTORY launch/
  DESTINATION share/${PROJECT_NAME}
)

# ------------------------------------------------------------------------------
# 3) Export the ament package
# ------------------------------------------------------------------------------
ament_package()