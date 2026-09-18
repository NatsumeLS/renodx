#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Sep 19 02:48:07 2026
// World map far terrain / sea shells. Same port as WorldmapMesh_0x0B7A12D4: full exposure multiply and the output saturate removed.
// The final select reads cb3[7].y = isTownMode (the decompiler printed isCharacterMode).

cbuffer _Globals : register(b0)
{
  float4x4 matFroxelViewProj : packoffset(c0);
  float4x4 matFarCloudShadowProjectionTexScale : packoffset(c4);
  float fTextureSampleBias : packoffset(c8) = {0};
  float4 vecTerritoryColor[100] : packoffset(c9);
  float4 vecScaleTranslate : packoffset(c109);
  float4x4 matShadowProjectionTexScale : packoffset(c110);
  float fWaypointMapSectorX : packoffset(c114);
  float fWaypointMapSectorZ : packoffset(c114.y);
  float fWaypointMapSectorSizeX : packoffset(c114.z);
  float fWaypointMapSectorSizeZ : packoffset(c114.w);
  bool isNewSiegeMode : packoffset(c115);
  int arrCycloneSize : packoffset(c115.y) = {0};
  float4 arrCyclone[5] : packoffset(c116);
  float2 shellCountFadeInfo : packoffset(c121);
  bool g_isUseHeight : packoffset(c121.z);
}

cbuffer outdoorScatteringConst : register(b2)
{
  float4 vecSunColorConst : packoffset(c0);
  float4 vecSunGlareColorConst : packoffset(c1);
  float4 vecHorizon0ColorConst : packoffset(c2);
  float4 vecHorizon1ColorConst : packoffset(c3);
  float4 vecSkyBaseColorConst : packoffset(c4);
  float4 vecExtinctionColorConst : packoffset(c5);
  float4 vecReighColorConst : packoffset(c6);
  float4 vecSunScatterColorConst : packoffset(c7);
  float4 vecAmbientColorConst[2] : packoffset(c8);
  float4 vecAmbientOcclusionColorConst : packoffset(c10);
  float4 vecDeepAOColorConst : packoffset(c11);
  float4 vecSkinAmbientColorConst : packoffset(c12);
  float4 vecHairAmbientColorConst : packoffset(c13);
  float4 vecEffectAmbientColorAlphaConst : packoffset(c14);
  float4 vecEffectAmbientColorConst : packoffset(c15);
  float4 vecEffectAmbientColorHit : packoffset(c16);
  float4 vecEffectAmbientColorHitAlpha : packoffset(c17);
  float3 vecSunDirection : packoffset(c18);
  float fSeaHeightConst : packoffset(c18.w);
  float3 vecMoonDirection : packoffset(c19);
  float IndoorRateRegion : packoffset(c19.w);
  float fSunScatterExpConst : packoffset(c20);
  float fSunGlareExpConst : packoffset(c20.y);
  float fSunExpConst : packoffset(c20.z);
  float fScatterDistanceFalloffConst : packoffset(c20.w);
  float fMieDistanceFalloffConst : packoffset(c21);
  float fMieHeightConst : packoffset(c21.y);
  float fReighDistanceFalloffConst : packoffset(c21.z);
  float fEnvIntensityConst : packoffset(c21.w);
  float fHorizonColorExp0Const : packoffset(c22);
  float fHorizonColorExp1Const : packoffset(c22.y);
  float fCharacterLightMultiply : packoffset(c22.z);
  float fCharacterLightMultiply2 : packoffset(c22.w);
  float RainAmount : packoffset(c23);
  float AirTemperature : packoffset(c23.y);
  float AirTemperatureForParticle : packoffset(c23.z);
  float IndoorRateRoof : packoffset(c23.w);
  float3 vecLightDirection : packoffset(c24);
  float fCloudLayer0Const : packoffset(c24.w);
  float fCloudLayer1Const : packoffset(c25);
  float fCloudLayer2Const : packoffset(c25.y);
  float fCloudLayer3Const : packoffset(c25.z);
  float fCloudLayer4Const : packoffset(c25.w);
  float fCloudLayer5Const : packoffset(c26);
  float fCloudLayer6Const : packoffset(c26.y);
  float fCloudLayer7Const : packoffset(c26.z);
  float fCloudLayer8Const : packoffset(c26.w);
  float fCloudLayer9Const : packoffset(c27);
  float fCloudLayer10Const : packoffset(c27.y);
  float fCloudLayer11Const : packoffset(c27.z);
  float fCloudLayer12Const : packoffset(c27.w);
  float4 fShaderTest : packoffset(c28) = {1,1,1,1};
  float4 vecCloudColorConst : packoffset(c29);
  float3 vecColorMultiply : packoffset(c30);
  float fBrightnessMultiply : packoffset(c30.w);
  float fScatteringScale : packoffset(c31);
  float fAerosolDensityScale : packoffset(c31.y);
  float fAerosolPhaseFunG : packoffset(c31.z);
  float fAerosolAbsorbtionScale : packoffset(c31.w);
  float fTurbidity : packoffset(c32);
  float fRayleighHeight : packoffset(c32.y);
  float fMieHeight2 : packoffset(c32.z);
  float fCloudAltitude : packoffset(c32.w);
  float fCloudThickness : packoffset(c33);
  float fCloudDensity : packoffset(c33.y);
  float fCloudDensityContrast : packoffset(c33.z);
  float fCloudBaseScale : packoffset(c33.w);
  float fCloudDetailScale : packoffset(c34);
  bool isSceneScatter : packoffset(c34.y);
  float fRainPoolAmount : packoffset(c34.z);
  float fSnowPoolAmount : packoffset(c34.w);
}

cbuffer WorldmapCommonConst : register(b3)
{
  float4 vecFarTerrainColorConst : packoffset(c0);
  float4 invScreenSize : packoffset(c1);
  float4 vecWindDirection : packoffset(c2);
  float3 vecCurrentPos : packoffset(c3);
  float totalTime : packoffset(c3.w);
  float3 vecCameraLookAt : packoffset(c4);
  float fBrightnessWorldMap : packoffset(c4.w);
  float3 vecViewPosition : packoffset(c5);
  float fViewDistance : packoffset(c5.w);
  float3 vecLightWorldMap : packoffset(c6);
  float fRenderDeltaTime : packoffset(c6.w);
  bool isCharacterMode : packoffset(c7);
  bool isTownMode : packoffset(c7.y);
  bool isVillageSiege_common : packoffset(c7.z);
  bool doTerrainHide_common : packoffset(c7.w);
  float4 fixedTexCoord_common : packoffset(c8);
  int selectVillageSiegeKey_common : packoffset(c9);
  float fFieldDataResolution_common : packoffset(c9.y);
  float2 dummy_1 : packoffset(c9.z);
}

cbuffer WorldmapTerrainConst : register(b4)
{
  row_major float4x4 matWorldViewProjection : packoffset(c0);
  float4 vecFarTerrainHeightConst : packoffset(c4);
  float4 fixedTexCoord : packoffset(c5);
  float4 StartColorLocationInfo : packoffset(c6);
  float4 EndColorLocationInfo : packoffset(c7);
  float4 MinusColorLocationInfo : packoffset(c8);
  float4 detailTextureInfo : packoffset(c9);
  float fSelectedFieldType : packoffset(c10);
  float fLocationInfoNormalizeMid : packoffset(c10.y);
  float fLocationInfoNormalize : packoffset(c10.z);
  float fFieldDataResolution : packoffset(c10.w);
  bool isLocationInfo : packoffset(c11);
  bool isRegionRender : packoffset(c11.y);
  bool isVillageSiege : packoffset(c11.z);
  bool isOceanSiege : packoffset(c11.w);
  bool doTerrainHide : packoffset(c12);
  bool isGreatSeaMapRender : packoffset(c12.y);
  int selectTerritoryKey : packoffset(c12.z);
  int selectOccupySiegeKey : packoffset(c12.w);
  int selectRegionKey : packoffset(c13);
  int selectOceanSiegeKey : packoffset(c13.y);
  uint territoryDayKey : packoffset(c13.z);
  float dummy : packoffset(c13.w);
}

SamplerState PA_LINEAR_WRAP_FILTER_s : register(s0);
SamplerState PA_LINEAR_BORDER_FILTER_1111_s : register(s1);
SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s2);
Texture2D<float4> texShadowResult : register(t0);
Texture2D<float4> texSceneMask : register(t1);
Texture2D<float4> texFarTerrainDetail : register(t2);
Texture2D<float4> texFarTerrainNormal : register(t3);
Texture2D<float4> texNoise : register(t4);
Texture2D<float4> texFogTerrainMap : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = -vecViewPosition.xyz + v1.xyz;
  r0.x = dot(r0.xyz, r0.xyz);
  r0.x = sqrt(r0.x);
  r0.xy = float2(6.66666665e-006,9.99999975e-006) * r0.xx;
  r0.y = r0.y * r0.y;
  r0.y = r0.y * 0.75 + 0.200000003;
  r0.xy = min(float2(1,1), r0.xy);
  r0.x = -r0.x * r0.x + 1;
  r0.zw = -vecFarTerrainColorConst.xy + v1.xz;
  r0.zw = r0.zw / vecFarTerrainColorConst.zw;
  r1.xy = r0.zw * float2(0.996108949,0.996108949) + float2(0.00194552529,0.00194552529);
  r1.z = 1 + -r1.y;
  r0.zw = texFarTerrainNormal.Sample(PA_LINEAR_CLAMP_FILTER_s, r1.xz).zw;
  r2.xz = r0.wz * float2(2,2) + float2(-1,-1);
  r0.z = -r2.x * r2.x + 1;
  r2.y = sqrt(r0.z);
  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = r2.xyz * r0.zzz;
  r0.z = r2.y * r2.y;
  r0.z = r2.y * r0.z;
  r0.w = dot(r2.xyz, vecLightWorldMap.xyz);
  r0.w = saturate(r0.w * 0.5 + 0.5);
  r0.x = r0.x * r0.z;
  r1.yw = texSceneMask.Sample(PA_LINEAR_CLAMP_FILTER_s, r1.xz).xz;
  r2.xyz = texFarTerrainDetail.Sample(PA_LINEAR_CLAMP_FILTER_s, r1.xz).xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r0.z = 0.899999976 + -r1.y;
  r0.z = saturate(-r1.w * 2 + r0.z);
  r1.x = r0.x * r0.z + -0.00999999978;
  r0.x = r0.x * r0.z;
  r0.z = cmp(r1.x < 0);
  if (r0.z != 0) discard;
  r1.xy = -vecFarTerrainHeightConst.xy + v1.xz;
  r1.xy = r1.xy / vecFarTerrainHeightConst.zw;
  r0.z = texFogTerrainMap.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r1.xy, 0).w;
  r0.z = 16 * r0.z;
  r0.z = r0.z * r0.z;
  r0.z = min(1, r0.z);
  r1.xy = -vecCurrentPos.xz + v1.xz;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = -r1.x * 6.66666674e-005 + 1;
  r1.x = max(0, r1.x);
  r0.z = r1.x * 0.5 + r0.z;
  r0.z = min(1, r0.z);
  r1.x = -0.00999999978 + r0.z;
  r0.x = r0.z * r0.x;
  r0.z = cmp(r1.x < 0);
  if (r0.z != 0) discard;
  r1.xyzw = float4(0.000250000012,0.000250000012,0.000199999995,0.000199999995) * v1.xzzx;
  r0.z = texNoise.Sample(PA_LINEAR_WRAP_FILTER_s, r1.xy).y;
  r1.x = texNoise.Sample(PA_LINEAR_WRAP_FILTER_s, r1.zw).y;
  r0.z = 0.800000012 * r0.z;
  r0.z = r1.x * r1.x + r0.z;
  r0.z = -0.5 + r0.z;
  r1.x = 0.0250000004 * totalTime;
  r1.x = r0.z * 0.200000003 + r1.x;
  r1.y = 0.5 + r1.x;
  r3.xyzw = frac(r1.xxyy);
  r1.xyzw = vecWindDirection.xzxz * r3.xyzw;
  r2.w = -0.5 + r3.y;
  r2.w = abs(r2.w) + abs(r2.w);
  r1.xyzw = v1.xzxz * float4(4.99999987e-006,4.34782623e-006,5.55555562e-006,4.76190462e-006) + r1.xyzw;
  r1.x = texNoise.Sample(PA_LINEAR_WRAP_FILTER_s, r1.xy).y;
  r1.y = texNoise.Sample(PA_LINEAR_WRAP_FILTER_s, r1.zw).y;
  r1.xy = r1.xy * r1.xy;
  r1.y = r1.y * r1.y;
  r1.xy = float2(1.20000005,2.5) * r1.xy;
  r1.xy = min(float2(1,1), r1.xy);
  r0.z = r1.x + r0.z;
  r0.z = r1.y * r2.w + r0.z;
  r1.x = dot(r2.xyz, float3(1.5,1.5,1.5));
  r1.x = r1.x * r1.x;
  r1.x = r1.x * r1.x;
  r1.x = min(1, r1.x);
  r0.z = r1.x + r0.z;
  r1.x = -shellCountFadeInfo.x * 0.0500000007 + 1;
  r0.z = saturate(r1.x + -r0.z);
  r1.x = r0.z * shellCountFadeInfo.y + -0.200000003;
  r0.z = shellCountFadeInfo.y * r0.z;
  o0.w = saturate(dot(r0.zz, r0.xx));
  r0.x = cmp(r1.x < 0);
  if (r0.x != 0) discard;
  r0.x = shellCountFadeInfo.x * 0.300000012 + 0.800000012;
  r1.xyz = r2.xyz * r0.xxx;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.800000012,0.800000012,0.800000012) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(0.800000012,0.800000012,0.800000012) * r1.xyz;
  r0.xz = v0.xy * invScreenSize.xy + invScreenSize.zw;
  r2.xyz = texShadowResult.Sample(PA_LINEAR_BORDER_FILTER_1111_s, r0.xz).xyz;
  r0.x = 0.100000001 + r2.y;
  r0.x = saturate(shellCountFadeInfo.x * 0.0299999993 + r0.x);
  r0.x = min(r2.x, r0.x);
  r0.z = 1 + -r2.z;
  r0.z = saturate(1.70000005 + -r0.z);
  r0.x = saturate(0.300000012 + r0.x);
  r0.x = r0.w * r0.x;
  r2.xyz = rsqrt(vecSunColorConst.xyz);
  r2.xyz = float3(1,1,1) / r2.xyz;
  r3.xyz = float3(0.5,0.5,0.5) * vecAmbientOcclusionColorConst.xyz;
  r2.xyz = r0.xxx * r2.xyz + r3.xyz;
  r0.x = 1 + -vecLightWorldMap.y;
  r0.x = r0.x * r0.x;
  r3.xyz = r2.xyz * r0.xxx;
  r2.xyz = r3.xyz * float3(2,2,2) + r2.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = fBrightnessWorldMap * r1.xyz;

  r1.xyz = WORLD_MAP_EXPOSURE * r1.xyz;
  r1.xyz = float3(4,4,4) * r1.xyz;
  r2.xyz = -r1.xyz * r0.zzz + vecHorizon1ColorConst.xyz;
  r0.xzw = r1.xyz * r0.zzz;
  r1.xyz = r0.yyy * r2.xyz + r0.xzw;
  o0.xyz = isTownMode ? r1.xyz : r0.xzw;
  return;
}