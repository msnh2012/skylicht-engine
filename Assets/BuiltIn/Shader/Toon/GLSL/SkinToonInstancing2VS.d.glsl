layout(location = 0) in vec4 inPosition;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec4 inColor;
layout(location = 3) in vec2 inTexCoord0;
layout(location = 4) in vec3 inTangent;
layout(location = 5) in vec3 inBinormal;
layout(location = 6) in vec2 inData;
layout(location = 7) in vec4 inBlendIndex;
layout(location = 8) in vec4 inBlendWeight;

layout(location = 9) in vec4 uBoneLocation;
layout(location = 10) in vec4 uColor;
layout(location = 11) in vec2 uBlendAnimation;

layout(location = 12) in mat4 uWorldMatrix;

uniform sampler2D uTransformTexture;

uniform mat4 uVpMatrix;
uniform vec4 uCameraPosition;
uniform vec2 uBoneCount;
uniform vec2 uTransformTextureSize;

out vec2 vTexCoord0;
out vec3 vWorldNormal;
out vec3 vWorldViewDir;
out vec3 vWorldPosition;
out vec3 vDepth;
out vec4 vColor;

#include "../../TransformTexture/GLSL/LibTransformTexture.glsl"

void main(void)
{
	mat4 skinMatrix = mat4(0.0);
	
	// ANIMATION 1
	vec2 boneLocation = uBoneLocation.xy;
	float boneLocationY = uBoneLocation.y * uBoneCount.x;

	boneLocation.y = boneLocationY + inBlendIndex[0];
	skinMatrix = inBlendWeight[0] * getTransformFromTexture(boneLocation);

	boneLocation.y = boneLocationY + inBlendIndex[1];
	skinMatrix += inBlendWeight[1] * getTransformFromTexture(boneLocation);

	boneLocation.y = boneLocationY + inBlendIndex[2];
	skinMatrix += inBlendWeight[2] * getTransformFromTexture(boneLocation);

	boneLocation.y = boneLocationY + inBlendIndex[3];
	skinMatrix += inBlendWeight[3] * getTransformFromTexture(boneLocation);

	vec4 skinPosition1 = skinMatrix * inPosition;
	vec3 skinNormal1 = (skinMatrix * vec4(inNormal, 0.0)).xyz;
	
	// ANIMATION 2
	boneLocation = uBoneLocation.zw;
	boneLocationY = uBoneLocation.w * uBoneCount.x;

	boneLocation.y = boneLocationY + inBlendIndex[0];
	skinMatrix = inBlendWeight[0] * getTransformFromTexture(boneLocation);

	boneLocation.y = boneLocationY + inBlendIndex[1];
	skinMatrix += inBlendWeight[1] * getTransformFromTexture(boneLocation);

	boneLocation.y = boneLocationY + inBlendIndex[2];
	skinMatrix += inBlendWeight[2] * getTransformFromTexture(boneLocation);

	boneLocation.y = boneLocationY + inBlendIndex[3];
	skinMatrix += inBlendWeight[3] * getTransformFromTexture(boneLocation);

	vec4 skinPosition2 = skinMatrix * inPosition;
	vec3 skinNormal2 = (skinMatrix * vec4(inNormal, 0.0)).xyz;
	
	// blend animations
	vec4 skinPosition = mix(skinPosition1, skinPosition2, uBlendAnimation.x);
	vec3 skinNormal = mix(skinNormal1, skinNormal2, uBlendAnimation.x);
	
	vTexCoord0 = inTexCoord0;
	
	vec4 worldPos = uWorldMatrix * skinPosition;
	vec4 worldNormal = uWorldMatrix * vec4(skinNormal, 0.0);
	
	vWorldPosition = worldPos.xyz;
	vDepth = uCameraPosition.xyz - vWorldPosition;
	
	vWorldNormal = normalize(worldNormal.xyz);
	vWorldViewDir = normalize(vDepth);
	
	vColor = uColor * inColor / 255.0;
	
	gl_Position = uVpMatrix * worldPos;
}