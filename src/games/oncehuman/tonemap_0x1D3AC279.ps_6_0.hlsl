// =====================================================================================
// Once Human - Tonemap & Color Grade Pass (Gameplay, Isles of Abyss)
// API: DX12 (sm6)
//
// RenoDX Injection Details:
// - Replaces 0x2FC428AF since Isles of Abyss. Same math. The update added the
//   MinBrightness/MaxBrightness lift/gain step, dropped with the gamma encode, and grew PerScene.
// - DXC decompile with the scene composite pulled out so it can be tapped.
// - Custom effect-strength sliders multiplied in at each effect source.
// - Bypasses vanilla display-gamma encode in favor of RenoDX tone mapping.
// =====================================================================================
#include "./shared.h"

Texture2D<float4> SDFCheckerBuffer : register(t0);

Texture2D<float4> AutoExposureTex : register(t1);

Texture2D<float4> BloomTex : register(t2);

Texture2D<float4> ColorGradingLut : register(t3);

Texture2D<float4> BgTex : register(t4);

cbuffer _Globals : register(b0) {
  float4 Tint : packoffset(c000.x);
  float GrayScale : packoffset(c001.x);
  float VignetteIntensity : packoffset(c001.y);
  float ChromaticAberrationRange : packoffset(c001.z);
  float ChromaticAberrationIntensity : packoffset(c001.w);
  float MaxBrightness : packoffset(c002.x);
  float MinBrightness : packoffset(c002.y);
  float BrightnessFactor : packoffset(c002.z);
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

SamplerState Sampler_Point_Clamp : register(s1);

float4 main(
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _14 = (TEXCOORD.x * 2.0f) + -1.0f;
  float _15 = (TEXCOORD.y * 2.0f) + -1.0f;
  float _22 = min(max((1.0f - ChromaticAberrationRange), 0.0f), 1.0f);
  float _23 = 1.0f - _22;
  float _28 = saturate((abs(_14) - _22) / _23);
  float _29 = saturate((abs(_15) - _22) / _23);
  float _34 = TEXCOORD.x + -0.5f;
  float _35 = TEXCOORD.y + -0.5f;
  float ca_intensity = ChromaticAberrationIntensity * shader_injection.chromatic_aberration_strength;  // RENODX: chromatic aberration strength
  float _53 = (((_28 * _28) * (float((int)(((int)(uint)((bool)(_34 > 0.0f))) - ((int)(uint)((bool)(_34 < 0.0f))))) * 0.029999999329447746f)) * (3.0f - (_28 * 2.0f))) * ca_intensity;
  float _58 = (((_29 * _29) * (float((int)(((int)(uint)((bool)(_35 > 0.0f))) - ((int)(uint)((bool)(_35 < 0.0f))))) * 0.029999999329447746f)) * (3.0f - (_29 * 2.0f))) * ca_intensity;
  float4 _61 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _65 = BgTex.Sample(Sampler_Bilinear_Clamp, float2((TEXCOORD.x - (_53 * 0.33333298563957214f)), (TEXCOORD.y - (_58 * 0.33333298563957214f))));
  float4 _71 = BgTex.Sample(Sampler_Bilinear_Clamp, float2((TEXCOORD.x - (_53 * 0.6666659712791443f)), (TEXCOORD.y - (_58 * 0.6666659712791443f))));
  float _73 = -0.0f - _15;
  float _75 = min(max(_73, 0.0f), 1.0f);
  float _78 = (VignetteIntensity * shader_injection.vignette_strength) * _14;  // RENODX: vignette strength
  float _79 = (VignetteIntensity * shader_injection.vignette_strength) * _73;
  float _82 = 1.0f / (dot(float2(_78, _79), float2(_78, _79)) + 1.0f);
  float4 _83 = BloomTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _88 = SDFCheckerBuffer.SampleLevel(Sampler_Point_Clamp, float2(0.5f, 0.5f), 0.0f);
  float _100 = (_82 * _82) * (1.0f - ((_75 * _75) * min(min(DayNightFade.w, (1.0f - VolumeWeight)), _88.w)));
  float4 _104 = AutoExposureTex.Sample(Sampler_Bilinear_Clamp, float2(0.5f, 0.5f));
  float _110 = (_88.w * 0.8999999761581421f) + 0.10000000149011612f;

  // RENODX: HDR scene tapped here (pre log-shaper / pre-LUT). Plain RGB, no swizzle.
  float3 untonemapped = (_100 * float3(_61.x, _65.y, _71.z)) * _104.x + (_110 * _83.xyz) * shader_injection.bloom_strength;  // RENODX: bloom strength

  float3 tinted = SampleColorGradingLut(ColorGradingLut, Sampler_Bilinear_Clamp, untonemapped) * Tint.rgb;
  float luminance = dot(tinted, float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));

  // RENODX: graded SDR look tapped here (linear, before the brightness step and display-gamma encode).
  float3 graded = lerp(tinted, luminance, GrayScale);

  SV_Target.xyz = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(untonemapped, graded));
  SV_Target.w = lerp(Tint.w, luminance, GrayScale);
  return SV_Target;

  // ---- vanilla output (replaced by ToneMapPass above) ----
  // float _199 = 1.0f / ((BrightnessFactor * 0.7999999523162842f) + 1.7999999523162842f);
  // float _205 = (MinBrightness * 0.03999999910593033f) + -0.019999999552965164f;
  // float _217 = (MaxBrightness * 0.20000004768371582f) + 0.8999999761581421f;
  // SV_Target.xyz = exp2(log2(_217 * max(lerp(graded, 1.0f, _205), 0.0f)) * _199);
}
