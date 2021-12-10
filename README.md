# Mixbox: Practical Pigment Mixing for Digital Painting

<p align="center">
  <img src="https://scrtwpns.com/mixbox/teaser.jpg"/>
</p>

Mixbox is a pigment mixing black-box. You pass RGB colors in and get the mixed RGB out.
Internally, Mixbox treats the colors as if they were made of actual real-world pigments.
It uses the Kubelka & Munk theory to predict the color of the resulting mixture.
This way, Mixbox achieves that blue and yellow mix to green, the same way real pigments do.

* Paper: https://scrtwpns.com/mixbox.pdf<br>
* Video: https://youtu.be/ATzVPVNp1qA<br>
* Talk: https://youtu.be/_qa5iWdfNKg<br>

Mixbox is shipping in the upcoming Rebelle 5 as the [Rebelle Pigments](https://www.escapemotions.com/blog/rebelle-5-meet-color-pigments) feature.

## Usage
The simplest way to use Mixbox is with the *lerp* interface:
```c++
#include <stdio.h>
#include "mixbox.h"

int main()
{
  unsigned char r1=252, g1=211, b1=0;  // bright yellow
  unsigned char r2=0,   g2=0,   b2=96; // deep blue
  float t = 0.5;
  unsigned char r,g,b;
  
  mixbox_lerp_srgb8(r1,g1,b1,   // first color
                    r2,g2,b2,   // second color
                    t,          // mixing ratio
                    &r,&g,&b);  // result

  printf("%d %d %d\n",r,g,b);
}
```
Alternatively, one can use the *latent* interface. This allows mixing multiple RGB colors at once using arbitrary weights:

```c++
float latent1[MIXBOX_NUMLATENTS];
float latent2[MIXBOX_NUMLATENTS];
float latentMix[MIXBOX_NUMLATENTS];

mixbox_srgb8_to_latent(r1,g1,b1,latent1);
mixbox_srgb8_to_latent(r2,g2,b2,latent2);

for(int i=0;i<MIXBOX_NUMLATENTS;i++)
{ 
  latentMix[i] = (1.0f-t)*latent1[i] + t*latent2[i]; 
}

mixbox_latent_to_srgb8(latentMix,&r,&g,&b);  
```

## License
Copyright (c) 2021, Secret Weapons. All rights reserved.<br>
This code is for non-commercial use only. It is provided for research and evaluation purposes.<br>
If you wish to obtain commercial license, please contact: mixbox@scrtwpns.com

