// ==========================================================
//  MIXBOX 2.0 (c) 2022 Secret Weapons. All rights reserved.
//  License: Creative Commons Attribution-NonCommercial 4.0
//  Authors: Sarka Sochorova and Ondrej Jamriska
// ==========================================================
//
//   BASIC USAGE
//
//      mixbox_lerp(r1, g1, b1,          // 1st color
//                  r2, g2, b2,          // 2nd color
//                  t,                   // mixing ratio
//                  &r, &g, &b);         // result
//
//   MULTI-COLOR MIXING
//
//      mixbox_latent z1, z2, z3, z_mix;
//      mixbox_rgb_to_latent(r1, g1, b1, z1);
//      mixbox_rgb_to_latent(r2, g2, b2, z2);
//      mixbox_rgb_to_latent(r3, g3, b3, z3);
//
//      for (int i = 0; i < MIXBOX_LATENT_SIZE; i++) {
//        // mix 30% of rgb1, 60% of rgb2, and 10% of rgb3
//        z_mix[i] = 0.3f*z1[i] + 0.6f*z2[i] + 0.1f*z3[i];
//      }
//
//      mixbox_latent_to_rgb(z_mix, &r, &g, &b);
//
//   PIGMENT COLORS
//
//      Cadmium Yellow                    254, 236,   0
//      Hansa Yellow                      252, 211,   0
//      Cadmium Orange                    255, 105,   0
//      Cadmium Red                       255,  39,   2
//      Quinacridone Magenta              128,   2,  46
//      Cobalt Violet                      78,   0,  66
//      Ultramarine Blue                   25,   0,  89
//      Cobalt Blue                         0,  33, 133
//      Phthalo Blue                       13,  27,  68
//      Phthalo Green                       0,  60,  50
//      Permanent Green                     7, 109,  22
//      Sap Green                         107, 148,   4
//      Burnt Sienna                      123,  72,   0
//
//   LICENSING
//
//      If you want to obtain commercial license, please
//      contact us at: mixbox@scrtwpns.com
//

#ifndef MIXBOX_H_
#define MIXBOX_H_

#ifdef __cplusplus
extern "C" {
#endif

#define MIXBOX_LATENT_SIZE 7

typedef float mixbox_latent[MIXBOX_LATENT_SIZE];

void mixbox_lerp(unsigned char r1, unsigned char g1, unsigned char b1,
                 unsigned char r2, unsigned char g2, unsigned char b2,
                 float t,
                 unsigned char* out_r, unsigned char* out_g, unsigned char* out_b);

void mixbox_lerp_float(float r1, float g1, float b1,
                       float r2, float g2, float b2,
                       float t,
                       float* out_r, float* out_g, float* out_b);

void mixbox_lerp_linear_float(float r1, float g1, float b1,
                              float r2, float g2, float b2,
                              float t,
                              float* out_r, float* out_g, float* out_b);

void mixbox_rgb_to_latent(unsigned char r, unsigned char g, unsigned char b, mixbox_latent out_latent);
void mixbox_latent_to_rgb(mixbox_latent latent, unsigned char* out_r, unsigned char* out_g, unsigned char* out_b);

void mixbox_float_rgb_to_latent(float r, float g, float b, mixbox_latent out_latent);
void mixbox_latent_to_float_rgb(mixbox_latent latent, float* out_r, float* out_g, float* out_b);

void mixbox_linear_float_rgb_to_latent(float r, float g, float b, mixbox_latent out_latent);
void mixbox_latent_to_linear_float_rgb(mixbox_latent latent, float* out_r, float* out_g, float* out_b);

#ifdef __cplusplus
}
#endif

#endif
