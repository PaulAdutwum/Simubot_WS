#include <rclcpp/rclcpp.hpp>
#include <geometry_msgs/msg/twist.hpp>
#include <custom_msgs/msg/detected_object_array.hpp>

using std::placeholders::_1;

class DecisionEngine : public rclcpp::Node
{
public:
    DecisionEngine()
        : Node("decision_engine")
    {
        // Subscribe to object detections
        detection_sub_ = this->create_subscription<custom_msgs::msg::DetectedObjectArray>(
            "/object_detections", 10,
            std::bind(&DecisionEngine::detection_callback, this, _1));

        // Publish cmd_vel
        cmd_pub_ = this->create_publisher<geometry_msgs::msg::Twist>("/cmd_vel", 10);

        RCLCPP_INFO(this->get_logger(), "DecisionEngine node has been started.");
    }

private:
    void detection_callback(const custom_msgs::msg::DetectedObjectArray::SharedPtr msg)
    {
        if (msg->objects.empty())
        {
            RCLCPP_INFO(this->get_logger(), "No objects detected.");
            return;
        }
        // Example: stop the robot if any detection appears
        auto twist_msg = geometry_msgs::msg::Twist();
        twist_msg.linear.x = 0.0;
        twist_msg.angular.z = 0.0;
        cmd_pub_->publish(twist_msg);
        RCLCPP_INFO(this->get_logger(), "Stop command published (object detected).");
    }

    rclcpp::Subscription<custom_msgs::msg::DetectedObjectArray>::SharedPtr detection_sub_;
    rclcpp::Publisher<geometry_msgs::msg::Twist>::SharedPtr cmd_pub_;
};

int main(int argc, char *argv[])
{
    rclcpp::init(argc, argv);
    auto node = std::make_shared<DecisionEngine>();
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}