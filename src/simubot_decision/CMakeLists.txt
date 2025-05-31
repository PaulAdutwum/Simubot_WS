cmake_minimum_required(VERSION 3.5)
project(simubot_decision)

# 1) Require C++17 (or C++14 if you prefer)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# 2) Find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(custom_msgs REQUIRED)    # This must match the custom_msgs package name

# 3) Include directories (if you have any headers under include/)
include_directories(include)

# 4) Add the executable
#    Assumes your source file is located at src/decision_engine.cpp
add_executable(decision_engine
  src/decision_engine.cpp
)

# 5) Specify libraries or dependencies to link against
ament_target_dependencies(decision_engine
  rclcpp
  geometry_msgs
  custom_msgs
)

# 6) Install the executable into lib/simubot_decision/
install(TARGETS
  decision_engine
  DESTINATION lib/${PROJECT_NAME}
)

# 7) Export package (necessary for ament)
ament_package()