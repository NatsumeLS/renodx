// =====================================================================================
// Once Human - Chromatic Aberration Pass (Gameplay, Isles of Abyss)
// API: DX11 (sm5)
//
// RenoDX Injection Details:
// - Runs after the tonemap on the fp16 clone. Only the intensity is scaled by the CA slider.
// - Original decompile by 3Dmigoto.
// =====================================================================================
#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float Aberration_Intensity : packoffset(c0);
  float Aberration_Radious : packoffset(c0.y);
  float Aberration_GrayLevel : packoffset(c0.z);
}

cbuffer PerScene : register(b1)
{
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
Texture2D<float4> ScreenBuffer : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r0.xy = r0.xy * r0.zz;
  r0.z = 0.100000001 * (Aberration_Intensity * shader_injection.chromatic_aberration_strength);  // RENODX: CA strength
  r0.xy = r0.xy * r0.zz;
  r0.z = Aberration_Radious * 10 + 1;
  r0.xy = r0.xy * r0.zz;
  r0.xy = max(float2(-0.100000001,-0.100000001), r0.xy);
  r0.xy = min(float2(0.100000001,0.100000001), r0.xy);
  r0.zw = ScreenSize.xy * -r0.xy;
  r0.zw = float2(0.5,0.5) * r0.zw;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = sqrt(r0.z);
  r0.z = (int)r0.z;
  r0.z = max(3, (int)r0.z);
  r0.z = min(16, (int)r0.z);
  r0.w = (int)r0.z;
  r0.xy = -r0.xy / r0.ww;
  r1.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, v0.xy).xyzw;
  r2.xyz = float3(0.5,1.5,2.5) / r0.www;
  r3.xyzw = r2.xxxx * float4(-2,2,0,0) + float4(1,0,0,1);
  r2.x = saturate(Aberration_GrayLevel);
  r4.xyzw = float4(1,1,1,1) + -r3.xyzw;
  r3.xyzw = r2.xxxx * r4.xyzw + r3.xyzw;
  r4.xy = v0.xy + r0.xy;
  r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r4.xy).xyzw;
  r6.xyzw = r2.yyyy * float4(-2,2,0,0) + float4(1,0,0,1);
  r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
  r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
  r2.yw = r4.xy + r0.xy;
  r4.xyz = r6.xyz + r3.xyz;
  r5.xyzw = r6.xyzw * r5.xyzw;
  r1.xyzw = r1.xyzw * r3.xyzw + r5.xyzw;
  r3.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yw).xyzw;
  r4.w = r2.z + r2.z;
  r4.w = min(1, r4.w);
  r5.xyzw = r4.wwww * float4(-1,1,0,0) + float4(1,0,0,1);
  r2.z = r2.z * 2 + -1;
  r2.z = max(0, r2.z);
  r6.xyzw = float4(0,0,1,1) + -r5.xyzw;
  r5.xyzw = r2.zzzz * r6.xyzw + r5.xyzw;
  r6.xyzw = float4(1,1,1,1) + -r5.xyzw;
  r5.xyzw = r2.xxxx * r6.xyzw + r5.xyzw;
  r2.yz = r2.yw + r0.xy;
  r4.xyz = r5.xyz + r4.xyz;
  r1.xyzw = r3.xyzw * r5.xyzw + r1.xyzw;
  r2.w = cmp(3 < (int)r0.z);
  if (r2.w != 0) {
    r3.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r2.w = 3.5 / r0.w;
    r5.x = r2.w + r2.w;
    r5.x = min(1, r5.x);
    r5.xyzw = r5.xxxx * float4(-1,1,0,0) + float4(1,0,0,1);
    r2.w = saturate(r2.w * 2 + -1);
    r6.xyzw = float4(0,0,1,1) + -r5.xyzw;
    r5.xyzw = r2.wwww * r6.xyzw + r5.xyzw;
    r6.xyzw = float4(1,1,1,1) + -r5.xyzw;
    r5.xyzw = r2.xxxx * r6.xyzw + r5.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r5.xyz + r4.xyz;
    r1.xyzw = r3.xyzw * r5.xyzw + r1.xyzw;
    r4.w = 4;
    r2.w = 4;
  } else {
    r4.w = 3;
    r2.w = 3;
  }
  r3.x = cmp((int)r2.w < (int)r0.z);
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 4.5 / r0.w;
    r3.z = r3.y + r3.y;
    r3.z = min(1, r3.z);
    r6.xyzw = r3.zzzz * float4(-1,1,0,0) + float4(1,0,0,1);
    r3.y = saturate(r3.y * 2 + -1);
    r7.xyzw = float4(0,0,1,1) + -r6.xyzw;
    r6.xyzw = r3.yyyy * r7.xyzw + r6.xyzw;
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 5;
    r2.w = 5;
  }
  r3.y = cmp((int)r2.w < (int)r0.z);
  r3.x = r3.y ? r3.x : 0;
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 5.5 / r0.w;
    r3.z = r3.y + r3.y;
    r3.z = min(1, r3.z);
    r6.xyzw = r3.zzzz * float4(-1,1,0,0) + float4(1,0,0,1);
    r3.y = saturate(r3.y * 2 + -1);
    r7.xyzw = float4(0,0,1,1) + -r6.xyzw;
    r6.xyzw = r3.yyyy * r7.xyzw + r6.xyzw;
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 6;
    r2.w = 6;
  }
  r3.y = cmp((int)r2.w < (int)r0.z);
  r3.x = r3.y ? r3.x : 0;
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 6.5 / r0.w;
    r3.z = r3.y + r3.y;
    r3.z = min(1, r3.z);
    r6.xyzw = r3.zzzz * float4(-1,1,0,0) + float4(1,0,0,1);
    r3.y = saturate(r3.y * 2 + -1);
    r7.xyzw = float4(0,0,1,1) + -r6.xyzw;
    r6.xyzw = r3.yyyy * r7.xyzw + r6.xyzw;
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 7;
    r2.w = 7;
  }
  r3.y = cmp((int)r2.w < (int)r0.z);
  r3.x = r3.y ? r3.x : 0;
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 7.5 / r0.w;
    r3.z = r3.y + r3.y;
    r3.z = min(1, r3.z);
    r6.xyzw = r3.zzzz * float4(-1,1,0,0) + float4(1,0,0,1);
    r3.y = saturate(r3.y * 2 + -1);
    r7.xyzw = float4(0,0,1,1) + -r6.xyzw;
    r6.xyzw = r3.yyyy * r7.xyzw + r6.xyzw;
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 8;
    r2.w = 8;
  }
  r3.y = cmp((int)r2.w < (int)r0.z);
  r3.x = r3.y ? r3.x : 0;
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 8.5 / r0.w;
    r3.y = r3.y * 2 + -1;
    r3.y = min(1, r3.y);
    r6.xyzw = r3.yyyy * float4(0,-1,1,0) + float4(0,1,0,1);
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 9;
    r2.w = 9;
  }
  r3.y = cmp((int)r2.w < (int)r0.z);
  r3.x = r3.y ? r3.x : 0;
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 9.5 / r0.w;
    r3.y = r3.y * 2 + -1;
    r3.y = min(1, r3.y);
    r6.xyzw = r3.yyyy * float4(0,-1,1,0) + float4(0,1,0,1);
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 10;
    r2.w = 10;
  }
  r3.y = cmp((int)r2.w < (int)r0.z);
  r3.x = r3.y ? r3.x : 0;
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 10.5 / r0.w;
    r3.y = r3.y * 2 + -1;
    r3.y = min(1, r3.y);
    r6.xyzw = r3.yyyy * float4(0,-1,1,0) + float4(0,1,0,1);
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 11;
    r2.w = 11;
  }
  r3.y = cmp((int)r2.w < (int)r0.z);
  r3.x = r3.y ? r3.x : 0;
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 11.5 / r0.w;
    r3.y = r3.y * 2 + -1;
    r3.y = min(1, r3.y);
    r6.xyzw = r3.yyyy * float4(0,-1,1,0) + float4(0,1,0,1);
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 12;
    r2.w = 12;
  }
  r3.y = cmp((int)r2.w < (int)r0.z);
  r3.x = r3.y ? r3.x : 0;
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 12.5 / r0.w;
    r3.y = r3.y * 2 + -1;
    r3.y = min(1, r3.y);
    r6.xyzw = r3.yyyy * float4(0,-1,1,0) + float4(0,1,0,1);
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 13;
    r2.w = 13;
  }
  r3.y = cmp((int)r2.w < (int)r0.z);
  r3.x = r3.y ? r3.x : 0;
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 13.5 / r0.w;
    r3.y = r3.y * 2 + -1;
    r3.y = min(1, r3.y);
    r6.xyzw = r3.yyyy * float4(0,-1,1,0) + float4(0,1,0,1);
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 14;
    r2.w = 14;
  }
  r3.y = cmp((int)r2.w < (int)r0.z);
  r3.x = r3.y ? r3.x : 0;
  if (r3.x != 0) {
    r5.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r3.y = 14.5 / r0.w;
    r3.y = r3.y * 2 + -1;
    r3.y = min(1, r3.y);
    r6.xyzw = r3.yyyy * float4(0,-1,1,0) + float4(0,1,0,1);
    r7.xyzw = float4(1,1,1,1) + -r6.xyzw;
    r6.xyzw = r2.xxxx * r7.xyzw + r6.xyzw;
    r2.yz = r2.yz + r0.xy;
    r4.xyz = r6.xyz + r4.xyz;
    r1.xyzw = r5.xyzw * r6.xyzw + r1.xyzw;
    r4.w = 15;
    r2.w = 15;
  }
  r0.x = cmp((int)r2.w < (int)r0.z);
  r0.x = r0.x ? r3.x : 0;
  if (r0.x != 0) {
    r3.xyzw = ScreenBuffer.Sample(Sampler_Bilinear_Clamp_s, r2.yz).xyzw;
    r0.x = 15.5 / r0.w;
    r0.x = r0.x * 2 + -1;
    r0.x = min(1, r0.x);
    r0.xyzw = r0.xxxx * float4(0,-1,1,0) + float4(0,1,0,1);
    r5.xyzw = float4(1,1,1,1) + -r0.xyzw;
    r0.xyzw = r2.xxxx * r5.xyzw + r0.xyzw;
    r4.w = 15;
    r4.xyzw = r4.xyzw + r0.xyzw;
    r1.xyzw = r3.xyzw * r0.xyzw + r1.xyzw;
  }
  o0.xyzw = r1.xyzw / r4.xyzw;
  return;
}