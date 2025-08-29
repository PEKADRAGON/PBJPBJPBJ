#include "mta-helper.fx"

float intensity = 1;
float rate = 0;
float opacity = 1;
float3 color = float3(0,0,0);

float inten = 0.05;

struct vsin
{
  float4 Position : POSITION;
  float2 TexCoord : TEXCOORD0;
};
 
struct vsout
{
  float4 Position : POSITION;
  float2 TexCoord : TEXCOORD0;
};
 
vsout vs(vsin input)
{
  vsout output;
  output.Position = mul(input.Position,gWorldViewProjection);
  output.TexCoord = 1 - input.TexCoord.yx;
  return output;
}
 
 
float4 ps(vsout input) : COLOR0
{
  float2 p = input.TexCoord*10.0 - 19;
  float2 i = p;
  float c = 1.0;
  float time = gTime + gTime*(rate-1.0);
  for (int n = 0; n < 11; n++) {
    float t = time * (1 - (3 / (n+1)));
    i = p + float2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
    c += 1.0/length(float2(p.x / (2.*sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
  }
  c /= 11;
  c = 1.5-sqrt(pow(abs(c),3.5));
  return float4(color*pow(c,4),pow(intensity*2,2)/2*opacity);
}
 
technique tec
{
  pass Pass0
  {
    DepthBias=-0.0002;
    NormalizeNormals = false;
    VertexShader = compile vs_3_0 vs();
    PixelShader = compile ps_3_0 ps();
  }
}