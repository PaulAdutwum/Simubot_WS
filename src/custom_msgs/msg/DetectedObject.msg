# A single detected object in an image frame

# “class_id” is the integer ID of the detected class (e.g. 0=person, 1=bicycle, etc.)
int32 class_id

# “confidence” is the detection confidence score (0.0 to 1.0)
float32 confidence

# Bounding box, expressed in pixel coordinates (x, y = top-left; width, height)
float32 x
float32 y
float32 width
float32 height