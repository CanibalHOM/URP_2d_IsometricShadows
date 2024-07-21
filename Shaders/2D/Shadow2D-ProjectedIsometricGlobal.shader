Shader "Hidden/ShadowIsometricGlobalProjected2D"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Tint", Color) = (1,1,1,1)
        [HideInInspector] _ShadowColorMask("__ShadowColorMask", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" }

        Cull    Off
        Blend   DstColor Zero
        ZWrite  Off
        ZTest   Always
 
        // This pass draws the projected shadows
        Pass
        {
            Name "Projected Shadow (R)"
            
            //ColorMask 0 // Clear the unshadow color (G), and set the sprite alpha (B)
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/ShadowProjectVertex.hlsl"

            TEXTURE2D(_FalloffLookup);
            SAMPLER(sampler_FalloffLookup);
            half _ShadowSoftnessFalloffIntensity;

            Varyings vert (Attributes v)
            {
                return ProjectIsometricGlobalShadow(v);
            }

            half4 frag(Varyings i) : SV_Target
            {
                float value = 0.5f * _ShadowSoftnessFalloffIntensity;
                half4 color = half4(value, value, value, value);
                return color;
            }
            ENDHLSL
        }
    }
}
