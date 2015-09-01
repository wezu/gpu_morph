//GLSL
#version 330

uniform sampler2D p3d_Texture0; //color
uniform sampler2D p3d_Texture1; //normal

uniform gl_LightSourceParameters Light; //light

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
