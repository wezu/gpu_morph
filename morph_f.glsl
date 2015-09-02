//GLSL
#version 330

struct p3d_LightSourceParameters {
  // Ambient is always vec4(0, 0, 0, 1)
  vec4 ambient;
  // light.get_color()
  vec4 diffuse;
  // light.get_specular_color()
  vec4 specular;
  // In case of Spotlight/PointLight, this is the light position in view space, with fourth component 1
  // In case of DirectionalLight, this is actually (-dir) with the fourth component set to 0
  vec4 position;
  // This is the only one that's not actually available
  vec4 halfVector;
  // Etc blah blah same as OpenGL FFP equivalents
  // You can just omit their declaration if you don't need them, they are bound by name
  vec3 spotDirection;
  float spotExponent;
  float spotCutoff;
  float spotCosCutoff;
  float constantAttenuation;
  float linearAttenuation;
  float quadraticAttenuation;
};

uniform sampler2D p3d_Texture0; //color
uniform sampler2D p3d_Texture1; //normal

uniform p3d_LightSourceParameters Light; //light

in vec2 uv;
in vec3 normal;
in vec3 tangent;
in vec3 binormal;

void main()
    {     
    vec4 color_map =texture(p3d_Texture0, uv);
    vec4 normal_map=texture(p3d_Texture1, uv);
    //get the normal from the map
    normal_map.xyz=(normal_map.xyz*2.0)-1.0;
    vec3 N=normal;
    N *= normal_map.z;
    N += tangent * normal_map.x;
    N += binormal * normal_map.y;    
    N = normalize(N);
    //do some light
    vec3 L;
    float NdotL;
    vec4 color=vec4( 0.1, 0.1, 0.1, 1.0);
    L = normalize(Light.position.xyz);     
    NdotL = max(dot(N,L),0.0);
    if (NdotL > 0.0)
        {       
       color += Light.diffuse * NdotL;          
       }      
    gl_FragColor=vec4(color_map.rgb * color.rgb, color_map.a);
    }
