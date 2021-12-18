#include "UnityCG.cginc"
sampler2D _CameraDepthTexture;

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float4 grabPos : TEXCOORD1;
    float depth : TEXCOORD2;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

v2f vert (appdata v)
{
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    o.uv = v.uv;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.grabPos = UNITY_PROJ_COORD(ComputeGrabScreenPos(o.vertex));
    COMPUTE_EYEDEPTH(o.depth.x);
    return o;
}

inline void calcFakeDepth(v2f i){
    float2 projuv = i.grabPos / (i.grabPos.w + 0.00000000001);
    float eyeDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, projuv));
    clip((eyeDepth-i.depth)-0.001);
}