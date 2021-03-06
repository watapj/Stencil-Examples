//VRC Mirror Reflectionより

#include "UnityCG.cginc"
#include "UnityInstancing.cginc"

sampler2D _MainTex;

sampler2D _ReflectionTex0;
sampler2D _ReflectionTex1;

struct appdata 
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 refl : TEXCOORD1;
    float4 pos : SV_POSITION;

    UNITY_VERTEX_OUTPUT_STEREO
};

v2f vert(appdata v)
{
    v2f o;

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(v2f, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    o.refl = ComputeNonStereoScreenPos(o.pos);

    return o;
}

half4 Mirror(v2f i)
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

    half4 tex = tex2D(_MainTex, i.uv);
    half4 refl = unity_StereoEyeIndex == 0 ? tex2Dproj(_ReflectionTex0, UNITY_PROJ_COORD(i.refl)) : tex2Dproj(_ReflectionTex1, UNITY_PROJ_COORD(i.refl));
    return tex * refl;
}