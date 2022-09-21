# Mixbox for Unity

Open `Window` > `Package Manager` and choose ` + ` > `Add packge from git URL...`:
```
https://github.com/scrtwpns/mixbox.git#upm
```

## Script
```csharp
using UnityEngine;
using Scrtwpns.Mixbox;

public class NewBehaviourScript : MonoBehaviour
{
    void Start()
    {
        Color color1 = new Color(0.0f, 0.129f, 0.522f); // blue
        Color color2 = new Color(0.988f, 0.827f, 0.0f); // yellow
        float t = 0.5f;                                 // mixing ratio

        Color colorMix = Mixbox.Lerp(color1, color2, t);

        Debug.Log(colorMix);
    }
}
```
```csharp
Color MixThree(Color color1, Color color2, Color color3)
{
    MixboxLatent z1 = Mixbox.RGBToLatent(color1);
    MixboxLatent z2 = Mixbox.RGBToLatent(color2);
    MixboxLatent z3 = Mixbox.RGBToLatent(color3);

    // mix 30% of color1, 60% of color2, and 10% of color3
    MixboxLatent zMix = 0.3f*z1 + 0.6f*z2 + 0.1f*z3;

    Color colorMix = Mixbox.LatentToRGB(zMix);

    return colorMix;
}
```

## Shader
```ShaderLab
Shader "MixboxHelloShader"
{
    Properties
    {
        [NoScaleOffset] _MixboxLUT ("Mixbox LUT", 2D) = "white" {} // assign "Packages/Mixbox/Textures/MixboxLUT.png"

        _Color1 ("Color 1", Color) = (0, 0.129, 0.522, 1) // blue
        _Color2 ("Color 2", Color) = (0.988, 0.827, 0, 1) // yellow
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MixboxLUT;
            #include "Packages/com.scrtwpns.mixbox/ShaderLibrary/Mixbox.cginc"

            fixed4 _Color1;
            fixed4 _Color2;

            struct appdata { float4 vertex : POSITION; float2 uv : TEXCOORD0; };
            struct v2f { float2 uv : TEXCOORD0; float4 vertex : SV_POSITION; };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return MixboxLerp(_Color1, _Color2, i.uv.x);
            }
            ENDCG
        }
    }
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
<p align="center">
  <img src="https://scrtwpns.com/mixbox/unity/mixboxlut-howto.png"/>
</p>

## URP Shader
```ShaderLab
Shader "Mixbox/Mixbox URP Sample Shader"
{
    Properties
    {
        [NoScaleOffset] _MixboxLUT ("Mixbox LUT", 2D) = "white" {} // assign "Packages/Mixbox/Textures/MixboxLUT.png"

        _Color1 ("Color 1", Color) = (0, 0.129, 0.522, 1) // blue
        _Color2 ("Color 2", Color) = (0.988, 0.827, 0, 1) // yellow
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_MixboxLUT);
            SAMPLER(sampler_MixboxLUT);

            #include "Packages/com.scrtwpns.mixbox/ShaderLibrary/Mixbox.hlsl"

            struct Attributes { float4 positionOS : POSITION; float2 uv : TEXCOORD0; };
            struct Varyings { float4 positionHCS : SV_POSITION; float2 uv : TEXCOORD0; };

            CBUFFER_START(UnityPerMaterial)
                half4 _Color1;
                half4 _Color2;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                return MixboxLerp(_Color1, _Color2, IN.uv.x);
            }
            ENDHLSL
        }
    }
}
```

## Shader Graph
<p align="center">
  <img src="https://scrtwpns.com/mixbox/unity/shadergraph_.png"/>
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
