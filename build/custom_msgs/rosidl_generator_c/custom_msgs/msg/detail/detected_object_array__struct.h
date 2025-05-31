// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from custom_msgs:msg/DetectedObjectArray.idl
// generated code does not contain a copyright notice

#ifndef CUSTOM_MSGS__MSG__DETAIL__DETECTED_OBJECT_ARRAY__STRUCT_H_
#define CUSTOM_MSGS__MSG__DETAIL__DETECTED_OBJECT_ARRAY__STRUCT_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// Constants defined in the message

// Include directives for member types
// Member 'header'
#include "std_msgs/msg/detail/header__struct.h"
// Member 'objects'
#include "custom_msgs/msg/detail/detected_object__struct.h"

/// Struct defined in msg/DetectedObjectArray in the package custom_msgs.
/**
  * Header plus array of detected objects
 */
typedef struct custom_msgs__msg__DetectedObjectArray
{
  std_msgs__msg__Header header;
  custom_msgs__msg__DetectedObject__Sequence objects;
} custom_msgs__msg__DetectedObjectArray;

// Struct for a sequence of custom_msgs__msg__DetectedObjectArray.
typedef struct custom_msgs__msg__DetectedObjectArray__Sequence
{
  custom_msgs__msg__DetectedObjectArray * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} custom_msgs__msg__DetectedObjectArray__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // CUSTOM_MSGS__MSG__DETAIL__DETECTED_OBJECT_ARRAY__STRUCT_H_
