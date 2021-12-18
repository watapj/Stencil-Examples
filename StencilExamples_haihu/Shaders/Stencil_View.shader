// Copyright (c) 2021 wata_pj
// This code is under MIT licence, please see LICENSE.
Shader "WataOfuton/StencilExamples/Stencil_View"
{
Properties
{
    [NoScaleOffset]_MainTex ("Texture", 2D) = "black" {}
    [HideInInspector][IntRange]_Ref("Ref", Range(48, 54)) = 51
}
SubShader
{
Tags { "Queue"="AlphaTest+35"
       "DisableBatching"="True"
       "IgnoreProjector"="True"
}

Pass
{
ZWrite Off
ColorMask 0
Stencil{
    Ref [_Ref]
    Pass replace
    Comp Always
}
}

Pass
{
AlphaToMask On
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "include.cginc"
sampler2D _MainTex;

float4 frag (v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex, i.uv);
    return col;
}
ENDCG
}
}
}
