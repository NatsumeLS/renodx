// =====================================================================================
// Once Human - Tonemap & Color Grade Pass (Menu / Inventory, Isles of Abyss)
// API: DX11 (sm5)
//
// RenoDX Injection Details:
// - Replaces 0x0FAF8922 since Isles of Abyss, which dropped chromatic aberration and added
//   the MinBrightness lift/gain step.
// - Taps the pre-LUT HDR scene and the post-LUT graded SDR scene.
// - Bypasses the vanilla brightness step and display-gamma encode in favor of RenoDX tone mapping.
// - Original decompile by 3Dmigoto.
// =====================================================================================
#include "./shared.h"

cbuffer _Globals : register(b0) {
  float4 Tint : packoffset(c0);
  float GrayScale : packoffset(c1);
  float VignetteIntensity : packoffset(c1.y);
  float MaxBrightness : packoffset(c1.z);
  float MinBrightness : packoffset(c1.w);
  float BrightnessFactor : packoffset(c2);
}

cbuffer PerScene : register(b1) {
  float VolumeWeight : packoffset(c0);
  int LocalFogShapeType : packoffset(c0.y);
  float4 LocalFogPackedParams[4] : packoffset(c1);
  int BlendWithFog : packoffset(c5);
  float4 ScreenSize : packoffset(c6);
  float FrameTime : packoffset(c7);
  float FrameTimeIndex : packoffset(c7.y);
  float FrameDeltaTime : packoffset(c7.z);
  float LastFrameTime : packoffset(c7.w);
  float LastFrameTimeIndex : packoffset(c8);
  float4 FrameID : packoffset(c9);
  float4 SkyLightColor : packoffset(c10);
  float SkyReflectionIntensity : packoffset(c11);
  float SceneEmissiveAdaption : packoffset(c11.y);
  float4 VolumetricFogParamsArray[5] : packoffset(c12);
  int WeatherSystem_Active : packoffset(c17);
  float4 WeatherSystem_Param[11] : packoffset(c18);
  float4 WildShadowMapParams[2] : packoffset(c29);
  float4 VerticalOcclusionCam[2] : packoffset(c31);
  float4 ReflectionProbeInfo : packoffset(c33);
  float4 LocalReflectionProbeInfo[3] : packoffset(c34);
  float4 LightProbeSH[7] : packoffset(c37);
  float4 LocalProbeSH[7] : packoffset(c44);
  float4 DayNightFade : packoffset(c51);
  float4 DayNightCustom : packoffset(c52);
  float4 SkyIlluminance : packoffset(c53);
  float4 RainColorRatio : packoffset(c54);
  float4 WeatherSystem_WindVelocityLastFrame : packoffset(c55);
  float4 WeatherSystem_OffsetByWindLastFrame : packoffset(c56);
}

SamplerState Sampler_Bilinear_Clamp_s : register(s0);
Texture2D<float4> AutoExposureTex : register(t0);
Texture2D<float4> BloomTex : register(t1);
Texture2D<float4> ColorGradingLut : register(t2);
Texture2D<float4> BgTex : register(t3);

#define cmp -

void main(
    float4 v0 : TEXCOORD0,
    float4 v1 : TEXCOORD1,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v0.y * 2 + -1;
  r0.x = saturate(-r0.x);
  r0.x = r0.x * r0.x;
  r0.y = -VolumeWeight + 1;
  r0.y = min(DayNightFade.w, r0.y);
  r0.y = min(1, r0.y);
  r0.x = r0.y * -r0.x + 1;
  r0.yz = v0.xy * float2(2, -2) + float2(-1, 1);
  r0.yz = (VignetteIntensity * shader_injection.vignette_strength) * r0.yz;  // RENODX: vignette strength
  r0.y = dot(r0.yz, r0.yz);
  r0.y = 1 + r0.y;
  r0.y = 1 / r0.y;
  r0.y = r0.y * r0.y;
  r0.x = r0.y * r0.x;
  r1.xyzw = BgTex.Sample(Sampler_Bilinear_Clamp_s, v0.xy).xyzw;
  r0.xyz = r1.zxy * r0.xxx;
  r0.w = AutoExposureTex.Sample(Sampler_Bilinear_Clamp_s, float2(0.5, 0.5)).x;
  r2.xyz = BloomTex.Sample(Sampler_Bilinear_Clamp_s, v0.xy).xyz;
  r0.xyz = r0.xyz * r0.www + r2.zxy * shader_injection.bloom_strength;  // RENODX: bloom strength

  // RENODX: HDR scene tapped here (pre log-shaper / pre-LUT). Channels rotated (B,R,G) -> reorder.
  float3 untonemapped = r0.yzx;

  r0.xyz = float3(-0.0110916002, -0.0110916002, -0.0110916002) + r0.xyz;
  r0.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + float3(0.0375839993, 0.0375839993, 0.0375839993);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.130255386, 0.130255386, 0.130255386) + float3(0.646596014, 0.646596014, 0.646596014));
  r0.w = 31 * r0.x;
  r0.w = floor(r0.w);
  r0.yz = r0.yz * float2(0.0302734207, 0.96875) + float2(0.000488280988, 0.015625);
  r0.x = r0.x * 31 + -r0.w;
  r2.x = r0.w * 0.03125 + r0.y;
  r2.z = -r0.z;
  r0.yz = float2(0.03125, 1) + r2.xz;
  r2.y = 1 + r2.z;
  r2.xyz = ColorGradingLut.Sample(Sampler_Bilinear_Clamp_s, r2.xy).xyz;
  r0.yzw = ColorGradingLut.Sample(Sampler_Bilinear_Clamp_s, r0.yz).xyz;
  r0.yzw = r0.yzw + -r2.xyz;
  r1.xyz = r0.xxx * r0.yzw + r2.xyz;
  r0.xyzw = Tint.xyzw * r1.xyzw;
  r2.x = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
  r1.xyzw = -r1.xyzw * Tint.xyzw + r2.xxxx;
  r0.xyzw = GrayScale * r1.xyzw + r0.xyzw;

  // RENODX: graded SDR look tapped here (linear, before the brightness step and display-gamma encode).
  float3 graded = r0.xyz;

  o0.rgb = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(untonemapped, graded));
  o0.w = r0.w;
  return;

  // ---- vanilla output (replaced by ToneMapPass above) ----
  // r1.xyz = float3(1, 1, 1) + -r0.xyz;
  // r2.xy = MinBrightness * float2(0.0399999991, 0.200000048) + float2(-0.0199999996, 0.899999976);
  // r0.xyz = r1.xyz * r2.xxx + r0.xyz;
  // o0.w = r0.w;
  // r0.xyz = max(float3(0, 0, 0), r0.xyz);
  // r0.xyz = r0.xyz * r2.yyy;
  // r0.xyz = log2(r0.xyz);
  // r0.w = BrightnessFactor * 0.799999952 + 1.79999995;
  // r0.w = 1 / r0.w;
  // r0.xyz = r0.www * r0.xyz;
  // o0.xyz = exp2(r0.xyz);
  // return;
}
