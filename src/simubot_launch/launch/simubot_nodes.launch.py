#!/usr/bin/env python3

import os
from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node


def generate_launch_description():
    # 1) Allow sim time
    use_sim_time = LaunchConfiguration('use_sim_time', default='true')

    # 2) Choose a default turtlebot3 model
    default_model = 'waffle_pi'

    # 3) Declare a launch argument for model (optional, so user can override)
    declare_model_arg = DeclareLaunchArgument(
        'turtlebot3_model',
        default_value=default_model,
        description='Which TurtleBot3 model to spawn (burger, waffle, waffle_pi)'
    )

    # 4) Launch vision node
    vision_node = Node(
        package='simubot_vision',
        executable='vision_node',
        name='vision_node',
        output='screen',
        parameters=[{'use_sim_time': use_sim_time}]
    )

    # 5) Launch decision node
    decision_node = Node(
        package='simubot_decision',
        executable='decision_engine',
        name='decision_engine',
        output='screen',
        parameters=[{'use_sim_time': use_sim_time}]
    )

    return LaunchDescription([
        declare_model_arg,
        vision_node,
        decision_node
    ]) 