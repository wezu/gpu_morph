//GLSL
#version 330

in vec4 index;
in vec4 p3d_Vertex;
in vec2 p3d_MultiTexCoord0;

in vec4 transform_weight;
in uvec4 transform_index;

uniform mat4 p3d_TransformTable[100];

in vec3 p3d_Normal;
in vec3 p3d_Tangent;
in vec3 p3d_Binormal;

uniform samplerBuffer morph1;
uniform samplerBuffer morph2;
uniform samplerBuffer morph3;
uniform float weight1;
uniform float weight2;
uniform float weight3;
uniform mat4 p3d_ModelViewProjectionMatrix;

out vec2 uv;
out vec3 normal;
out vec3 tangent;
out vec3 binormal;

void main()
    { 
    //morphs    
    int nIndex=    int(index.x);
    vec4 offset= texelFetch(morph1,nIndex)*weight1;
    offset+= texelFetch(morph2,nIndex)*weight2;   
    offset+= texelFetch(morph3,nIndex)*weight3;
    offset.w=0.0;
    vec4 vert=p3d_Vertex -offset;
    //hardware skinning
    mat4 matrix = p3d_TransformTable[transform_index.x] * transform_weight.x
              + p3d_TransformTable[transform_index.y] * transform_weight.y
              + p3d_TransformTable[transform_index.z] * transform_weight.z
              + p3d_TransformTable[transform_index.w] * transform_weight.w;
    
    gl_Position = p3d_ModelViewProjectionMatrix * matrix * vert;
    
    uv=p3d_MultiTexCoord0.xy;
    normal = gl_NormalMatrix * gl_Normal; 
    tangent = gl_NormalMatrix * p3d_Tangent; 
    binormal = gl_NormalMatrix* -p3d_Binormal;
    }    

