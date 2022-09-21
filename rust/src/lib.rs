// ==========================================================
//  MIXBOX 2.0 (c) 2022 Secret Weapons. All rights reserved.
//  License: Creative Commons Attribution-NonCommercial 4.0
//  Authors: Sarka Sochorova and Ondrej Jamriska
// ==========================================================
//
//   BASIC USAGE
//
//      let rgb_mix = mixbox::lerp(&rgb1, &rgb2, t);
//
//   MULTI-COLOR MIXING
//
//      let z1 = mixbox::rgb_to_latent(&rgb1);
//      let z2 = mixbox::rgb_to_latent(&rgb2);
//      let z3 = mixbox::rgb_to_latent(&rgb3);
//
//      let mut z_mix = [0.0; mixbox::LATENT_SIZE];
//
//      for i in 0..z_mix.len() {     // mix together:
//          z_mix[i] = 0.3*z1[i] +    // 30% of rgb1
//                     0.6*z2[i] +    // 60% of rgb2
//                     0.1*z3[i];     // 10% of rgb3
//      }
//
//      let rgb_mix = mixbox::latent_to_rgb(&z_mix);
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

#![no_std]

use libm::powf;

pub const LATENT_SIZE: usize = 7;

const MIXBOX_LUT : &[u8] = include_bytes!("lut.dat");

#[inline(always)]
fn clamp01(x: f32) -> f32 {
     if x < 0.0 {
        0.0
    } else if x > 1.0 {
        1.0
    } else {
        x
    }
}

#[inline(always)]
fn srgb_to_linear(x: f32) -> f32 {
    if x >= 0.04045 {
        powf((x + 0.055) / 1.055, 2.4)
    } else {
      x / 12.92
    }
}

#[inline(always)]
fn linear_to_srgb(x: f32) -> f32 {
    if x >= 0.0031308 {
        1.055 * powf(x, 1.0 / 2.4) - 0.055
    } else {
        12.92 * x
    }
}

#[inline(always)]
fn eval_polynomial(c0: f32, c1: f32, c2: f32, c3: f32) -> [f32; 3] {
    let c00 = c0 * c0;
    let c11 = c1 * c1;
    let c22 = c2 * c2;
    let c33 = c3 * c3;
    let c01 = c0 * c1;
    let c02 = c0 * c2;
    let c12 = c1 * c2;

    let mut r = 0.0;
    let mut g = 0.0;
    let mut b = 0.0;

    let w00 = c0 * c00; r +=  0.07717053*w00; g +=  0.02826978*w00; b +=  0.24832992*w00;
    let w01 = c1 * c11; r +=  0.95912302*w01; g +=  0.80256528*w01; b +=  0.03561839*w01;
    let w02 = c2 * c22; r +=  0.74683774*w02; g +=  0.04868586*w02; b +=  0.00000000*w02;
    let w03 = c3 * c33; r +=  0.99518138*w03; g +=  0.99978149*w03; b +=  0.99704802*w03;
    let w04 = c00 * c1; r +=  0.04819146*w04; g +=  0.83363781*w04; b +=  0.32515377*w04;
    let w05 = c01 * c1; r += -0.68146950*w05; g +=  1.46107803*w05; b +=  1.06980936*w05;
    let w06 = c00 * c2; r +=  0.27058419*w06; g += -0.15324870*w06; b +=  1.98735057*w06;
    let w07 = c02 * c2; r +=  0.80478189*w07; g +=  0.67093710*w07; b +=  0.18424500*w07;
    let w08 = c00 * c3; r += -0.35031003*w08; g +=  1.37855826*w08; b +=  3.68865000*w08;
    let w09 = c0 * c33; r +=  1.05128046*w09; g +=  1.97815239*w09; b +=  2.82989073*w09;
    let w10 = c11 * c2; r +=  3.21607125*w10; g +=  0.81270228*w10; b +=  1.03384539*w10;
    let w11 = c1 * c22; r +=  2.78893374*w11; g +=  0.41565549*w11; b += -0.04487295*w11;
    let w12 = c11 * c3; r +=  3.02162577*w12; g +=  2.55374103*w12; b +=  0.32766114*w12;
    let w13 = c1 * c33; r +=  2.95124691*w13; g +=  2.81201112*w13; b +=  1.17578442*w13;
    let w14 = c22 * c3; r +=  2.82677043*w14; g +=  0.79933038*w14; b +=  1.81715262*w14;
    let w15 = c2 * c33; r +=  2.99691099*w15; g +=  1.22593053*w15; b +=  1.80653661*w15;
    let w16 = c01 * c2; r +=  1.87394106*w16; g +=  2.05027182*w16; b += -0.29835996*w16;
    let w17 = c01 * c3; r +=  2.56609566*w17; g +=  7.03428198*w17; b +=  0.62575374*w17;
    let w18 = c02 * c3; r +=  4.08329484*w18; g += -1.40408358*w18; b +=  2.14995522*w18;
    let w19 = c12 * c3; r +=  6.00078678*w19; g +=  2.55552042*w19; b +=  1.90739502*w19;

    [r, g, b]
}

pub fn float_rgb_to_latent(rgb: &[f32; 3]) -> [f32; LATENT_SIZE] {
    let r01 = clamp01(rgb[0]);
    let g01 = clamp01(rgb[1]);
    let b01 = clamp01(rgb[2]);

    let x = r01 * 63.0;
    let y = g01 * 63.0;
    let z = b01 * 63.0;

    let ix = x as i32;
    let iy = y as i32;
    let iz = z as i32;

    let tx = x - (ix as f32);
    let ty = y - (iy as f32);
    let tz = z - (iz as f32);

    let lut = &MIXBOX_LUT[(((ix + iy*64 + iz*64*64) & 0x3FFFF) * 3) as usize ..];

    let mut c0 = 0.0;
    let mut c1 = 0.0;
    let mut c2 = 0.0;

    let w0 = (1.0-tx)*(1.0-ty)*(1.0-tz); c0 += w0*(lut[  192] as f32); c1 += w0*(lut[  193] as f32); c2 += w0*(lut[  194] as f32);
    let w1 = (    tx)*(1.0-ty)*(1.0-tz); c0 += w1*(lut[  195] as f32); c1 += w1*(lut[  196] as f32); c2 += w1*(lut[  197] as f32);
    let w2 = (1.0-tx)*(    ty)*(1.0-tz); c0 += w2*(lut[  384] as f32); c1 += w2*(lut[  385] as f32); c2 += w2*(lut[  386] as f32);
    let w3 = (    tx)*(    ty)*(1.0-tz); c0 += w3*(lut[  387] as f32); c1 += w3*(lut[  388] as f32); c2 += w3*(lut[  389] as f32);
    let w4 = (1.0-tx)*(1.0-ty)*(    tz); c0 += w4*(lut[12480] as f32); c1 += w4*(lut[12481] as f32); c2 += w4*(lut[12482] as f32);
    let w5 = (    tx)*(1.0-ty)*(    tz); c0 += w5*(lut[12483] as f32); c1 += w5*(lut[12484] as f32); c2 += w5*(lut[12485] as f32);
    let w6 = (1.0-tx)*(    ty)*(    tz); c0 += w6*(lut[12672] as f32); c1 += w6*(lut[12673] as f32); c2 += w6*(lut[12674] as f32);
    let w7 = (    tx)*(    ty)*(    tz); c0 += w7*(lut[12675] as f32); c1 += w7*(lut[12676] as f32); c2 += w7*(lut[12677] as f32);

    c0 *= 1.0 / 255.0;
    c1 *= 1.0 / 255.0;
    c2 *= 1.0 / 255.0;

    let c3 = 1.0 - (c0 + c1 + c2);

    let mixrgb = eval_polynomial(c0, c1, c2, c3);

    [
        c0,
        c1,
        c2,
        c3,
        r01 - mixrgb[0],
        g01 - mixrgb[1],
        b01 - mixrgb[2],
    ]
}

pub fn latent_to_float_rgb(latent: &[f32; LATENT_SIZE]) -> [f32; 3] {
    let rgb = eval_polynomial(latent[0], latent[1], latent[2], latent[3]);

    [
        clamp01(rgb[0] + latent[4]),
        clamp01(rgb[1] + latent[5]),
        clamp01(rgb[2] + latent[6]),
    ]
}

pub fn latent_to_rgb(latent: &[f32; LATENT_SIZE]) -> [u8; 3] {
    let rgb = latent_to_float_rgb(latent);

    [
        (rgb[0] * 255.0 + 0.5) as u8,
        (rgb[1] * 255.0 + 0.5) as u8,
        (rgb[2] * 255.0 + 0.5) as u8,
    ]
}

pub fn rgb_to_latent(rgb: &[u8; 3]) -> [f32; LATENT_SIZE] {
    float_rgb_to_latent(&[
        (rgb[0] as f32) / 255.0,
        (rgb[1] as f32) / 255.0,
        (rgb[2] as f32) / 255.0
    ])
}

pub fn linear_float_rgb_to_latent(rgb: &[f32; 3]) -> [f32; LATENT_SIZE] {
    float_rgb_to_latent(&[
        linear_to_srgb(rgb[0]),
        linear_to_srgb(rgb[1]),
        linear_to_srgb(rgb[2]),
    ])
}

pub fn latent_to_linear_float_rgb(latent: &[f32; LATENT_SIZE]) -> [f32; 3] {
    let rgb = latent_to_float_rgb(latent);

    [
        srgb_to_linear(rgb[0]),
        srgb_to_linear(rgb[1]),
        srgb_to_linear(rgb[2]),
    ]
}

pub fn lerp(rgb1: &[u8; 3], rgb2: &[u8; 3], t: f32) -> [u8; 3] {
    let latent1 = rgb_to_latent(rgb1);
    let latent2 = rgb_to_latent(rgb2);

    let mut latent_mix = [0.0; LATENT_SIZE];

    for i in 0..latent_mix.len() {
        latent_mix[i] = (1.0 - t) * latent1[i] + t * latent2[i];
    }

    latent_to_rgb(&latent_mix)
}

pub fn lerp_float(rgb1: &[f32; 3], rgb2: &[f32; 3], t: f32) -> [f32; 3] {
    let latent1 = float_rgb_to_latent(rgb1);
    let latent2 = float_rgb_to_latent(rgb2);

    let mut latent_mix = [0.0; LATENT_SIZE];

    for i in 0..latent_mix.len() {
        latent_mix[i] = (1.0 - t) * latent1[i] + t * latent2[i];
    }

    latent_to_float_rgb(&latent_mix)
}

pub fn lerp_linear_float(rgb1: &[f32; 3], rgb2: &[f32; 3], t: f32) -> [f32; 3] {
    let latent1 = linear_float_rgb_to_latent(rgb1);
    let latent2 = linear_float_rgb_to_latent(rgb2);

    let mut latent_mix = [0.0; LATENT_SIZE];

    for i in 0..latent_mix.len() {
        latent_mix[i] = (1.0 - t) * latent1[i] + t * latent2[i];
    }

    latent_to_linear_float_rgb(&latent_mix)
}
