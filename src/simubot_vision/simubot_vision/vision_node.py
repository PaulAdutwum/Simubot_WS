#!/usr/bin/env python3
"""
simubot_vision/vision_node.py

A ROS2 node that subscribes to /camera/image_raw, converts to OpenCV, and publishes
a DetectedObjectArray (from custom_msgs) for downstream decision logic.

Currently, object detection is stubbed (publishes an empty DetectedObjectArray).
You can replace the `run_detection` method with a real model (e.g. HuggingFace/YOLO)
once you have your model downloaded and installed.
"""

import rclpy
from rclpy.node import Node
from rclpy.qos import qos_profile_sensor_data

from sensor_msgs.msg import Image
from custom_msgs.msg import DetectedObjectArray
from cv_bridge import CvBridge

# Optional imports for a real detector; comment out if not installed:
# import torch
# from transformers import AutoModelForObjectDetection, AutoFeatureExtractor

class VisionNode(Node):
    def __init__(self):
        super().__init__('vision_node')

        # Parameter to switch between real‐time or simulation time
        self.declare_parameter('use_sim_time', True)
        use_sim = self.get_parameter('use_sim_time').get_parameter_value().bool_value
        if use_sim:
            # Enable sim time (Gazebo) if requested
            self.get_logger().info('[VisionNode] Using simulation time.')
            self.set_parameters([rclpy.parameter.Parameter(
                'use_sim_time', rclpy.Parameter.Type.BOOL, True
            )])

        # CvBridge for converting ROS Image <-> OpenCV
        self.bridge = CvBridge()

        # Subscriber to the camera image (adjust topic name if needed)
        self.subscription = self.create_subscription(
            Image,
            '/camera/image_raw',
            self.image_callback,
            qos_profile_sensor_data
        )
        self.get_logger().info('[VisionNode] Subscribed to /camera/image_raw')

        # Publisher for detected objects
        self.publisher_ = self.create_publisher(
            DetectedObjectArray,
            '/object_detections',
            10
        )
        self.get_logger().info('[VisionNode] Publishing on /object_detections')

        # (Optional) If you want to load a pretrained HuggingFace model, do it here:
        # self.model = AutoModelForObjectDetection.from_pretrained('facebook/detr-resnet-50')
        # self.feature_extractor = AutoFeatureExtractor.from_pretrained('facebook/detr-resnet-50')
        # self.get_logger().info('[VisionNode] Loaded HuggingFace DETR model for object detection')

    def image_callback(self, msg: Image):
        """
        Called whenever a new Image message is received.
        Converts to OpenCV image, runs detection, and publishes results.
        """
        try:
            # Convert ROS Image to OpenCV BGR image
            cv_image = self.bridge.imgmsg_to_cv2(msg, desired_encoding='bgr8')
        except Exception as e:
            self.get_logger().error(f'[VisionNode] CvBridge error: {e}')
            return

        # Run object detection on the OpenCV image (currently stubbed):
        detections = self.run_detection(cv_image, msg.header.stamp)

        # Publish the DetectedObjectArray
        self.publisher_.publish(detections)
        self.get_logger().info('[VisionNode] Published DetectedObjectArray')

    def run_detection(self, cv_image, ros_header_stamp):
        """
        Stub method for object detection.
        Returns an empty DetectedObjectArray with the same header stamp as the input.
        Replace this logic with a real detector (e.g. HuggingFace/Torch) if desired.
        """
        detection_array = DetectedObjectArray()
        # Copy the incoming header stamp so downstream nodes know the timestamp
        detection_array.header.stamp = ros_header_stamp
        detection_array.header.frame_id = 'camera_link'  # adjust if needed

        # Example structure of DetectedObjectArray:
        # detection_array.objects = [list of DetectedObject messages]
        #
        # If you implement a real detector, fill in detection_array.objects
        # with the bounding boxes, classes, confidences, etc., computed on cv_image.

        return detection_array


def main(args=None):
    rclpy.init(args=args)
    node = VisionNode()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass

    # Clean up
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()