attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;
attribute ivec4 boneIDs;
attribute vec4 boneWeights;

varying vec4 position;
varying vec3 normal;
varying vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;
uniform mat4 boneTransforms[64];

void main()
{
    mat4 boneTransform = boneWeights[0] * boneTransforms[boneIDs[0]];
    boneTransform += boneWeights[1] * boneTransforms[boneIDs[1]];
    boneTransform += boneWeights[2] * boneTransforms[boneIDs[2]];
    boneTransform += boneWeights[3] * boneTransforms[boneIDs[3]];

    vec4 vpos = vec4(vPosition, 1.0) * boneTransform;
    gl_Position = Projection * ModelView * vpos;

    position = vpos;
    normal = mat3(boneTransform) * vNormal;
    texCoord = vTexCoord;
}
