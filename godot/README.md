# Mixbox for Godot
```gdscript
var Mixbox = preload("res://addons/mixbox/mixbox.gd")

var color1 = Color(0.0, 0.129, 0.522) # blue
var color2 = Color(0.988, 0.827, 0.0) # yellow
var t = 0.5                           # mixing ratio

var color_mix = Mixbox.lerp(color1, color2, t)

print(color_mix)
```

## Mixing Multiple Colors
```gdscript
var z1 = Mixbox.rgb_to_latent(color1)
var z2 = Mixbox.rgb_to_latent(color2)
var z3 = Mixbox.rgb_to_latent(color3)

var z_mix = []
z_mix.resize(Mixbox.LATENT_SIZE)

for i in z_mix.size():          # mix together:
    z_mix[i] = (0.3*z1[i] +     # 30% of color1
                0.6*z2[i] +     # 60% of color2
                0.1*z3[i])      # 10% of color3

var color_mix = Mixbox.latent_to_rgb(z_mix)
```

# Shader
```c++
shader_type canvas_item;

uniform sampler2D mixbox_lut; // attach "addons/mixbox/mixbox_lut.png" here

uniform vec4 color1 : hint_color = vec4(0.0, 0.129, 0.522, 1.0); // blue
uniform vec4 color2 : hint_color = vec4(0.988, 0.827, 0.0, 1.0); // yellow

// #include only works in Godot 4, if you are on Godot 3.X
// you will need to paste the Mixbox code here manually.
#include "addons/mixbox/mixbox.gdshaderinc"

void fragment() {
    COLOR = mixbox_lerp(color1, color2, UV.x);
}
```
<p align="center">
  <img src="https://scrtwpns.com/mixbox/godot/mixboxlut-howto.png"/>
</p>

## Mixing Multiple Colors

```glsl
mat3 z1 = mixbox_rgb_to_latent(color1.rgb);
mat3 z2 = mixbox_rgb_to_latent(color2.rgb);
mat3 z3 = mixbox_rgb_to_latent(color3.rgb);

// mix together 30% of color1, 60% of color2, and 10% of color3
mat3 z_mix = 0.3*z1 + 0.6*z2 + 0.1*z3;

vec3 rgb_mix = mixbox_latent_to_rgb(z_mix);
```

# VisualShader
<p align="center">
  <img src="https://scrtwpns.com/mixbox/godot/visualshader_.png"/>
</p>

## Pigment Colors
| Pigment |  | RGB | Float RGB | Linear RGB |
| --- | --- |:----:|:----:|:----:|
| Cadmium Yellow | <img src="https://scrtwpns.com/mixbox/pigments/cadmium_yellow.png"/> | 254, 236, 0  | 0.996, 0.925, 0.0 | 0.991, 0.839, 0.0 |
| Hansa Yellow | <img src="https://scrtwpns.com/mixbox/pigments/hansa_yellow.png"/> | 252, 211, 0  | 0.988, 0.827, 0.0 | 0.973, 0.651, 0.0 |
| Cadmium Orange | <img src="https://scrtwpns.com/mixbox/pigments/cadmium_orange.png"/> | 255, 105, 0  | 1.0, 0.412, 0.0 | 1.0, 0.141, 0.0 |
| Cadmium Red | <img src="https://scrtwpns.com/mixbox/pigments/cadmium_red.png"/> | 255, 39, 2  | 1.0, 0.153, 0.008 | 1.0, 0.02, 0.001 |
| Quinacridone Magenta | <img src="https://scrtwpns.com/mixbox/pigments/quinacridone_magenta.png"/> | 128, 2, 46  | 0.502, 0.008, 0.18 | 0.216, 0.001, 0.027 |
| Cobalt Violet | <img src="https://scrtwpns.com/mixbox/pigments/cobalt_violet.png"/> | 78, 0, 66  | 0.306, 0.0, 0.259 | 0.076, 0.0, 0.054 |
| Ultramarine Blue | <img src="https://scrtwpns.com/mixbox/pigments/ultramarine_blue.png"/> | 25, 0, 89  | 0.098, 0.0, 0.349 | 0.01, 0.0, 0.1 |
| Cobalt Blue | <img src="https://scrtwpns.com/mixbox/pigments/cobalt_blue.png"/> | 0, 33, 133  | 0.0, 0.129, 0.522 | 0.0, 0.015, 0.235 |
| Phthalo Blue | <img src="https://scrtwpns.com/mixbox/pigments/phthalo_blue.png"/> | 13, 27, 68  | 0.051, 0.106, 0.267 | 0.004, 0.011, 0.058 |
| Phthalo Green | <img src="https://scrtwpns.com/mixbox/pigments/phthalo_green.png"/> | 0, 60, 50  | 0.0, 0.235, 0.196 | 0.0, 0.045, 0.032 |
| Permanent Green | <img src="https://scrtwpns.com/mixbox/pigments/permanent_green.png"/> | 7, 109, 22  | 0.027, 0.427, 0.086 | 0.002, 0.153, 0.008 |
| Sap Green | <img src="https://scrtwpns.com/mixbox/pigments/sap_green.png"/> | 107, 148, 4  | 0.42, 0.58, 0.016 | 0.147, 0.296, 0.001 |
| Burnt Sienna | <img src="https://scrtwpns.com/mixbox/pigments/burnt_sienna.png"/> | 123, 72, 0  | 0.482, 0.282, 0.0 | 0.198, 0.065, 0.0 |

## License
Copyright (c) 2022, Secret Weapons. All rights reserved.<br>
Mixbox is provided under the CC BY-NC 4.0 license for non-commercial use only.<br>
If you want to obtain commercial license, please contact: mixbox@scrtwpns.com
