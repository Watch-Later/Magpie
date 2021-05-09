// Anime4K-v3.1-ThinLines-Kernel(Y)
// ��ֲ�� https://github.com/bloc97/Anime4K/blob/master/glsl/Experimental-Effects/Anime4K_ThinLines_HQ.glsl



cbuffer constants : register(b0) {
	int2 srcSize : packoffset(c0);
};


#define MAGPIE_INPUT_COUNT 1
#include "Anime4K.hlsli"


#define KERNELSIZE (sigma * 2.0 + 1.0)

#define get(pos) (uncompressTan(SampleInputChecked(0, pos).x))


float gaussian(float x, float s) {
	float t = x / s;
	return exp(-0.5 * t * t) / s / 2.506628274631;
}

float lumGaussian(float2 pos, float2 d, float sigma) {
	float g = get(pos) / (sigma * 2.506628274631);
	g += (get(pos - d) + get(pos + d)) * gaussian(1.0, sigma);
	for (int i = 2; float(i) < KERNELSIZE; i++) {
		g += (get(pos - (d * float(i))) + get(pos + (d * float(i)))) * gaussian(float(i), sigma);
	}

	return g;
}


D2D_PS_ENTRY(main) {
	InitMagpieSampleInput();

	float sigma = (srcSize.y / 1080.0) * 2.0;
	float g = lumGaussian(Coord(0).xy, float2(0, Coord(0).w), sigma);
	return float4(compressTan(g), 0, 0, 1);
}