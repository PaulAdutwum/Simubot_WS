// generated from rosidl_generator_cpp/resource/idl__builder.hpp.em
// with input from custom_msgs:msg/DetectedObject.idl
// generated code does not contain a copyright notice

#ifndef CUSTOM_MSGS__MSG__DETAIL__DETECTED_OBJECT__BUILDER_HPP_
#define CUSTOM_MSGS__MSG__DETAIL__DETECTED_OBJECT__BUILDER_HPP_

#include <algorithm>
#include <utility>

#include "custom_msgs/msg/detail/detected_object__struct.hpp"
#include "rosidl_runtime_cpp/message_initialization.hpp"


namespace custom_msgs
{

namespace msg
{

namespace builder
{

class Init_DetectedObject_height
{
public:
  explicit Init_DetectedObject_height(::custom_msgs::msg::DetectedObject & msg)
  : msg_(msg)
  {}
  ::custom_msgs::msg::DetectedObject height(::custom_msgs::msg::DetectedObject::_height_type arg)
  {
    msg_.height = std::move(arg);
    return std::move(msg_);
  }

private:
  ::custom_msgs::msg::DetectedObject msg_;
};

class Init_DetectedObject_width
{
public:
  explicit Init_DetectedObject_width(::custom_msgs::msg::DetectedObject & msg)
  : msg_(msg)
  {}
  Init_DetectedObject_height width(::custom_msgs::msg::DetectedObject::_width_type arg)
  {
    msg_.width = std::move(arg);
    return Init_DetectedObject_height(msg_);
  }

private:
  ::custom_msgs::msg::DetectedObject msg_;
};

class Init_DetectedObject_y
{
public:
  explicit Init_DetectedObject_y(::custom_msgs::msg::DetectedObject & msg)
  : msg_(msg)
  {}
  Init_DetectedObject_width y(::custom_msgs::msg::DetectedObject::_y_type arg)
  {
    msg_.y = std::move(arg);
    return Init_DetectedObject_width(msg_);
  }

private:
  ::custom_msgs::msg::DetectedObject msg_;
};

class Init_DetectedObject_x
{
public:
  explicit Init_DetectedObject_x(::custom_msgs::msg::DetectedObject & msg)
  : msg_(msg)
  {}
  Init_DetectedObject_y x(::custom_msgs::msg::DetectedObject::_x_type arg)
  {
    msg_.x = std::move(arg);
    return Init_DetectedObject_y(msg_);
  }

private:
  ::custom_msgs::msg::DetectedObject msg_;
};

class Init_DetectedObject_confidence
{
public:
  explicit Init_DetectedObject_confidence(::custom_msgs::msg::DetectedObject & msg)
  : msg_(msg)
  {}
  Init_DetectedObject_x confidence(::custom_msgs::msg::DetectedObject::_confidence_type arg)
  {
    msg_.confidence = std::move(arg);
    return Init_DetectedObject_x(msg_);
  }

private:
  ::custom_msgs::msg::DetectedObject msg_;
};

class Init_DetectedObject_class_id
{
public:
  Init_DetectedObject_class_id()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_DetectedObject_confidence class_id(::custom_msgs::msg::DetectedObject::_class_id_type arg)
  {
    msg_.class_id = std::move(arg);
    return Init_DetectedObject_confidence(msg_);
  }

private:
  ::custom_msgs::msg::DetectedObject msg_;
};

}  // namespace builder

}  // namespace msg

template<typename MessageType>
auto build();

template<>
inline
auto build<::custom_msgs::msg::DetectedObject>()
{
  return custom_msgs::msg::builder::Init_DetectedObject_class_id();
}

}  // namespace custom_msgs

#endif  // CUSTOM_MSGS__MSG__DETAIL__DETECTED_OBJECT__BUILDER_HPP_
