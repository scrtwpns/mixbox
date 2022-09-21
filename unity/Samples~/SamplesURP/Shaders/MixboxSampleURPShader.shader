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
