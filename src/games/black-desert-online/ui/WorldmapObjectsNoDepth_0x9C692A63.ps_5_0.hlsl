#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Sep 19 02:48:07 2026
// World map objects drawn without depth test (stippled, blinks toward yellow). Same port as WorldmapObjects_0x093735FF:
// half-strength exposure multiply, gamma encode removed, bool names fixed against the -d disassembly (cb5[7], cb7[4]).

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

cbuffer HDRConst : register(b3)
{
  float4 MaxEffectOutput : packoffset(c0);
  float MaxEffectColorBrightness : packoffset(c1);
  float hdrEncodeMulti : packoffset(c1.y);
  float hdrEncodeMulti_Effect : packoffset(c1.z);
  float gammaConst : packoffset(c1.w);
}

cbuffer shadowConst : register(b4)
{
  row_major float4x4 matShadowProjectionTexScale0 : packoffset(c0);
  row_major float4x4 matShadowProjectionTexScale1 : packoffset(c4);
  row_major float4x4 matShadowProjectionTexScale2 : packoffset(c8);
  row_major float4x4 matShadowProjectionTexScale3 : packoffset(c12);
  float4 vecShadowViewPosition0 : packoffset(c16);
  float4 vecShadowViewPosition1 : packoffset(c17);
  float4 vecShadowViewPosition2 : packoffset(c18);
  float4 vecShadowViewPosition3 : packoffset(c19);
  float fShadowmapSizeNear : packoffset(c20);
  float fShadowmapSizeFar : packoffset(c20.y);
  float fInvShadowmapSizeNear : packoffset(c20.z);
  float fInvShadowmapSizeFar : packoffset(c20.w);
  float fShadowmapSizeDynamic : packoffset(c21);
  float fInvShadowmapSizeDynamic : packoffset(c21.y);
  float fShadowmapNormalScale : packoffset(c21.z);
  float shadowConstFloatDummy0 : packoffset(c21.w);
}

cbuffer WorldmapCommonConst : register(b5)
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

cbuffer WorldmapTerrainConst : register(b6)
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

cbuffer WorldmapObjectConst : register(b7)
{
  row_major float4x4 matRelativeViewProjection : packoffset(c0);
  bool isSelectedLayer : packoffset(c4);
  bool isRoad : packoffset(c4.y);
  bool useFog : packoffset(c4.z);
  bool Dummy : packoffset(c4.w);
  int nRenderMode : packoffset(c5);
  float3 WorldmapObjectConstdummy : packoffset(c5.y);
}

SamplerState PA_LINEAR_WRAP_LODBIAS_FILTER_Minus1_s : register(s0);
SamplerState PA_LINEAR_BORDER_FILTER_1111_s : register(s1);
SamplerState PA_POINT_CLAMP_FILTER_s : register(s2);
SamplerState PA_POINT_WRAP_FILTER_s : register(s3);
SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s4);
Texture2D<float4> texDiffuse : register(t0);
Texture2D<float4> texShadowMap : register(t1);
Texture2D<float4> texShadowResult : register(t2);
Texture2D<float4> texTerritoryLayer : register(t3);
Texture2D<float4> texFogTerrainMap : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  nointerpolation float v4 : TEXCOORD3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v0.xxyy + v0.xxyy;
  r0.xyzw = cmp(r0.xyzw >= -r0.yyww);
  r0.xyzw = r0.xyzw ? float4(2,0.5,2,0.5) : float4(-2,-0.5,-2,-0.5);
  r0.yw = v0.xy * r0.yw;
  r0.yw = frac(r0.yw);
  r0.xy = r0.xz * r0.yw;
  r0.zw = cmp(r0.xy >= float2(1,1));
  r0.xy = cmp(r0.xy < float2(1,1));
  r0.xz = r0.yw ? r0.xz : 0;
  r0.x = (int)r0.x | (int)r0.z;
  if (r0.x != 0) {
    discard;
  }
  r0.xyz = vecViewPosition.xyz + v3.xyz;
  r1.xy = -vecFarTerrainHeightConst.xy + r0.xz;
  r1.xy = r1.xy / vecFarTerrainHeightConst.zw;
  r1.x = texFogTerrainMap.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r1.xy, 0).w;
  r1.x = 16 * r1.x;
  r1.x = r1.x * r1.x;
  r1.x = min(1, r1.x);
  r1.yz = -vecCurrentPos.xz + r0.xz;
  r1.y = dot(r1.yz, r1.yz);
  r1.y = sqrt(r1.y);
  r1.z = -r1.y * 9.99999975e-005 + 1;
  r1.z = max(0, r1.z);
  r1.z = r1.z * 0.5 + r1.x;
  r1.z = min(1, r1.z);
  r1.x = isCharacterMode ? r1.z : r1.x;
  r1.z = -0.0199999996 + r1.x;
  r1.z = cmp(r1.z < 0);
  if (r1.z != 0) discard;
  r2.xyzw = texDiffuse.Sample(PA_LINEAR_WRAP_LODBIAS_FILTER_Minus1_s, v2.xy).xyzw;
  r2.xyz = r2.xyz * r2.xyz;
  r1.z = saturate(r2.w + r2.w);
  r1.w = -50000 + fViewDistance;
  r1.w = 2.49999994e-006 * r1.w;
  r1.w = max(0.300000012, r1.w);
  r3.xyz = -vecCameraLookAt.xyz + r0.xyz;
  r2.w = dot(r3.xyz, r3.xyz);
  r2.w = sqrt(r2.w);
  r1.w = 700000 * r1.w;
  r1.w = r2.w / r1.w;
  r1.w = min(1, r1.w);
  r1.w = -r1.w * r1.w + 1;
  r1.w = r1.w * r1.w;
  r3.w = r1.z * r1.w;
  r1.z = r1.z * r1.w + -0.200000003;
  r1.z = cmp(r1.z < 0);
  if (r1.z != 0) discard;
  r2.xyz = r2.xyz + r2.xyz;
  r1.zw = invScreenSize.xy * v0.xy;
  r1.zw = texShadowResult.Sample(PA_LINEAR_BORDER_FILTER_1111_s, r1.zw).xz;
  r1.w = 1 + -r1.w;
  r0.w = 1;
  r4.x = dot(r0.xyzw, matShadowProjectionTexScale._m00_m10_m20_m30);
  r4.y = dot(r0.xyzw, matShadowProjectionTexScale._m01_m11_m21_m31);
  r4.z = dot(r0.xyzw, matShadowProjectionTexScale._m02_m12_m22_m32);
  r0.w = dot(r0.xyzw, matShadowProjectionTexScale._m03_m13_m23_m33);
  r4.xyz = r4.xyz / r0.www;
  r5.xyz = r4.xyz * float3(22,22,22) + float3(-11,-11,-11);
  r5.xyz = saturate(float3(-10,-10,-10) + abs(r5.xyz));
  r6.xyz = cmp(float3(0.999000013,0.999000013,0.999000013) < r5.xyz);
  r0.w = (int)r6.y | (int)r6.x;
  r0.w = (int)r6.z | (int)r0.w;
  if (r0.w != 0) {
    r2.w = 1;
  }
  r6.xy = -fInvShadowmapSizeNear + r4.xy;
  r6.zw = fShadowmapSizeNear * r6.xy;
  r6.zw = frac(r6.zw);
  r6.xy = fShadowmapSizeNear * r6.xy + -r6.zw;
  r6.xy = float2(1,1) + r6.xy;
  r6.xy = fInvShadowmapSizeNear * r6.xy;
  r7.xyzw = texShadowMap.Gather(PA_POINT_CLAMP_FILTER_s, r6.xy).xyzw;
  r7.xyzw = abs(r7.wzxy) + -r4.zzzz;
  r7.xyzw = float4(1442.69507,1442.69507,1442.69507,1442.69507) * r7.xyzw;
  r7.xyzw = exp2(r7.xyzw);
  r7.xyzw = min(float4(1,1,1,1), r7.xyzw);
  r6.xy = r7.yw + -r7.xz;
  r6.xy = r6.zz * r6.xy + r7.xz;
  r4.w = r6.y + -r6.x;
  r4.w = saturate(r6.w * r4.w + r6.x);
  r6.xyzw = fInvShadowmapSizeNear * float4(0,-1,-1,0) + r4.xyxy;
  r7.xyzw = fShadowmapSizeNear * r6.xyzw;
  r7.xyzw = frac(r7.xyzw);
  r6.xyzw = fShadowmapSizeNear * r6.xyzw + -r7.xyzw;
  r6.xyzw = float4(1,1,1,1) + r6.xyzw;
  r6.xyzw = fInvShadowmapSizeNear * r6.xyzw;
  r8.xyzw = texShadowMap.Gather(PA_POINT_CLAMP_FILTER_s, r6.xy).xyzw;
  r8.xyzw = abs(r8.wzxy) + -r4.zzzz;
  r8.xyzw = float4(1442.69507,1442.69507,1442.69507,1442.69507) * r8.xyzw;
  r8.xyzw = exp2(r8.xyzw);
  r8.xyzw = min(float4(1,1,1,1), r8.xyzw);
  r6.xy = r8.yw + -r8.xz;
  r6.xy = r7.xx * r6.xy + r8.xz;
  r5.w = r6.y + -r6.x;
  r5.w = saturate(r7.y * r5.w + r6.x);
  r4.w = r5.w + r4.w;
  r6.xyzw = texShadowMap.Gather(PA_POINT_CLAMP_FILTER_s, r6.zw).xyzw;
  r6.xyzw = abs(r6.wzxy) + -r4.zzzz;
  r6.xyzw = float4(1442.69507,1442.69507,1442.69507,1442.69507) * r6.xyzw;
  r6.xyzw = exp2(r6.xyzw);
  r6.xyzw = min(float4(1,1,1,1), r6.xyzw);
  r6.yw = r6.yw + -r6.xz;
  r6.xy = r7.zz * r6.yw + r6.xz;
  r5.w = r6.y + -r6.x;
  r5.w = saturate(r7.w * r5.w + r6.x);
  r4.w = r5.w + r4.w;
  r6.xy = fShadowmapSizeNear * r4.xy;
  r6.xy = frac(r6.xy);
  r4.xy = fShadowmapSizeNear * r4.xy + -r6.xy;
  r4.xy = float2(1,1) + r4.xy;
  r4.xy = fInvShadowmapSizeNear * r4.xy;
  r7.xyzw = texShadowMap.Gather(PA_POINT_CLAMP_FILTER_s, r4.xy).xyzw;
  r7.xyzw = abs(r7.wzxy) + -r4.zzzz;
  r7.xyzw = float4(1442.69507,1442.69507,1442.69507,1442.69507) * r7.xyzw;
  r7.xyzw = exp2(r7.xyzw);
  r7.xyzw = min(float4(1,1,1,1), r7.xyzw);
  r4.xy = r7.yw + -r7.xz;
  r4.xy = r6.xx * r4.xy + r7.xz;
  r4.y = r4.y + -r4.x;
  r4.x = saturate(r6.y * r4.y + r4.x);
  r4.x = r4.w + r4.x;
  r4.y = 0.25 * r4.x;
  r4.x = r4.x * -0.5 + 3;
  r4.y = r4.y * r4.y;
  r4.z = dot(r5.xyz, float3(1,1,1));
  r4.x = r4.x * r4.y + r4.z;
  r4.x = min(1, r4.x);
  r0.w = r0.w ? r2.w : r4.x;
  r0.w = min(r1.z, r0.w);
  r1.z = dot(v3.xyz, v3.xyz);
  r1.z = rsqrt(r1.z);
  r4.xyz = v3.xyz * r1.zzz;
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(0.600000024,0.600000024,0.600000024) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = float3(0.550000012,0.550000012,0.550000012) * r2.xyz;
  r2.w = dot(v1.xyz, vecLightWorldMap.xyz);
  r4.w = saturate(r2.w * 0.5 + 0.5);
  r5.xyz = saturate(float3(0.400000006,0.449999988,0.400000006) + r0.www);
  r5.xyz = r5.xyz * r4.www;
  r6.xyz = rsqrt(vecSunColorConst.xyz);
  r6.xyz = float3(1,1,1) / r6.xyz;
  r7.xyz = float3(0.5,0.5,0.5) * vecAmbientOcclusionColorConst.xyz;
  r5.xyz = r5.xyz * r6.xyz + r7.xyz;
  r4.w = 1 + -vecLightWorldMap.y;
  r4.w = r4.w * r4.w;
  r6.xyz = r5.xyz * r4.www;
  r5.xyz = r6.xyz * float3(2,2,2) + r5.xyz;
  r6.xyz = v3.xyz * r1.zzz + v1.xyz;
  r1.z = dot(r6.xyz, r6.xyz);
  r1.z = rsqrt(r1.z);
  r6.xyz = r6.xyz * r1.zzz;
  r7.xyz = float3(1,1,1) + -vecSunColorConst.xyz;
  r1.z = saturate(dot(r4.xyz, r6.xyz));
  r1.z = 1 + -r1.z;
  r4.x = r1.z * r1.z;
  r4.x = r4.x * r4.x;
  r1.z = r4.x * r1.z;
  r4.xyz = r7.xyz * r1.zzz + vecSunColorConst.xyz;
  r0.w = saturate(r2.w * r0.w);
  r4.xyz = r4.xyz * r0.www + r5.xyz;
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = fBrightnessWorldMap * r2.xyz;

  r2.xyz = ((WORLD_MAP_EXPOSURE - 1.0f) * 0.5f + 1.0f) * r2.xyz;
  r2.xyz = float3(4,4,4) * r2.xyz;
  r0.w = saturate(1.75 + -r1.w);
  r4.xyz = r2.xyz * r0.www;
  r1.z = 3 * totalTime;
  r1.z = sin(r1.z);
  r2.xyz = -r2.xyz * r0.www + float3(1,1,0);
  r2.xyz = abs(r1.zzz) * r2.xyz + r4.xyz;
  r3.xyz = r2.xyz;
  r0.w = cmp(nRenderMode == 1);
  if (r0.w != 0) {
    r0.w = cmp(isVillageSiege_common != 0);
    r1.z = cmp(isNewSiegeMode != 0);
    r1.z = cmp((int)r1.z == 0);
    r0.w = r0.w ? r1.z : 0;
    r1.zw = r0.xz * float2(7.81249983e-005,7.81249983e-005) + -fixedTexCoord_common.zw;
    r2.x = 0.5 / fFieldDataResolution_common;
    r1.zw = r2.xx + r1.zw;
    r1.zw = r1.zw / fixedTexCoord_common.xy;
    r1.z = texTerritoryLayer.SampleLevel(PA_POINT_WRAP_FILTER_s, r1.zw, 0).w;
    r1.w = selectVillageSiegeKey_common;
    r1.z = -r1.z * 255 + r1.w;
    r1.z = cmp(abs(r1.z) < 0.400000006);
    r1.w = r1.y * 4.99999987e-005 + -totalTime;
    r1.w = sin(r1.w);
    r1.w = 1 + r1.w;
    r2.zw = float2(0.5,0.25) * r1.ww;
    r1.w = r2.z * r2.z;
    r4.xy = r1.ww * float2(0.899999976,-0.100000001) + float2(0,1);
    r2.xy = r4.xy * r2.zz;
    r2.xyzw = r3.xyzw + r2.xxyw;
    r2.xyzw = min(float4(1,1,1,1), r2.xyzw);
    r2.xyzw = r1.zzzz ? r2.xyzw : r3.xyzw;
    r2.xyzw = r0.wwww ? r2.xyzw : r3.xyzw;
    r0.x = dot(r0.xyz, float3(0.00039999999,0.000119999997,-0.000110000001));
    r0.x = sin(r0.x);
    r0.xyz = r0.xxx * float3(0.0500000007,0.0500000007,0.0500000007) + float3(0.949999988,0.949999988,0.949999988);
    r0.w = 0.800000012;
    r3.xyzw = r2.xyzw * r0.xyzw;
    r0.x = 0.560000002 * r2.w;
    r3.w = isTownMode ? r0.x : r3.w;
  }
  r0.x = cmp(isSelectedLayer != 0);
  r0.y = cmp(isRoad != 0);
  r0.z = cmp(v4.x != 0.000000);
  r0.x = (int)r0.z | (int)r0.x;
  if (r0.x != 0) {
    r0.xzw = log2(r3.xyz);
    r0.xzw = float3(2.20000005,2.20000005,2.20000005) * r0.xzw;
    r0.xzw = exp2(r0.xzw);
    r0.xzw = float3(3,3,3) * r0.xzw;
    r1.z = totalTime + totalTime;
    r1.z = sin(r1.z);
    r3.xyz = abs(r1.zzz) * r0.xzw + r3.xyz;
  }
  r0.x = cmp(isTownMode != 0);
  r0.z = cmp(doTerrainHide_common != 0);
  r0.w = cmp(isVillageSiege_common != 0);
  r0.x = cmp((int)r0.x == 0);
  r0.x = r0.x ? r0.y : 0;
  if (r0.x != 0) {
    r0.x = r1.y * 9.99999975e-006 + -totalTime;
    r0.x = sin(r0.x);
    r0.x = 1 + -abs(r0.x);
    r0.x = log2(r0.x);
    r0.x = 14 * r0.x;
    r0.x = exp2(r0.x);
    r1.yzw = r3.xyz + r3.xyz;
    r3.xyz = r0.xxx * r1.yzw + r3.xyz;
  }
  r1.yzw = log2(r3.xyz);
  r1.yzw = float3(1.70000005,1.70000005,1.70000005) * r1.yzw;
  r3.xyz = exp2(r1.yzw);
  if (useFog != 0) {
    r3.w = r3.w * r1.x;
  }
  r0.x = cmp(isNewSiegeMode != 0);
  r0.x = cmp((int)r0.x == -1);
  r0.x = r0.x ? r0.w : 0;
  r0.x = (int)r0.x | (int)r0.z;
  r1.xyzw = r3.xyzw * r3.xyzw;
  r1.xyzw = float4(0.300000012,0.300000012,0.300000012,0.300000012) * r1.xyzw;
  o0.xyzw = r0.xxxx ? r1.xyzw : r3.xyzw;
  return;
}