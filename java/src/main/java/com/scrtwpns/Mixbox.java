/* ==========================================================
 *  MIXBOX 2.0 (c) 2022 Secret Weapons. All rights reserved.
 *  License: Creative Commons Attribution-NonCommercial 4.0
 *  Authors: Sarka Sochorova and Ondrej Jamriska
 * ==========================================================
 *
 *   BASIC USAGE
 *
 *      int colorMix = Mixbox.lerp(color1, color2, t);
 *
 *   MULTI-COLOR MIXING
 *
 *      float[] z1 = Mixbox.rgbToLatent(color1);
 *      float[] z2 = Mixbox.rgbToLatent(color2);
 *      float[] z3 = Mixbox.rgbToLatent(color3);
 *
 *      float[] zMix = new float[Mixbox.LATENT_SIZE];
 *
 *      for (int i = 0; i < zMix.length; i++) { // mix:
 *          zMix[i] = (0.3f*z1[i] +    // 30% of color1
 *                     0.6f*z2[i] +    // 60% of color2
 *                     0.1f*z3[i]);    // 10% of color3
 *      }
 *
 *      int colorMix = Mixbox.latentToRgb(zMix);
 *
 *   PIGMENT COLORS
 *
 *      Cadmium Yellow                    254, 236,   0
 *      Hansa Yellow                      252, 211,   0
 *      Cadmium Orange                    255, 105,   0
 *      Cadmium Red                       255,  39,   2
 *      Quinacridone Magenta              128,   2,  46
 *      Cobalt Violet                      78,   0,  66
 *      Ultramarine Blue                   25,   0,  89
 *      Cobalt Blue                         0,  33, 133
 *      Phthalo Blue                       13,  27,  68
 *      Phthalo Green                       0,  60,  50
 *      Permanent Green                     7, 109,  22
 *      Sap Green                         107, 148,   4
 *      Burnt Sienna                      123,  72,   0
 *
 *   LICENSING
 *
 *      If you want to obtain commercial license, please
 *      contact us at: mixbox@scrtwpns.com
 *
 */

package com.scrtwpns;

import java.io.DataInputStream;
import java.util.zip.Inflater;

public final class Mixbox {

    public static final int LATENT_SIZE = 7;

    public static int lerp(int color1, int color2, float t) {
        final float[] latent1 = rgbToLatent(color1);
        final float[] latent2 = rgbToLatent(color2);

        float[] latentMix = new float[LATENT_SIZE];

        for (int i = 0; i < LATENT_SIZE; i++) {
            latentMix[i] = (1.0f-t)*latent1[i] + t*latent2[i];
        }

        final float alpha1 = (color1 >> 24) & 0xFF;
        final float alpha2 = (color2 >> 24) & 0xFF;
        final int alphaMix = clamp0255(Math.round((1.0f-t)*alpha1 + t*alpha2));

        return (alphaMix << 24) | (latentToRgb(latentMix) & 0xFFFFFF);
    }

    public static int[] lerp(int[] color1, int[] color2, float t) {
        final float[] latent1 = rgbToLatent(color1);
        final float[] latent2 = rgbToLatent(color2);

        float[] latentMix = new float[LATENT_SIZE];

        for (int i = 0; i < LATENT_SIZE; i++) {
            latentMix[i] = (1.0f-t)*latent1[i] + t*latent2[i];
        }

        final int colorMix = latentToRgb(latentMix);

        if (color1.length == 3 && color2.length == 3) {
            return new int[] { (colorMix >> 16) & 0xFF, (colorMix >> 8) & 0xFF, colorMix & 0xFF };
        }

        final int alpha1 = color1.length > 3 ? color1[3] : 255;
        final int alpha2 = color2.length > 3 ? color2[3] : 255;
        final int alphaMix = clamp0255(Math.round((1.0f-t)*alpha1 + t*alpha2));

        return new int[] { (colorMix>>16) & 0xFF, (colorMix>>8) & 0xFF, colorMix & 0xFF, alphaMix };
    }

    public static float[] lerpFloat(float[] color1, float[] color2, float t) {
        final float[] latent1 = floatRgbToLatent(color1[0], color1[1], color1[2]);
        final float[] latent2 = floatRgbToLatent(color2[0], color2[1], color2[2]);

        float[] latentMix = new float[LATENT_SIZE];

        for (int i = 0; i < LATENT_SIZE; i++) {
            latentMix[i] = (1.0f - t)*latent1[i] + t*latent2[i];
        }

        final float[] colorMix = latentToFloatRgb(latentMix);

        if (color1.length == 3 && color2.length == 3) { return colorMix; }

        final float alpha1 = color1.length > 3 ? color1[3] : 1.0f;
        final float alpha2 = color2.length > 3 ? color2[3] : 1.0f;
        final float alphaMix = (1.0f-t)*alpha1 + t*alpha2;

        return new float[] { colorMix[0], colorMix[1], colorMix[2], alphaMix };
    }

    public static float[] lerpLinearFloat(float[] color1, float[] color2, float t) {
        final float[] latent1 = linearFloatRgbToLatent(color1[0], color1[1], color1[2]);
        final float[] latent2 = linearFloatRgbToLatent(color2[0], color2[1], color2[2]);

        float[] latentMix = new float[LATENT_SIZE];

        for (int i = 0; i < LATENT_SIZE; i++) {
            latentMix[i] = (1.0f-t)*latent1[i] + t*latent2[i];
        }

        final float[] colorMix = latentToLinearFloatRgb(latentMix);

        if (color1.length == 3 && color2.length == 3) { return colorMix; }

        final float alpha1 = color1.length > 3 ? color1[3] : 1.0f;
        final float alpha2 = color2.length > 3 ? color2[3] : 1.0f;
        final float alphaMix = (1.0f-t)*alpha1 + t*alpha2;

        return new float[] { colorMix[0], colorMix[1], colorMix[2], alphaMix };
    }

    public static float[] rgbToLatent(int r, int g, int b) {
        return floatRgbToLatent(((float)r) / 255.0f, ((float)g) / 255.0f, ((float)b) / 255.0f);
    }

    public static float[] rgbToLatent(int[] rgb) {
        return rgbToLatent(rgb[0], rgb[1], rgb[2]);
    }

    public static float[] rgbToLatent(int color) {
        return rgbToLatent((color >> 16) & 0xFF, (color >> 8) & 0xFF, color & 0xFF);
    }

    public static int latentToRgb(float[] latent) {
        final float[] rgb = evalPolynomial(latent[0], latent[1], latent[2], latent[3]);
        return (0xFF000000 |
               (((int)Math.round(clamp01(rgb[0] + latent[4]) * 255.0f)) << 16) |
               (((int)Math.round(clamp01(rgb[1] + latent[5]) * 255.0f)) <<  8) |
               (((int)Math.round(clamp01(rgb[2] + latent[6]) * 255.0f))      ));
    }

    public static float[] floatRgbToLatent(float r, float g, float b) {
        r = clamp01(r);
        g = clamp01(g);
        b = clamp01(b);

        final float x = r * 63.0f;
        final float y = g * 63.0f;
        final float z = b * 63.0f;

        final int ix = (int)x;
        final int iy = (int)y;
        final int iz = (int)z;

        final float tx = x - (float)ix;
        final float ty = y - (float)iy;
        final float tz = z - (float)iz;

        final int xyz = (ix + iy * 64 + iz * 64 * 64) & 0x3FFFF;

        float c0 = 0.0f;
        float c1 = 0.0f;
        float c2 = 0.0f;

        float w = 0.0f;

        w = (1.0f-tx)*(1.0f-ty)*(1.0f-tz); c0 += w*(((int)lut[xyz+ 192])&0xFF); c1 += w*(((int)lut[xyz+262336])&0xFF); c2 += w*(((int)lut[xyz+524480])&0xFF);
        w = (     tx)*(1.0f-ty)*(1.0f-tz); c0 += w*(((int)lut[xyz+ 193])&0xFF); c1 += w*(((int)lut[xyz+262337])&0xFF); c2 += w*(((int)lut[xyz+524481])&0xFF);
        w = (1.0f-tx)*(     ty)*(1.0f-tz); c0 += w*(((int)lut[xyz+ 256])&0xFF); c1 += w*(((int)lut[xyz+262400])&0xFF); c2 += w*(((int)lut[xyz+524544])&0xFF);
        w = (     tx)*(     ty)*(1.0f-tz); c0 += w*(((int)lut[xyz+ 257])&0xFF); c1 += w*(((int)lut[xyz+262401])&0xFF); c2 += w*(((int)lut[xyz+524545])&0xFF);
        w = (1.0f-tx)*(1.0f-ty)*(     tz); c0 += w*(((int)lut[xyz+4288])&0xFF); c1 += w*(((int)lut[xyz+266432])&0xFF); c2 += w*(((int)lut[xyz+528576])&0xFF);
        w = (     tx)*(1.0f-ty)*(     tz); c0 += w*(((int)lut[xyz+4289])&0xFF); c1 += w*(((int)lut[xyz+266433])&0xFF); c2 += w*(((int)lut[xyz+528577])&0xFF);
        w = (1.0f-tx)*(     ty)*(     tz); c0 += w*(((int)lut[xyz+4352])&0xFF); c1 += w*(((int)lut[xyz+266496])&0xFF); c2 += w*(((int)lut[xyz+528640])&0xFF);
        w = (     tx)*(     ty)*(     tz); c0 += w*(((int)lut[xyz+4353])&0xFF); c1 += w*(((int)lut[xyz+266497])&0xFF); c2 += w*(((int)lut[xyz+528641])&0xFF);

        c0 /= 255.0f;
        c1 /= 255.0f;
        c2 /= 255.0f;

        final float c3 = 1.0f - (c0 + c1 + c2);

        float rmix = 0.0f;
        float gmix = 0.0f;
        float bmix = 0.0f;

        final float c00 = c0 * c0;
        final float c11 = c1 * c1;
        final float c22 = c2 * c2;
        final float c33 = c3 * c3;
        final float c01 = c0 * c1;
        final float c02 = c0 * c2;
        final float c12 = c1 * c2;

        w = c0 * c00; rmix += +0.07717053f * w; gmix += +0.02826978f * w; bmix += +0.24832992f * w;
        w = c1 * c11; rmix += +0.95912302f * w; gmix += +0.80256528f * w; bmix += +0.03561839f * w;
        w = c2 * c22; rmix += +0.74683774f * w; gmix += +0.04868586f * w; bmix += +0.00000000f * w;
        w = c3 * c33; rmix += +0.99518138f * w; gmix += +0.99978149f * w; bmix += +0.99704802f * w;
        w = c00 * c1; rmix += +0.04819146f * w; gmix += +0.83363781f * w; bmix += +0.32515377f * w;
        w = c01 * c1; rmix += -0.68146950f * w; gmix += +1.46107803f * w; bmix += +1.06980936f * w;
        w = c00 * c2; rmix += +0.27058419f * w; gmix += -0.15324870f * w; bmix += +1.98735057f * w;
        w = c02 * c2; rmix += +0.80478189f * w; gmix += +0.67093710f * w; bmix += +0.18424500f * w;
        w = c00 * c3; rmix += -0.35031003f * w; gmix += +1.37855826f * w; bmix += +3.68865000f * w;
        w = c0 * c33; rmix += +1.05128046f * w; gmix += +1.97815239f * w; bmix += +2.82989073f * w;
        w = c11 * c2; rmix += +3.21607125f * w; gmix += +0.81270228f * w; bmix += +1.03384539f * w;
        w = c1 * c22; rmix += +2.78893374f * w; gmix += +0.41565549f * w; bmix += -0.04487295f * w;
        w = c11 * c3; rmix += +3.02162577f * w; gmix += +2.55374103f * w; bmix += +0.32766114f * w;
        w = c1 * c33; rmix += +2.95124691f * w; gmix += +2.81201112f * w; bmix += +1.17578442f * w;
        w = c22 * c3; rmix += +2.82677043f * w; gmix += +0.79933038f * w; bmix += +1.81715262f * w;
        w = c2 * c33; rmix += +2.99691099f * w; gmix += +1.22593053f * w; bmix += +1.80653661f * w;
        w = c01 * c2; rmix += +1.87394106f * w; gmix += +2.05027182f * w; bmix += -0.29835996f * w;
        w = c01 * c3; rmix += +2.56609566f * w; gmix += +7.03428198f * w; bmix += +0.62575374f * w;
        w = c02 * c3; rmix += +4.08329484f * w; gmix += -1.40408358f * w; bmix += +2.14995522f * w;
        w = c12 * c3; rmix += +6.00078678f * w; gmix += +2.55552042f * w; bmix += +1.90739502f * w;

        return new float[] {
            c0,
            c1,
            c2,
            c3,
            r - rmix,
            g - gmix,
            b - bmix,
        };
    }

    public static float[] floatRgbToLatent(float[] rgb) {
        return floatRgbToLatent(rgb[0], rgb[1], rgb[2]);
    }

    public static float[] latentToFloatRgb(float[] latent) {
        final float[] rgb = evalPolynomial(latent[0], latent[1], latent[2], latent[3]);
        return new float[] {
            clamp01(rgb[0] + latent[4]),
            clamp01(rgb[1] + latent[5]),
            clamp01(rgb[2] + latent[6]),
        };
    }

    public static float[] linearFloatRgbToLatent(float r, float g, float b) {
        return floatRgbToLatent(linearToSrgb(r),
                                linearToSrgb(g),
                                linearToSrgb(b));
    }

    public static float[] linearFloatRgbToLatent(float[] rgb) {
        return linearFloatRgbToLatent(rgb[0], rgb[1], rgb[2]);
    }

    public static float[] latentToLinearFloatRgb(float[] latent) {
        final float[] rgb = latentToFloatRgb(latent);
        return new float[] {
            srgbToLinear(rgb[0]),
            srgbToLinear(rgb[1]),
            srgbToLinear(rgb[2]),
        };
    }

    private static float clamp01(float x)
    {
        return x < 0.0f ? 0.0f : x > 1.0f ? 1.0f : x;
    }

    private static int clamp0255(int x)
    {
        return x < 0 ? 0 : x > 255 ? 255 : x;
    }

    private static float srgbToLinear(float x) {
        return (x >= 0.04045f) ? (float)Math.pow((x + 0.055f) / 1.055f,2.4f) : x / 12.92f;
    }

    private static float linearToSrgb(float x) {
        return (x >= 0.0031308f) ? 1.055f * ((float)Math.pow(x,1.0f / 2.4f)) - 0.055f : 12.92f * x;
    }

    private static float[] evalPolynomial(float c0, float c1, float c2, float c3)
    {
        float r = 0.0f;
        float g = 0.0f;
        float b = 0.0f;

        final float c00 = c0 * c0;
        final float c11 = c1 * c1;
        final float c22 = c2 * c2;
        final float c33 = c3 * c3;
        final float c01 = c0 * c1;
        final float c02 = c0 * c2;
        final float c12 = c1 * c2;

        float w = 0.0f;
        w = c0 * c00; r += +0.07717053f * w; g += +0.02826978f * w; b += +0.24832992f * w;
        w = c1 * c11; r += +0.95912302f * w; g += +0.80256528f * w; b += +0.03561839f * w;
        w = c2 * c22; r += +0.74683774f * w; g += +0.04868586f * w; b += +0.00000000f * w;
        w = c3 * c33; r += +0.99518138f * w; g += +0.99978149f * w; b += +0.99704802f * w;
        w = c00 * c1; r += +0.04819146f * w; g += +0.83363781f * w; b += +0.32515377f * w;
        w = c01 * c1; r += -0.68146950f * w; g += +1.46107803f * w; b += +1.06980936f * w;
        w = c00 * c2; r += +0.27058419f * w; g += -0.15324870f * w; b += +1.98735057f * w;
        w = c02 * c2; r += +0.80478189f * w; g += +0.67093710f * w; b += +0.18424500f * w;
        w = c00 * c3; r += -0.35031003f * w; g += +1.37855826f * w; b += +3.68865000f * w;
        w = c0 * c33; r += +1.05128046f * w; g += +1.97815239f * w; b += +2.82989073f * w;
        w = c11 * c2; r += +3.21607125f * w; g += +0.81270228f * w; b += +1.03384539f * w;
        w = c1 * c22; r += +2.78893374f * w; g += +0.41565549f * w; b += -0.04487295f * w;
        w = c11 * c3; r += +3.02162577f * w; g += +2.55374103f * w; b += +0.32766114f * w;
        w = c1 * c33; r += +2.95124691f * w; g += +2.81201112f * w; b += +1.17578442f * w;
        w = c22 * c3; r += +2.82677043f * w; g += +0.79933038f * w; b += +1.81715262f * w;
        w = c2 * c33; r += +2.99691099f * w; g += +1.22593053f * w; b += +1.80653661f * w;
        w = c01 * c2; r += +1.87394106f * w; g += +2.05027182f * w; b += -0.29835996f * w;
        w = c01 * c3; r += +2.56609566f * w; g += +7.03428198f * w; b += +0.62575374f * w;
        w = c02 * c3; r += +4.08329484f * w; g += -1.40408358f * w; b += +2.14995522f * w;
        w = c12 * c3; r += +6.00078678f * w; g += +2.55552042f * w; b += +1.90739502f * w;

        return new float[] { r, g, b };
    }

    private static final byte lut[];

    static {
        lut = new byte[64 * 64 * 64 * 3 + 4353];

        try {
            byte[] deflatedBytes = new byte[113551 - 192];
            DataInputStream dis = new DataInputStream(Mixbox.class.getResourceAsStream("mixbox_lut.dat"));
            dis.skipBytes(192);
            dis.readFully(deflatedBytes);
            dis.close();

            Inflater inflater = new Inflater(true);
            inflater.setInput(deflatedBytes);
            inflater.inflate(lut);

            for (int i = 0; i < lut.length; i++) {
                lut[i] = (byte)((((i & 63) != 0) ? lut[i - 1] : 127) + (lut[i] - 127));
            }
        } catch (Exception e) {

        }
    }
}
