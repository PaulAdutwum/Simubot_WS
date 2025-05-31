#!/usr/bin/env python3

import os
from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, SetEnvironmentVariable
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource


def generate_launch_description():
    # 1) Allow sim time
    use_sim_time = LaunchConfiguration('use_sim_time', default='true')

    # 2) Choose a default turtlebot3 model
    default_model = 'waffle_pi'

    # 3) Set the TurtleBot3 model environment variable for the entire launch
    set_tb3_model_env = SetEnvironmentVariable(
        name='TURTLEBOT3_MODEL',
        value=LaunchConfiguration('turtlebot3_model', default=default_model)
    )

    # 4) Declare a launch argument for model (optional, so user can override)
    declare_model_arg = DeclareLaunchArgument(
        'turtlebot3_model',
        default_value=default_model,
        description='Which TurtleBot3 model to spawn (burger, waffle, waffle_pi)'
    )

    # 5) Now get the actual share directory (once the env var is set)
    turtlebot3_gazebo_share = get_package_share_directory('turtlebot3_gazebo')

    spawn_turtlebot3 = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            os.path.join(
                turtlebot3_gazebo_share,
                'launch',
                'turtlebot3_world.launch.py'
            )
        ),
        launch_arguments={'model': LaunchConfiguration('turtlebot3_model'),
                          'use_sim_time': use_sim_time}.items()
    )

    vision_node = Node(
        package='simubot_vision',
        executable='vision_node',
        name='vision_node',
        output='screen',
        parameters=[{'use_sim_time': use_sim_time}]
    )

    decision_node = Node(
        package='simubot_decision',
        executable='decision_engine',
        name='decision_engine',
        output='screen',
        parameters=[{'use_sim_time': use_sim_time}]
    )

    return LaunchDescription([
        declare_model_arg,
        set_tb3_model_env,
        spawn_turtlebot3,
        vision_node,
        decision_node
    ])