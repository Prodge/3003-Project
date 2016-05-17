attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec4 position;
varying vec3 normal;
varying vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    position = vpos;
    normal = vNormal;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
