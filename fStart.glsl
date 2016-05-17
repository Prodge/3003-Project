vec4 color;

varying vec4 position;
varying vec3 normal;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform float Shininess;
uniform vec4 Light1Position;
uniform vec4 Light2Position;
uniform vec3 Light1RgbBrightness;
uniform vec3 Light2RgbBrightness;

void main()
{
    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * position).xyz;

    // The vector to the light from the vertex
    vec3 L1vec = Light1Position.xyz - pos;
    vec3 L2vec = Light2Position.xyz;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L1 = normalize( L1vec );   // Direction to the light source
    vec3 L2 = normalize( L2vec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H1 = normalize( L1 + E );  // Halfway vector
    vec3 H2 = normalize( L2 + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient1 = Light1RgbBrightness * AmbientProduct;
    vec3 ambient2 = Light2RgbBrightness * AmbientProduct;

    float Kd1 = max( dot(L1, N), 0.0 );
    vec3  diffuse1 = Light1RgbBrightness * Kd1 * DiffuseProduct;
    float Kd2 = max( dot(L2, N), 0.0 );
    vec3  diffuse2 = Light2RgbBrightness * Kd2 * DiffuseProduct;

    float Ks1 = pow( max(dot(N, H1), 0.0), Shininess );
    vec3  specular1 = Light1RgbBrightness * Ks1 * SpecularProduct;
    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );
    vec3  specular2 = Light2RgbBrightness * Ks2 * SpecularProduct;

    if (dot(L1, N) < 0.0 ) {
        specular1 = vec3(0.0, 0.0, 0.0);
    }
    if (dot(L2, N) < 0.0 ) {
        specular2 = vec3(0.0, 0.0, 0.0);
    }

    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    float dropoff = sqrt(dot(L1vec, L1vec))/15.0 + 1.0; 
    color.rgb = ((ambient1 + diffuse1) / dropoff) + globalAmbient + ambient2 + diffuse2;
    color.a = 1.0;
    gl_FragColor = (color * texture2D( texture, texCoord * 2.0 )) + vec4(specular1/dropoff + specular2,1.0);

    /**
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
    color.rgb = globalAmbient + (ambient + ambient2 + diffuse + diffuse2 + specular + specular2) * lightDistanceMultiplier;
    color.a = 1.0;
    gl_FragColor = color * texture2D( texture, texCoord * 2.0 );
    **/

}
