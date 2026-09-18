// ---- Created with 3Dmigoto v1.3.16 on Fri Sep 18 20:18:17 2026
// Replaces Tonemap2_0x62E8C0F7 (same YEBIS pass, cbuffer is now named and the
// vignette falloff comes from fParam_VignetteSimulate instead of fixed constants)

#include "../shared.h"

cbuffer _Globals : register(b0)
{
  float2 fParam_DepthCastScaleOffset : packoffset(c0);
  float4 fParam_DepthOfFieldFactorScaleOffset : packoffset(c1);
  float4 fParam_HDRFormatFactor_LOGRGB : packoffset(c2);
  float4 fParam_HDRFormatFactor_RGBALUM : packoffset(c3);
  float4 fParam_HDRFormatFactor_REINHARDRGB : packoffset(c4);
  float2 fParam_ScreenSpaceScale : packoffset(c5);
  float4x4 m44_ModelViewProject : packoffset(c6);
  float4 fParam_GammaCorrection : packoffset(c10);
  float4 fParam_DitherOffsetScale : packoffset(c11);
  float4 fParam_TonemapMaxMappingLuminance : packoffset(c12);
  float4 fParam_BrightPass_LensDistortion : packoffset(c13);
  float4 afRGBA_Modulate[32] : packoffset(c14);
  float4 afRGBA_Offset[16] : packoffset(c46);
  float4 afUV_TexCoordOffsetV16[16] : packoffset(c62);
  float4x4 m44_ColorTransformMatrix : packoffset(c78);
  float4x4 m44_PreTonemapColorTransformMatrix : packoffset(c82);
  float4x4 m44_PreTonemapGlareColorTransformMatrix : packoffset(c86);
  float4 fParam_VignetteSimulate : packoffset(c90);
  float4 fParam_VignettePowerOfCosine : packoffset(c91);
  float4 afUVWQ_TexCoordScaleOffset[4] : packoffset(c92);
  float4 fParam_PerspectiveFactor : packoffset(c96);
  float fParam_FocusDistance : packoffset(c97);
  float4 fParam_DepthOfFieldConvertDepthFactor : packoffset(c98);
  float2 afXY_DepthOfFieldLevelBlendFactor16[16] : packoffset(c99);
  float fParam_DepthOfFieldLayerMaskThreshold : packoffset(c114.z);
  float fParam_DepthOfFieldFactorThreshold : packoffset(c114.w);
  float4 afParam_TexCoordScaler8[8] : packoffset(c115);
  float4 fRGBA_Constant : packoffset(c123);
  float4 afRGBA_Constant[4] : packoffset(c124);
  float4x4 am44_TransformMatrix[8] : packoffset(c128);
  float4 afUV_TexCoordOffsetP32[96] : packoffset(c160);
}

SamplerState asamp2D_Texture_0_s : register(s0);
SamplerState asamp2D_Texture_1_s : register(s1);
SamplerState asamp2D_Texture_2_s : register(s2);
Texture2D<float4> atex2D_Texture_0 : register(t0);
Texture2D<float4> atex2D_Texture_1 : register(t1);
Texture2D<float4> atex2D_Texture_2 : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float2 v4 : TEXCOORD4,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (RENODX_TONE_MAP_TYPE != 0.0f) {
    r0.x = dot(v2.xy, v2.xy);
    r0.x = saturate(r0.x * fParam_VignetteSimulate.x + fParam_VignetteSimulate.y);
    r0.x = r0.x * r0.x;
    r0.x = r0.x * r0.x;
    r1.xyzw = atex2D_Texture_2.Sample(asamp2D_Texture_2_s, v3.xy).xyzw;
    r0.yzw = r1.xyz * afRGBA_Offset[2].xxx + afRGBA_Offset[2].yyy;
    r1.xyz = r1.xyz * afRGBA_Offset[0].xxx + afRGBA_Offset[0].yyy;
    r1.w = dot(r0.yzw, float3(0.333333343,0.333333343,0.333333343));
    r0.yzw = -r1.www + r0.yzw;
    r0.yzw = afRGBA_Offset[3].xxx * r0.yzw + r1.www;
    r0.yzw = r0.yzw * afRGBA_Offset[2].zzz + afRGBA_Offset[2].www;
    r2.xyzw = atex2D_Texture_0.SampleLevel(asamp2D_Texture_0_s, v0.xy, 0).xyzw;
    r3.xyz = r2.xyz * r0.yzw;
    r1.w = dot(r2.xyzw, afRGBA_Modulate[1].xyzw);
    o0.w = saturate(afRGBA_Modulate[0].w + r1.w);

    const float3 bloom_rgb = atex2D_Texture_1.SampleLevel(asamp2D_Texture_1_s, v1.xy, 0).xyz;
    const float bloom_weight = 0.005f * CUSTOM_BLOOM_STRENGTH;
    float3 scene_with_bloom = r3.xyz + bloom_rgb * (r0.yzw * bloom_weight);

    const float vignette_falloff = r0.x;
    const float vignette_strength = saturate(CUSTOM_VIGNETTE_STRENGTH);
    const float vignette_mix = lerp(1.0f, vignette_falloff, vignette_strength);
    scene_with_bloom *= vignette_mix;

    // Nuked the game's tone curve, saturation, and LUT processing
    const float3 scene_linear = max(float3(0,0,0), scene_with_bloom);
    const float exposure_boost = 50.0f;  // Manual exposure lift now that the game curve is bypassed
    const float3 boosted_linear = scene_linear * exposure_boost;
    const float3 scene_pow = pow(boosted_linear, float3(0.416666657f,0.416666657f,0.416666657f));
    const float3 scene_high = 1.055f * scene_pow - 0.055f;
    const float3 scene_low = boosted_linear * 12.92f;
    const float3 use_high = step(float3(0.0031308f,0.0031308f,0.0031308f), boosted_linear);
    o0.xyz = lerp(scene_low, scene_high, use_high);
    return;
  }

  // Vanilla tone curve, saturation, and LUT
  r0.x = dot(v2.xy, v2.xy);
  r0.x = saturate(r0.x * fParam_VignetteSimulate.x + fParam_VignetteSimulate.y);
  r0.x = r0.x * r0.x;
  r0.x = r0.x * r0.x;
  r1.xyzw = atex2D_Texture_2.Sample(asamp2D_Texture_2_s, v3.xy).xyzw;
  r0.yzw = r1.xyz * afRGBA_Offset[2].xxx + afRGBA_Offset[2].yyy;
  r1.xyz = r1.xyz * afRGBA_Offset[0].xxx + afRGBA_Offset[0].yyy;
  r1.w = dot(r0.yzw, float3(0.333333343,0.333333343,0.333333343));
  r0.yzw = -r1.www + r0.yzw;
  r0.yzw = afRGBA_Offset[3].xxx * r0.yzw + r1.www;
  r0.yzw = r0.yzw * afRGBA_Offset[2].zzz + afRGBA_Offset[2].www;
  r2.xyzw = atex2D_Texture_0.SampleLevel(asamp2D_Texture_0_s, v0.xy, 0).xyzw;
  r3.xyz = r2.xyz * r0.yzw;
  r1.w = dot(r2.xyzw, afRGBA_Modulate[1].xyzw);
  o0.w = saturate(afRGBA_Modulate[0].w + r1.w);
  r3.w = 1;
  r2.x = dot(r3.xyzw, m44_PreTonemapColorTransformMatrix._m00_m10_m20_m30);
  r2.y = dot(r3.xyzw, m44_PreTonemapColorTransformMatrix._m01_m11_m21_m31);
  r2.z = dot(r3.xyzw, m44_PreTonemapColorTransformMatrix._m02_m12_m22_m32);
  r2.xyz = -afRGBA_Modulate[2].xyz + r2.xyz;
  r2.xyz = r0.xxx * r2.xyz + afRGBA_Modulate[2].xyz;
  r2.xyz = max(float3(5.96046448e-008,5.96046448e-008,5.96046448e-008), r2.xyz);
  r2.xyz = fParam_TonemapMaxMappingLuminance.xxx * -r2.xyz;
  r2.xyz = float3(1.44269502,1.44269502,1.44269502) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r3.xyz = -r2.xyz * fParam_TonemapMaxMappingLuminance.yyy + float3(1,1,1);
  r2.xyz = float3(1,1,1) + -r2.xyz;
  r3.xyz = r3.xyz * r3.xyz;
  r2.xyz = saturate(r3.xyz * r2.xyz);
  r3.xyz = float3(1,1,1) + -r2.xyz;
  r0.x = dot(r1.xyz, float3(0.333333343,0.333333343,0.333333343));
  r1.xyz = r1.xyz + -r0.xxx;
  r1.xyz = saturate(afRGBA_Offset[1].xxx * r1.xyz + r0.xxx);
  r1.xyz = r1.xyz * afRGBA_Offset[0].zzz + afRGBA_Offset[0].www;
  r4.xyzw = atex2D_Texture_1.SampleLevel(asamp2D_Texture_1_s, v1.xy, 0).xyzw;
  r0.xyz = r4.xyz * r0.yzw + r1.xyz;
  r0.w = 1;
  r1.x = saturate(dot(r0.xyzw, m44_PreTonemapGlareColorTransformMatrix._m00_m10_m20_m30));
  r1.y = saturate(dot(r0.xyzw, m44_PreTonemapGlareColorTransformMatrix._m01_m11_m21_m31));
  r1.z = saturate(dot(r0.xyzw, m44_PreTonemapGlareColorTransformMatrix._m02_m12_m22_m32));
  r0.xyz = r3.xyz * r1.xyz + r2.xyz;
  r0.xyz = max(float3(5.96046448e-008,5.96046448e-008,5.96046448e-008), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = fParam_GammaCorrection.xxx * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  return;
}
