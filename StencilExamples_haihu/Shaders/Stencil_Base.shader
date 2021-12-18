// Copyright (c) 2021 wata_pj
// This code is under MIT licence, please see LICENSE.
Shader "WataOfuton/StencilExamples/Stencil_Base"
{
Properties
{
    [NoScaleOffset]_MainTex1("Texture 0 Ref[0] Equal", 2D) = "black" {}
    [NoScaleOffset]_MainTex2("Texture 1 Ref[5] Less", 2D) = "black" {}
    [NoScaleOffset]_MainTex ("Texture 2 Ref[49] Equal [Mirror]", 2D) = "black" {}
    [NoScaleOffset]_MainTex3("Texture 3 Ref[50] Equal", 2D) = "black" {}
    [NoScaleOffset]_MainTex4("Texture 4 Ref[51] Equal", 2D) = "black" {}
    [NoScaleOffset]_MainTex5("Texture 5 Ref[52] Equal", 2D) = "black" {}
    [NoScaleOffset]_MainTex6("Texture 6 Ref[53] Equal", 2D) = "black" {}
    [NoScaleOffset]_MainTex7("Texture 7 Ref[255] Equal", 2D) = "black" {}
    
    //for Mirror
    [HideInInspector] _ReflectionTex0("", 2D) = "white" {}
    [HideInInspector] _ReflectionTex1("", 2D) = "white" {}
}
SubShader
{
Tags { "Queue"="AlphaTest+39"
       "DisableBatching"="True"
       "IgnoreProjector"="True"
}

Pass //1つ目
{
Stencil{
    Ref 5
    Comp Less
}
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "include.cginc"
sampler2D _MainTex2;

float4 frag (v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex2, i.uv);
    clip(step(0.3, col.a)-0.0001);
    return col;
}
ENDCG
}


Pass //2つ目
{
Stencil{
    Ref 0
    Comp Equal
}
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "include.cginc"
sampler2D _MainTex1;

float4 frag (v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex1, i.uv);
    col = lerp(0.0, col, step(0.3, col.a));
    return col;
}
ENDCG
}


Pass //3つ目(Mirror)
{
Stencil{
    Ref 49
    Comp Equal
}
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "Mirror.cginc"

float4 frag (v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex, i.uv);
    col = lerp(Mirror(i), col, step(0.3, col.a));
    return col;
}
ENDCG
}

Pass //4つ目
{
Stencil{
    Ref 50
    Comp Equal
}
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "include.cginc"
sampler2D _MainTex3;

float4 frag (v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex3, i.uv);
    col = lerp(0.0, col, step(0.3, col.a));
    return col;
}
ENDCG
}

Pass //5つ目(Base)
{
Stencil{
    Ref 51
    Comp Equal
}
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "include.cginc"
sampler2D _MainTex4;

float4 frag (v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex4, i.uv);
    return col;
}
ENDCG
}

Pass //6つ目
{
Stencil{
    Ref 52
    Comp Equal
}
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "include.cginc"
sampler2D _MainTex5;

float4 frag (v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex5, i.uv);
    col = lerp(0.0, col, step(0.3, col.a));
    return col;
}
ENDCG
}

Pass //7つ目
{
Stencil{
    Ref 53
    Comp Equal
}
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "include.cginc"
sampler2D _MainTex6;

float4 frag (v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex6, i.uv);
    col = lerp(0.0, col, step(0.3, col.a));
    return col;
}
ENDCG
}

Pass //8つ目
{
Stencil{
    Ref 255
    Comp Equal
}
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "include.cginc"
sampler2D _MainTex7;

float4 frag (v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex7, i.uv);
    col = lerp(0.0, col, step(0.3, col.a));
    return col;
}
ENDCG
}

Pass {
Name "ShadowCaster"
Tags {
    "LightMode"="ShadowCaster"
}
Offset 1, 1
Cull Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "Lighting.cginc"
#pragma fragmentoption ARB_precision_hint_fastest
#pragma multi_compile_shadowcaster
#pragma target 4.0
struct VertexInput {
    float4 vertex : POSITION;
    float2 texcoord0 : TEXCOORD0;
};
struct VertexOutput {
    V2F_SHADOW_CASTER;
    float2 uv0 : TEXCOORD1;
};
VertexOutput vert (VertexInput v) {
    VertexOutput o = (VertexOutput)0;
    o.uv0 = v.texcoord0;
    o.pos = UnityObjectToClipPos( v.vertex );
    TRANSFER_SHADOW_CASTER(o)
    return o;
}
float4 frag(VertexOutput i) : COLOR {
    SHADOW_CASTER_FRAGMENT(i)
}
ENDCG
}

}
}
