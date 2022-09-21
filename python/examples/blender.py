import bpy
import mixbox

rgb1 = (0.0, 0.015, 0.235) # blue
rgb2 = (0.973, 0.651, 0.0) # yellow

n = 5
for i in range(0, n):
  bpy.ops.mesh.primitive_cube_add(location = ((i - n/2 + 0.5) * 3, 0, 0))
  mat = bpy.data.materials.new("material")
  mat.diffuse_color = mixbox.lerp_linear_float(rgb1, rgb2, i / (n - 1))
  bpy.context.object.active_material = mat
