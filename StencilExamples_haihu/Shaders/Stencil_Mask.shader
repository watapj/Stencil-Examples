// Copyright (c) 2021 wata_pj
// This code is under MIT licence, please see LICENSE.
Shader "WataOfuton/StencilExamples/Stencil_Mask"
{
Properties
{
    [NoScaleOffset]_MainTex ("Texture", 2D) = "black" {}
    [Enum(Zero,1,Replace,2,IncrSat,3,DecrSat,4,Invert,5,IncrWrap,6,DecrWrap,7)]_Operation("", Int) = 3
}
SubShader
{
Tags { "Queue"="AlphaTest+38"
       "DisableBatching"="True"
       "IgnoreProjector"="True"
}

Pass
{
Cull Off
ZWrite Off
Blend SrcAlpha One
Stencil{
    Comp Always
    Pass [_Operation]
}
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile_instancing
#include "include.cginc"

float4 frag (v2f i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(i);
    calcFakeDepth(i);
    return 0;
}
ENDCG
}

Pass
{
AlphaToMask On
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile_instancing
#include "include.cginc"

sampler2D _MainTex;

float4 frag (v2f i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(i);
    float4 col = tex2D(_MainTex, i.uv);
    return col;
}
ENDCG
}
}
}
