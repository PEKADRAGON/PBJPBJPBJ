#include "mta-helper.fx"

float intensity = 1;
float rate = 0;
float opacity = 1;
float3 color = float3(0,0,0);

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


float2 hash( float2 p )
{
     float2x2 m = float2x2( 15.32, 83.43, 117.38, 289.59 );
     return frac( sin( mul(m,p)) * 46783.289 );
}
 
float voronoi( float2 p )
{
     float2 g = floor( p );
     float2 f = frac( p );
    
     float distanceFromPointToCloestFeaturePoint = 1.0;
     [unroll(4)] for( int y = 0; y < 1; y++ )
     {
       [unroll(4)]for( int x = 0; x < 1; x++ )
          {
               float2 latticePoint = float2( x, y );
               float h = distance( latticePoint + hash( g + latticePoint), f );
          
        distanceFromPointToCloestFeaturePoint = min( distanceFromPointToCloestFeaturePoint, h ); 
          }
     }
     return 1.0 - sin(distanceFromPointToCloestFeaturePoint);
}
 
float tex(float2 uv)
{
float time = gTime + gTime*(rate-1.0);
    float t = voronoi( uv * 8.0 + float2(time,time)*2 );
        t *= 1.0-length(uv * 2.0);
    return t;
}
 
float fbm( float2 uv )
{
    float sum = 0.00;
    float amp = 1.0;
    for( int i = 0; i < 4; ++i )
    {
      sum += tex( uv ) * amp;
        uv += uv;
        amp *= 0.8;
    }
    
    return sum;
}

float4 ps(vsout input) : COLOR0
{
  float2 uv = ( input.TexCoord ) * 2.0 - 1.0;
  float t = pow( fbm( uv * 0.3 ), 2.0);
  return float4( color, t * pow(intensity*2,2) * opacity );
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