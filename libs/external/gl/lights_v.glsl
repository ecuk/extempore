// start file

#version 330

layout (location = 0) in vec4 xtmVertex;
layout (location = 1) in vec3 xtmNormal;
layout (location = 2) in vec3 xtmUVW;
layout (location = 3) in vec4 xtmColour;
layout (location = 4) in mat4 xtmIMat;       // instance matrix
layout (location = 8) in vec4 xtmIColour;    // instance colour

out vec3 N, E, V;
out vec3 L[5];
out float D[5];

uniform vec4 LightPos[5];
uniform vec4 CameraPos;

uniform mat4 ModelMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;
uniform mat3 NormalMatrix;
uniform mat4 ModelViewMatrix;
uniform mat4 ModelViewProjectionMatrix;

uniform mat4 LightModelViewProjectionMatrix[5];

uniform int numLights;
uniform int instances;

out vec4 lightVertexPosition[5];
out vec3 UVWCoord;
out vec4 vColour;

void main()
{
  vec4 vPosition;
  vec4 vpos;
  int k;

  if (instances > 0) {
    vpos = xtmIMat * xtmVertex;
  } else {
    vpos = xtmVertex;
  }

  gl_Position = ModelViewProjectionMatrix * vpos;
  vPosition = ModelViewMatrix * vpos;

  N = NormalMatrix * xtmNormal;
  float j = 0.5;
  
  for (k = 0; k < numLights; k++) {
    L[k] = (LightPos[k] - (ModelMatrix * vpos)).xyz; // vector from source to light
    if(LightPos[k].w == 0.0) L[k] = LightPos[k].xyz; // i.e. if LightPos is already a direction vector
    D[k] = length(L[k]);
    lightVertexPosition[k] = LightModelViewProjectionMatrix[k] * vpos;
  }
  
  V = vPosition.xyz; // vertex (3d)
  E = (CameraPos - vPosition).xyz; // vector from source to eye
  UVWCoord = xtmUVW;
  if (instances > 0) {
    vColour = xtmIColour;
  } else {
    vColour = vec4(1.0); //xtmColour;
  }
}

// end file