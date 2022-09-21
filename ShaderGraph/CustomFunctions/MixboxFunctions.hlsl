#ifndef MIXBOX_FUNCTIONS_INCLUDED
#define MIXBOX_FUNCTIONS_INCLUDED

#ifndef UNITY_COLORSPACE_GAMMA
    #define MIXBOX_COLORSPACE_LINEAR
#endif

#define MIXBOX_LUT(UV) SAMPLE_TEXTURE2D_LOD(MixboxLUT.tex, MixboxLUT.samplerstate, UV, 0)

typedef float3x3 MixboxLatent;

float3 MixboxEvalPolynomial(float3 c)
{
    float c0 = c[0];
    float c1 = c[1];
    float c2 = c[2];
    float c3 = 1.0 - (c0 + c1 + c2);

    float c00 = c0 * c0;
    float c11 = c1 * c1;
    float c22 = c2 * c2;
    float c01 = c0 * c1;
    float c02 = c0 * c2;
    float c12 = c1 * c2;
    float c33 = c3 * c3;

    return (c0*c00) * float3(+0.07717053, +0.02826978, +0.24832992) +
           (c1*c11) * float3(+0.95912302, +0.80256528, +0.03561839) +
           (c2*c22) * float3(+0.74683774, +0.04868586, +0.00000000) +
           (c3*c33) * float3(+0.99518138, +0.99978149, +0.99704802) +
           (c00*c1) * float3(+0.04819146, +0.83363781, +0.32515377) +
           (c01*c1) * float3(-0.68146950, +1.46107803, +1.06980936) +
           (c00*c2) * float3(+0.27058419, -0.15324870, +1.98735057) +
           (c02*c2) * float3(+0.80478189, +0.67093710, +0.18424500) +
           (c00*c3) * float3(-0.35031003, +1.37855826, +3.68865000) +
           (c0*c33) * float3(+1.05128046, +1.97815239, +2.82989073) +
           (c11*c2) * float3(+3.21607125, +0.81270228, +1.03384539) +
           (c1*c22) * float3(+2.78893374, +0.41565549, -0.04487295) +
           (c11*c3) * float3(+3.02162577, +2.55374103, +0.32766114) +
           (c1*c33) * float3(+2.95124691, +2.81201112, +1.17578442) +
           (c22*c3) * float3(+2.82677043, +0.79933038, +1.81715262) +
           (c2*c33) * float3(+2.99691099, +1.22593053, +1.80653661) +
           (c01*c2) * float3(+1.87394106, +2.05027182, -0.29835996) +
           (c01*c3) * float3(+2.56609566, +7.03428198, +0.62575374) +
           (c02*c3) * float3(+4.08329484, -1.40408358, +2.14995522) +
           (c12*c3) * float3(+6.00078678, +2.55552042, +1.90739502);
}

float3 MixboxSRGBToLinear(float3 rgb)
{
    return (rgb >= 0.04045) ? pow((abs(rgb) + 0.055) / 1.055, 2.4) : rgb/12.92;
}

float3 MixboxLinearToSRGB(float3 rgb)
{
    return (rgb >= 0.0031308) ? 1.055*pow(abs(rgb), 1.0/2.4) - 0.055 : 12.92*rgb;
}

MixboxLatent MixboxRGBToLatent(UnityTexture2D MixboxLUT,float3 rgb)
{
#ifdef MIXBOX_COLORSPACE_LINEAR
    rgb = MixboxLinearToSRGB(saturate(rgb));
#else
    rgb = saturate(rgb);
#endif

    float x = rgb.r * 63.0;
    float y = rgb.g * 63.0;
    float z = rgb.b * 63.0;

    float iz = floor(z);

    float x0 = fmod(iz, 8.0) * 64.0;
    float y0 = floor(iz / 8.0) * 64.0;

    float x1 = fmod(iz + 1.0, 8.0) * 64.0;
    float y1 = floor((iz + 1.0) / 8.0) * 64.0;

    float2 uv0 = float2(x0 + x + 0.5, 512.0 - (y0 + y + 0.5)) / 512.0;
    float2 uv1 = float2(x1 + x + 0.5, 512.0 - (y1 + y + 0.5)) / 512.0;

    float3 c = lerp(MIXBOX_LUT(uv0).rgb, MIXBOX_LUT(uv1).rgb, z - iz);

    return MixboxLatent(c, rgb - MixboxEvalPolynomial(c), 0.0, 0.0, 0.0);
}

float3 MixboxLatentToRGB(MixboxLatent latent)
{
    float3 rgb = saturate(MixboxEvalPolynomial(latent[0]) + latent[1]);

#ifdef MIXBOX_COLORSPACE_LINEAR
    return MixboxSRGBToLinear(rgb);
#else
    return rgb;
#endif
}

void MixboxLerp_float(float4 A, float4 B, float T, UnityTexture2D MixboxLUT, out float4 Out)
{
    Out = float4(MixboxLatentToRGB((1.0-T)*MixboxRGBToLatent(MixboxLUT, A.rgb) + T*MixboxRGBToLatent(MixboxLUT, B.rgb)), lerp(A.a, B.a, T));
}

#endif
