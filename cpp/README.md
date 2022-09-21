## Usage
```c++
#include <stdio.h>
#include "mixbox.h"

int main() {
  unsigned char r1 =   0, g1 = 33,  b1 = 133; // blue
  unsigned char r2 = 252, g2 = 211, b2 = 0;   // yellow
  float t = 0.5;
  unsigned char r, g, b;

  mixbox_lerp(r1, g1, b1,  // first color
              r2, g2, b2,  // second color
              t,           // mixing ratio
              &r, &g, &b); // result

  printf("%d %d %d\n", r, g, b);
}
```
## Mixing Multiple Colors
```c++
mixbox_latent z1, z2, z3, z_mix;

mixbox_rgb_to_latent(r1, g1, b1, z1);
mixbox_rgb_to_latent(r2, g2, b2, z2);
mixbox_rgb_to_latent(r3, g3, b3, z3);

for (int i = 0; i < MIXBOX_LATENT_SIZE; i++) {
  // mix 30% of rgb1, 60% of rgb2, and 10% of rgb3
  z_mix[i] = 0.3f*z1[i] + 0.6f*z2[i] + 0.1f*z3[i];
}

mixbox_latent_to_rgb(z_mix, &r, &g, &b);
```

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
