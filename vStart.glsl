attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;
attribute vec4 boneIDs;
attribute vec4 boneWeights;

varying vec4 position;
varying vec3 normal;
varying vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;
uniform mat4 boneTransforms[64];

void main()
{
    ivec4 bones = ivec4(boneIDs);
    mat4 boneTransform = boneWeights[0] * boneTransforms[bones[0]] +
                         boneWeights[1] * boneTransforms[bones[1]] +
                         boneWeights[2] * boneTransforms[bones[2]] +
                         boneWeights[3] * boneTransforms[bones[3]];

    vec4 vpos = vec4(vPosition, 1.0) * boneTransform;
    vec3 normalTransform = vec3(boneTransform) * vNormal;

    gl_Position = Projection * ModelView * vpos;

    position = vpos;
    normal = normalTransform;
    texCoord = vTexCoord;
}
