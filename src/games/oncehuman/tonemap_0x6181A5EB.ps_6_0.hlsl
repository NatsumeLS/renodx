// =====================================================================================
// Once Human - Tonemap & Color Grade Pass (Title Screen, Isles of Abyss)
// API: DX12 (sm6)
//
// RenoDX Injection Details:
// - Replaces 0xEC5A7D52 on the title screen since Isles of Abyss, which dropped chromatic
//   aberration and added the MinBrightness/MaxBrightness lift/gain step.
// - DXC decompile with the scene composite pulled out so it can be tapped.
// - Bypasses the vanilla brightness step and display-gamma encode in favor of RenoDX tone mapping.
// =====================================================================================
#include "./shared.h"

Texture2D<float4> AutoExposureTex : register(t0);

Texture2D<float4> BloomTex : register(t1);

Texture2D<float4> ColorGradingLut : register(t2);

Texture2D<float4> BgTex : register(t3);

cbuffer _Globals : register(b0) {
  float4 Tint : packoffset(c000.x);
  float GrayScale : packoffset(c001.x);
  float VignetteIntensity : packoffset(c001.y);
  float MaxBrightness : packoffset(c001.z);
  float MinBrightness : packoffset(c001.w);
  float BrightnessFactor : packoffset(c002.x);
};

cbuffer PerScene : register(b1) {
  float VolumeWeight : packoffset(c000.x);
  int LocalFogShapeType : packoffset(c000.y);
  float4 LocalFogPackedParams[4] : packoffset(c001.x);
  int BlendWithFog : packoffset(c005.x);
  float4 ScreenSize : packoffset(c006.x);
  float FrameTime : packoffset(c007.x);
  float FrameTimeIndex : packoffset(c007.y);
  float FrameDeltaTime : packoffset(c007.z);
  float LastFrameTime : packoffset(c007.w);
  float LastFrameTimeIndex : packoffset(c008.x);
  float4 FrameID : packoffset(c009.x);
  float4 SkyLightColor : packoffset(c010.x);
  float SkyReflectionIntensity : packoffset(c011.x);
  float SceneEmissiveAdaption : packoffset(c011.y);
  float4 VolumetricFogParamsArray[5] : packoffset(c012.x);
  int WeatherSystem_Active : packoffset(c017.x);
  float4 WeatherSystem_Param[11] : packoffset(c018.x);
  float4 WildShadowMapParams[2] : packoffset(c029.x);
  float4 VerticalOcclusionCam[2] : packoffset(c031.x);
  float4 ReflectionProbeInfo : packoffset(c033.x);
  float4 LocalReflectionProbeInfo[3] : packoffset(c034.x);
  float4 LightProbeSH[7] : packoffset(c037.x);
  float4 LocalProbeSH[7] : packoffset(c044.x);
  float4 DayNightFade : packoffset(c051.x);
  float4 DayNightCustom : packoffset(c052.x);
  float4 SkyIlluminance : packoffset(c053.x);
  float4 RainColorRatio : packoffset(c054.x);
  float4 WeatherSystem_WindVelocityLastFrame : packoffset(c055.x);
  float4 WeatherSystem_OffsetByWindLastFrame : packoffset(c056.x);
};

SamplerState Sampler_Bilinear_Clamp : register(s0);

float4 main(
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _10 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _19 = -0.0f - ((TEXCOORD.y * 2.0f) + -1.0f);
  float _21 = min(max(_19, 0.0f), 1.0f);
  float _24 = (VignetteIntensity * shader_injection.vignette_strength) * ((TEXCOORD.x * 2.0f) + -1.0f);  // RENODX: vignette strength
  float _25 = (VignetteIntensity * shader_injection.vignette_strength) * _19;
  float _28 = 1.0f / (dot(float2(_24, _25), float2(_24, _25)) + 1.0f);
  float _40 = (_28 * _28) * (1.0f - ((_21 * _21) * min(min(DayNightFade.w, (1.0f - VolumeWeight)), 1.0f)));
  float4 _44 = AutoExposureTex.Sample(Sampler_Bilinear_Clamp, float2(0.5f, 0.5f));
  float4 _49 = BloomTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));

  // RENODX: HDR scene tapped here (pre log-shaper / pre-LUT). Plain RGB, no swizzle.
  float3 untonemapped = (_40 * _10.xyz) * _44.x + _49.xyz * shader_injection.bloom_strength;  // RENODX: bloom strength

  float _80 = min(max(((log2((((untonemapped.z + -0.01109160017222166f) * 0.5f) + 0.03758399933576584f)) * 0.13025538623332977f) + 0.6465960144996643f), 0.0f), 1.0f) * 31.0f;
  float _81 = floor(_80);
  float _86 = ((min(max(((log2((((untonemapped.x + -0.01109160017222166f) * 0.5f) + 0.03758399933576584f)) * 0.13025538623332977f) + 0.6465960144996643f), 0.0f), 1.0f) * 0.030273420736193657f) + 0.0004882809880655259f) + (_81 * 0.03125f);
  float _87 = 0.984375f - (min(max(((log2((((untonemapped.y + -0.01109160017222166f) * 0.5f) + 0.03758399933576584f)) * 0.13025538623332977f) + 0.6465960144996643f), 0.0f), 1.0f) * 0.96875f);
  float _88 = _80 - _81;
  float4 _90 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2((_86 + 0.03125f), _87));
  float4 _94 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_86, _87));
  float _112 = (lerp(_94.x, _90.x, _88)) * Tint.x;
  float _113 = (lerp(_94.y, _90.y, _88)) * Tint.y;
  float _114 = (lerp(_94.z, _90.z, _88)) * Tint.z;
  float _115 = Tint.w * _10.w;
  float _122 = ((_112 * 0.21250000596046448f) + (_113 * 0.715399980545044f)) + (_114 * 0.07209999859333038f);
  float _131 = ((_122 - _112) * GrayScale) + _112;
  float _132 = ((_122 - _113) * GrayScale) + _113;
  float _133 = ((_122 - _114) * GrayScale) + _114;

  // RENODX: graded SDR look tapped here (linear, before the brightness step and display-gamma encode).
  float3 graded = float3(_131, _132, _133);

  SV_Target.xyz = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(untonemapped, graded));
  SV_Target.w = (lerp(_115, _122, GrayScale));
  return SV_Target;

  // ---- vanilla output (replaced by ToneMapPass above) ----
  // float _139 = 1.0f / ((BrightnessFactor * 0.7999999523162842f) + 1.7999999523162842f);
  // float _145 = (MinBrightness * 0.03999999910593033f) + -0.019999999552965164f;
  // float _157 = (MaxBrightness * 0.20000004768371582f) + 0.8999999761581421f;
  // SV_Target.x = exp2(log2(_157 * max((lerp(_131, 1.0f, _145)), 0.0f)) * _139);
  // SV_Target.y = exp2(log2(_157 * max((lerp(_132, 1.0f, _145)), 0.0f)) * _139);
  // SV_Target.z = exp2(log2(_157 * max((lerp(_133, 1.0f, _145)), 0.0f)) * _139);
}
