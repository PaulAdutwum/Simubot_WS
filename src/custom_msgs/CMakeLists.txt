cmake_minimum_required(VERSION 3.5)
project(custom_msgs)

# ------------------------------------------------------------------------------
# 1) Always find ament_cmake (for building & packaging)
# ------------------------------------------------------------------------------
find_package(ament_cmake REQUIRED)

# ------------------------------------------------------------------------------
# 2) Find the ROS IDL generator so we can build .msg files
# ------------------------------------------------------------------------------
find_package(rosidl_default_generators REQUIRED)

# ------------------------------------------------------------------------------
# 3) Find any message‐package dependencies before generating interfaces
#    (std_msgs and geometry_msgs must be found first)
# ------------------------------------------------------------------------------
find_package(std_msgs REQUIRED)
find_package(geometry_msgs REQUIRED)

# ------------------------------------------------------------------------------
# 4) Generate interfaces for all .msg files under msg/
#    We now include BOTH DetectedObject.msg and DetectedObjectArray.msg
# ------------------------------------------------------------------------------
rosidl_generate_interfaces(${PROJECT_NAME}
  "msg/DetectedObject.msg"
  "msg/DetectedObjectArray.msg"
  DEPENDENCIES
    std_msgs
    geometry_msgs
)

# ------------------------------------------------------------------------------
# 5) (Optional) Enable lint/testing if BUILD_TESTING is true
# ------------------------------------------------------------------------------
if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  # Skip the copyright/license check if you haven’t added them yet:
  set(ament_cmake_copyright_FOUND TRUE)
  # Skip cpplint if your package is not in a Git repo or you haven’t added license headers:
  set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

# ------------------------------------------------------------------------------
# 6) Export this CMake package so downstream ament tools (C++/Python) can find it
# ------------------------------------------------------------------------------
ament_package()