vec4 color;
varying vec4 position;
varying vec3 normal;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;

void main()
{
    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * position).xyz;

    // The vector to the light from the vertex
    vec3 Lvec = LightPosition.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;

    if (dot(L, N) < 0.0 ) {
        specular = vec3(0.0, 0.0, 0.0);
    }

    // lightDistanceMultiplier gets closer to maxLightDistanceMultiplier as the light gets closer
    // lightDistanceMultiplier gets smaller as the light gets further away (averageDistanceToLight increases)
    // Falloff changes the rate at which this occurs by modifying the averageDistanceToLight by a constant factor
    float falloff = 10.0;
    float minDistance = 0.5;
    float averageDistanceToLight = abs(Lvec.x) + abs(Lvec.y) + abs(Lvec.z) + minDistance;
    float maxLightDistanceMultiplier = 0.8;
    float lightDistanceMultiplier = maxLightDistanceMultiplier/(averageDistanceToLight/falloff);

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    color.rgb = globalAmbient + (ambient + diffuse + specular) * lightDistanceMultiplier;
    color.a = 1.0;
    gl_FragColor = color * texture2D( texture, texCoord * 2.0 );
}
