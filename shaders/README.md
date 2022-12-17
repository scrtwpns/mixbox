## GLSL Shader
```glsl
#ifdef GL_ES
precision highp float;
#endif

// uncomment the following line if you work in linear space
// #define MIXBOX_COLORSPACE_LINEAR

uniform sampler2D mixbox_lut; // bind the "mixbox_lut.png" texture here

#include "mixbox.glsl" // paste the contents of mixbox.glsl here

void main(void)
{
    vec3 rgb1 = vec3(0, 0.129, 0.522); // blue
    vec3 rgb2 = vec3(0.988, 0.827, 0); // yellow
    float t = 0.5;                     // mixing ratio

    vec3 rgb = mixbox_lerp(rgb1, rgb2, t);

    gl_FragColor = vec4(rgb, 1.0);
}
```
```glsl
vec3 mix_three(vec3 rgb1, vec3 rgb2, vec3 rgb3)
{
    mixbox_latent z1 = mixbox_rgb_to_latent(rgb1);
    mixbox_latent z2 = mixbox_rgb_to_latent(rgb2);
    mixbox_latent z3 = mixbox_rgb_to_latent(rgb3);

    // mix together 30% of rgb1, 60% of rgb2, and 10% of rgb3
    mixbox_latent z_mix = 0.3*z1 + 0.6*z2 + 0.1*z3;

    vec3 rgb_mix = mixbox_latent_to_rgb(z_mix);

    return rgb_mix;
}
```

## HLSL Shader
```hlsl
// uncomment the following line if you work in linear space
// #define MIXBOX_COLORSPACE_LINEAR

Texture2D MixboxLUT; // bind the "mixbox_lut.png" texture here
SamplerState MixboxSampler; // FILTER_MIN_MAG_LINEAR_MIP_POINT

#define MIXBOX_LUT(UV) MixboxLUT.SampleLevel(MixboxSampler, UV, 0)

#include "mixbox.hlsl"

float4 PSMain() : SV_Target
{
    float3 rgb1 = float3(0, 0.129, 0.522); // blue
    float3 rgb2 = float3(0.988, 0.827, 0); // yellow
    float t = 0.5;                         // mixing ratio

    float3 rgb_mix = MixboxLerp(rgb1, rgb2, t);

    return float4(rgb_mix, 1.0);
}
```
```hlsl
float3 MixThree(float3 rgb1, float3 rgb2, float3 rgb3)
{
    MixboxLatent z1 = MixboxRGBToLatent(rgb1);
    MixboxLatent z2 = MixboxRGBToLatent(rgb2);
    MixboxLatent z3 = MixboxRGBToLatent(rgb3);

    // mix together 30% of rgb1, 60% of rgb2, and 10% of rgb3
    MixboxLatent zMix = 0.3*z1 + 0.6*z2 + 0.1*z3;

    float3 rgbMix = MixboxLatentToRGB(zMix);

    return rgbMix;
}
```

## Metal Shader
```metal
#include <metal_stdlib>
using namespace metal;

// uncomment the following line if you work in linear space
// #define MIXBOX_COLORSPACE_LINEAR

#include "mixbox.metal"

fragment float4 // load "mixbox_lut.png" into texture 0
fragment_main(texture2d<float> mixbox_lut [[texture(0)]])
{
    float3 rgb1 = float3(0, 0.129, 0.522); // blue
    float3 rgb2 = float3(0.988, 0.827, 0); // yellow

    float t = 0.5; // mixing ratio

    float3 rgb_mix = mixbox_lerp(mixbox_lut, rgb1, rgb2, t);

    return float4(rgb_mix, 1.0);
}
```
```metal
float3 mix_three(texture2d<float> mixbox_lut,
                 float3 rgb1, float3 rgb2, float3 rgb3)
{
    mixbox_latent z1 = mixbox_rgb_to_latent(mixbox_lut, rgb1);
    mixbox_latent z2 = mixbox_rgb_to_latent(mixbox_lut, rgb2);
    mixbox_latent z3 = mixbox_rgb_to_latent(mixbox_lut, rgb3);

    // mix together 30% of rgb1, 60% of rgb2, and 10% of rgb3
    mixbox_latent z_mix = 0.3*z1 + 0.6*z2 + 0.1*z3;

    float3 rgb_mix = mixbox_latent_to_rgb(z_mix);

    return rgb_mix;
}
```

## OSL Shader
```c
#include "mixbox.osl"

shader mix(
    color rgb1 = color(0.0, 0.015, 0.235), // blue
    color rgb2 = color(0.973, 0.651, 0.0), // yellow
    float t = 0.5,                         // mixing ratio
    output color rgb_mix = 0
  )
{
    rgb_mix = mixbox_lerp(rgb1, rgb2, t);
}
```
```c
color mix_three(color rgb1, color rgb2, color rgb3)
{
    mixbox_latent z1 = mixbox_rgb_to_latent(rgb1);
    mixbox_latent z2 = mixbox_rgb_to_latent(rgb2);
    mixbox_latent z3 = mixbox_rgb_to_latent(rgb3);

    // mix together 30% of rgb1, 60% of rgb2, and 10% of rgb3
    mixbox_latent z_mix = 0.3*z1 + 0.6*z2 + 0.1*z3;

    color rgb_mix = mixbox_latent_to_rgb(z_mix);

    return rgb_mix;
}
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
