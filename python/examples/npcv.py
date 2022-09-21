import cv2
import numpy as np
import mixbox

height = 256
width = 256
img = np.zeros((height, width, 3), np.uint8)

rgb1 = (0, 33, 133)  # blue
rgb2 = (252, 211, 0) # yellow

for x in range(0, 256):
	for y in range(0, 256):
		img[x, y] = mixbox.lerp(rgb1, rgb2, x / 255.0)

cv2.imshow("image", cv2.cvtColor(img, cv2.COLOR_RGB2BGR))
cv2.waitKey(0)
