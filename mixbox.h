// MIXBOX v1.2 (c) 2022 Secret Weapons
// This is for non-commercial use only.
// Contact: mixbox@scrtwpns.com

#ifndef MIXBOX_H_
#define MIXBOX_H_

#define MIXBOX_NUMLATENTS 7

void mixbox_lerp_srgb8(unsigned char r1,unsigned char g1,unsigned char b1,
                       unsigned char r2,unsigned char g2,unsigned char b2,
                       float t,
                       unsigned char* out_r,unsigned char* out_g,unsigned char* out_b);

void mixbox_lerp_srgb32f(float r1,float g1,float b1,
                         float r2,float g2,float b2,
                         float t,
                         float* out_r,float* out_g,float* out_b);

void mixbox_srgb8_to_latent(unsigned char r,unsigned char g,unsigned char b,float* out_latent);
void mixbox_latent_to_srgb8(float* latent,unsigned char* out_r,unsigned char* out_g,unsigned char* out_b);

void mixbox_srgb32f_to_latent(float r,float g,float b,float* out_latent);
void mixbox_latent_to_srgb32f(float* latent,float* out_r,float* out_g,float* out_b);


void mixbox_lerp_srgb8_dither(unsigned char r1,unsigned char g1,unsigned char b1,
                              unsigned char r2,unsigned char g2,unsigned char b2,
                              float t,
                              float dither_r,float dither_g,float dither_b,
                              unsigned char* out_r,unsigned char* out_g,unsigned char* out_b);

void mixbox_latent_to_srgb8_dither(float* latent,float dither_r,float dither_g,float dither_b,unsigned char* out_r,unsigned char* out_g,unsigned char* out_b);

#endif
