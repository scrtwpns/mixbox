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
