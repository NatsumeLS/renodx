#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Wed Sep 23 02:11:38 2026
// World map depth-of-field composite (town or node focus). Both bokeh resolves drop their saturate,
// texDof is upgraded from half-res R8G8B8A8_UNORM so it carries HDR.

cbuffer _Globals : register(b0)
{
  float4x4 matFroxelViewProj : packoffset(c0);
  float fringe : packoffset(c4);
  float threshold : packoffset(c4.y);
  float gain : packoffset(c4.z);
  float fDepth : packoffset(c4.w);
  float ndofstart : packoffset(c5);
  float ndofdist : packoffset(c5.y);
  float fdofstart : packoffset(c5.z);
  float fdofdist : packoffset(c5.w);
  float maxblur : packoffset(c6);
  float4 vecInvScreenSize : packoffset(c7);
  float4 vecScreenSize : packoffset(c8);
  float2 DOFTargetSize : packoffset(c9);
  float2 RenderTargetSize : packoffset(c9.z);
  float MaxBokehSize : packoffset(c10) = {22};
  float BokehFalloff : packoffset(c10.y) = {0.200000003};
  float BokehDepthCutoff : packoffset(c10.z) = {2.5};
  float3 vecAutoFocus : packoffset(c11);
  float photoModeHelpRate : packoffset(c11.w) = {0};
}

cbuffer HDRConst : register(b2)
{
  float4 MaxEffectOutput : packoffset(c0);
  float MaxEffectColorBrightness : packoffset(c1);
  float hdrEncodeMulti : packoffset(c1.y);
  float hdrEncodeMulti_Effect : packoffset(c1.z);
  float gammaConst : packoffset(c1.w);
}

SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s0);
Texture2D<float4> texHDR : register(t0);
Texture2D<float4> texDof : register(t1);
Texture2D<float4> texFocus : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = texHDR.Sample(PA_LINEAR_CLAMP_FILTER_s, v1.xy).xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = gammaConst * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xy = texFocus.Sample(PA_LINEAR_CLAMP_FILTER_s, v1.xy).zw;
  r0.w = dot(gain, maxblur);
  r1.x = maxblur * r1.x;
  r1.z = cmp(0 < r1.x);
  if (r1.z != 0) {
    r2.xyz = float3(0.75,0.349999994,4) * r1.xxx;
    r1.zw = vecInvScreenSize.xy * r1.xx;
    r1.zw = float2(6,6) * r1.zw;
    r2.yz = max(float2(0.25,1), r2.yz);
    r2.z = min(6, r2.z);
    r2.w = (int)r2.z;
    r2.z = trunc(r2.z);
    r3.xyzw = float4(0,0,0,0);
    r4.x = 1;
    while (true) {
      r4.y = cmp((int)r2.w < (int)r4.x);
      if (r4.y != 0) break;
      r4.y = (int)r4.x * 3;
      r4.z = (int)r4.x;
      r4.z = r4.z / r2.z;
      r5.xy = r4.zz * r1.zw;
      r4.w = (int)r4.y;
      r4.w = 6.28318024 / r4.w;
      r4.z = -1 + r4.z;
      r4.z = r4.z * 0.5 + 1;
      r6.xyz = r3.xyz;
      r5.z = r3.w;
      r5.w = 0;
      while (true) {
        r6.w = cmp((int)r5.w >= (int)r4.y);
        if (r6.w != 0) break;
        r6.w = (int)r5.w;
        r6.w = r6.w * r4.w;
        sincos(r6.w, r7.x, r8.x);
        r8.x = r8.x * r5.x;
        r8.y = r7.x * r5.y;
        r7.xy = v1.xy + r8.xy;
        r7.xyzw = texDof.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r7.xy, r2.y).wxyz;
        r7.yzw = r7.yzw * r7.yzw;
        r6.w = dot(r7.yzw, float3(0.298999995,0.587000012,0.114));
        r6.w = saturate(-threshold + r6.w);
        r6.w = r6.w * r0.w;
        r6.w = r6.w * r1.x;
        r7.yzw = r7.yzw * r6.www + r7.yzw;
        r7.x = saturate(r7.x);
        r6.w = r7.x * r4.z;
        r6.xyz = r7.yzw * r6.www + r6.xyz;
        r5.z = r4.z * r7.x + r5.z;
        r5.w = (int)r5.w + 1;
      }
      r3.xyz = r6.xyz;
      r3.w = r5.z;
      r4.x = (int)r4.x + 1;
    }
    r1.xzw = max(0, r3.xyz / r3.www);
    r2.x = saturate(r2.x);
    r2.x = log2(r2.x);
    r2.x = 0.349999994 * r2.x;
    r2.x = exp2(r2.x);
    r2.y = r2.x * -2 + 3;
    r2.x = r2.x * r2.x;
    r2.x = r2.y * r2.x;
    r1.xzw = r1.xzw + -r0.xyz;
    r0.xyz = r2.xxx * r1.xzw + r0.xyz;
  }
  r1.x = maxblur + maxblur;
  r1.x = min(2, r1.x);
  r1.x = r1.x * r1.y;
  r1.y = cmp(0.00100000005 < r1.x);
  if (r1.y != 0) {
    r1.yz = float2(0.349999994,4) * r1.xx;
    r2.xy = vecInvScreenSize.xy * r1.xx;
    r2.xy = float2(10,10) * r2.xy;
    r1.yz = max(float2(0.75,3), r1.yz);
    r1.z = min(10, r1.z);
    r1.w = (int)r1.z;
    r1.z = trunc(r1.z);
    r2.zw = float2(0,0);
    r3.xyzw = float4(0,0,0,1);
    while (true) {
      r4.x = cmp((int)r1.w < (int)r3.w);
      if (r4.x != 0) break;
      r4.x = (int)r3.w * 3;
      r4.y = (int)r3.w;
      r4.y = r4.y / r1.z;
      r4.zw = r4.yy * r2.xy;
      r5.x = (int)r4.x;
      r5.x = 6.28318024 / r5.x;
      r5.yzw = r3.xyz;
      r6.xy = r2.zw;
      r6.z = 0;
      while (true) {
        r6.w = cmp((int)r6.z >= (int)r4.x);
        if (r6.w != 0) break;
        r6.w = (int)r6.z;
        r6.w = r6.w * r5.x;
        sincos(r6.w, r7.x, r8.x);
        r8.x = r8.x * r4.z;
        r8.y = r7.x * r4.w;
        r7.xy = v1.xy + r8.xy;
        r8.xyz = texDof.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r7.xy, r1.y).xyz;
        r8.xyz = r8.xyz * r8.xyz;
        r6.w = dot(r8.xyz, float3(0.298999995,0.587000012,0.114));
        r6.w = saturate(-threshold + r6.w);
        r6.w = r6.w * r0.w;
        r6.w = r6.w * r1.x;
        r8.xyz = r8.xyz * r6.www + r8.xyz;
        r6.w = texFocus.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r7.xy, 0).y;
        r7.x = r6.w * r4.y;
        r5.yzw = r8.xyz * r7.xxx + r5.yzw;
        r6.x = r4.y * r6.w + r6.x;
        r6.yz = (int2)r6.yz + int2(1,1);
      }
      r3.xyz = r5.yzw;
      r2.zw = r6.xy;
      r3.w = (int)r3.w + 1;
    }
    r0.w = (int)r2.w;
    r0.w = r2.z / r0.w;
    r0.w = 1.5 * r0.w;
    r0.w = log2(r0.w);
    r0.w = 0.300000012 * r0.w;
    r0.w = exp2(r0.w);
    r0.w = min(1, r0.w);
    r1.x = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.w = r1.x * r0.w;
    r1.x = cmp(0 < r0.w);
    r1.yzw = max(0, r3.xyz / r2.zzz);
    r1.yzw = r1.yzw + -r0.xyz;
    r1.yzw = r0.www * r1.yzw + r0.xyz;
    r0.xyz = r1.xxx ? r1.yzw : r0.xyz;
  }
  r0.w = 1 / gammaConst;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.www * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 1;
  return;
}