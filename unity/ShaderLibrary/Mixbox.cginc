// ==========================================================
//  MIXBOX 2.0 (c) 2022 Secret Weapons. All rights reserved.
//  License: Creative Commons Attribution-NonCommercial 4.0
//  Authors: Sarka Sochorova and Ondrej Jamriska
// ==========================================================
//
//   BASIC USAGE
//
//      float3 rgb = MixboxLerp(rgb1, rgb2, t);
//
//   MULTI-COLOR MIXING
//
//      MixboxLatent z1 = MixboxRGBToLatent(rgb1);
//      MixboxLatent z2 = MixboxRGBToLatent(rgb2);
//      MixboxLatent z3 = MixboxRGBToLatent(rgb3);
//
//      // mix 30% of rgb1, 60% of rgb2, and 10% of rgb3
//      MixboxLatent z_mix = 0.3*z1 + 0.6*z2 + 0.1*z3;
//
//      float3 rgb_mix = MixboxLatentToRGB(z_mix);
//
//   PIGMENT COLORS
//
//      Cadmium Yellow              0.996, 0.925, 0.000
//      Hansa Yellow                0.988, 0.827, 0.000
//      Cadmium Orange              1.000, 0.412, 0.000
//      Cadmium Red                 1.000, 0.153, 0.008
//      Quinacridone Magenta        0.502, 0.008, 0.180
//      Cobalt Violet               0.306, 0.000, 0.259
//      Ultramarine Blue            0.098, 0.000, 0.349
//      Cobalt Blue                 0.000, 0.129, 0.522
//      Phthalo Blue                0.051, 0.106, 0.267
//      Phthalo Green               0.000, 0.235, 0.196
//      Permanent Green             0.027, 0.427, 0.086
//      Sap Green                   0.420, 0.580, 0.016
//      Burnt Sienna                0.482, 0.282, 0.000
//
//   LICENSING
//
//      If you want to obtain commercial license, please
//      contact us at: mixbox@scrtwpns.com
//

#include "Packages/com.scrtwpns.mixbox/ShaderLibrary/Mixbox.hlsl"
