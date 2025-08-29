texture sBaseTexture;

sampler Samp = sampler_state
{
	Texture = (sBaseTexture);
	AddressU = MIRROR; 
	AddressV = MIRROR; 
};

float blurValue = 0;
float r = 0.2;
float g = 0.075;
float b = 0;

float4 PixelShaderFunction(float2 uv : TEXCOORD) : COLOR
{
	float4 outputColor = tex2D(Samp, uv);

	float2 dist = (uv - 0.5) * 2.0;

	float2 blur = 0.005*pow(dist, 3);

	for (float i = 1; i < 3; i++) { 
		outputColor += tex2D(Samp, float2(uv.x, uv.y + (i * blur.y * blurValue))); 
		outputColor += tex2D(Samp, float2(uv.x, uv.y - (i * blur.y * blurValue))); 
		outputColor += tex2D(Samp, float2(uv.x - (i * blur.x * blurValue), uv.y)); 
		outputColor += tex2D(Samp, float2(uv.x + (i * blur.x * blurValue), uv.y)); 
	} 

	outputColor /= 9;

	outputColor.r *= 1 - r*blurValue; 
	outputColor.g *= 1 - g*blurValue; 
	outputColor.b *= 1 - b*blurValue;

	outputColor.rgb = (outputColor.rgb - 0.5) * (blurValue*0.075 + 1.0) + 0.5; 


	return outputColor;
}

technique movie
{
	pass P1
	{
		PixelShader = compile ps_2_a PixelShaderFunction();
	}
}

// Fallback
technique fallback
{
	pass P0
	{
		// Just draw normally
	}
}
