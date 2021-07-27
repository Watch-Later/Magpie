// Anime4K-v3.1-ThinLines-Kernel(X)
// 移植自 https://github.com/bloc97/Anime4K/blob/master/glsl/Experimental-Effects/Anime4K_ThinLines_HQ.glsl



cbuffer constants : register(b0) {
	int2 srcSize : packoffset(c0);
};


#define MAGPIE_INPUT_COUNT 1
#include "common.hlsli"


D2D_PS_ENTRY(main) {
	InitMagpieSampleInput();

	//[tl  t tr]
	//[ l  c  r]
	//[bl  b br]
	float l = uncompressLinear(SampleInputOffChecked(0, float2(-1, 0)).x, 0, 3);
	float c = uncompressLinear(SampleInputCur(0).x, 0, 3);
	float r = uncompressLinear(SampleInputOffChecked(0, float2(1, 0)).x, 0, 3);


	//Horizontal Gradient
	//[-1  0  1]
	//[-2  0  2]
	//[-1  0  1]
	float xgrad = (-l + r);

	//Vertical Gradient
	//[-1 -2 -1]
	//[ 0  0  0]
	//[ 1  2  1]
	float ygrad = (l + c + c + r);

	//Computes the luminance's gradient
	return float4(compressLinear(xgrad, -3, 3), compressLinear(ygrad, 0, 10), 0, 1);
}
