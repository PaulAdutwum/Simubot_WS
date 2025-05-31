// NOLINT: This file starts with a BOM since it contain non-ASCII characters
// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from custom_msgs:msg/DetectedObject.idl
// generated code does not contain a copyright notice

#ifndef CUSTOM_MSGS__MSG__DETAIL__DETECTED_OBJECT__STRUCT_H_
#define CUSTOM_MSGS__MSG__DETAIL__DETECTED_OBJECT__STRUCT_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// Constants defined in the message

/// Struct defined in msg/DetectedObject in the package custom_msgs.
/**
  * A single detected object in an image frame
 */
typedef struct custom_msgs__msg__DetectedObject
{
  /// “class_id” is the integer ID of the detected class (e.g. 0=person, 1=bicycle, etc.)
  int32_t class_id;
  /// “confidence” is the detection confidence score (0.0 to 1.0)
  float confidence;
  /// Bounding box, expressed in pixel coordinates (x, y = top-left; width, height)
  float x;
  float y;
  float width;
  float height;
} custom_msgs__msg__DetectedObject;

// Struct for a sequence of custom_msgs__msg__DetectedObject.
typedef struct custom_msgs__msg__DetectedObject__Sequence
{
  custom_msgs__msg__DetectedObject * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} custom_msgs__msg__DetectedObject__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // CUSTOM_MSGS__MSG__DETAIL__DETECTED_OBJECT__STRUCT_H_
