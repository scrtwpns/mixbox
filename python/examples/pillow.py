from PIL import Image
import mixbox

rgb1 = (0, 33, 133)  # blue
rgb2 = (252, 211, 0) # yellow

img = Image.new('RGB', (256, 256))

pixels = img.load()

width,height = img.size
for x in range(width):
    for y in range(height):
    	pixels[x, y] = mixbox.lerp(rgb1, rgb2, x / 256.0)

img.show()
