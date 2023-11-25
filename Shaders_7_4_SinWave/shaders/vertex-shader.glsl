
varying vec3 vNormal;
varying vec3 vPosition;
varying vec3 vColour;

uniform float time;


float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}


void main() {	
  vec3 localSpacePosition = position;

  float t = sin(localSpacePosition.y * 20.0 + time * 10.0);
  t = remap(t, -1.0, 1.0, 0.0, 0.2);
  localSpacePosition += normal * t;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(localSpacePosition, 1.0);
  vNormal = (modelMatrix * vec4(normal, 0.0)).xyz;
  vPosition = (modelMatrix * vec4(localSpacePosition, 1.0)).xyz;
  vColour = mix(
      vec3(0.0, 0.0, 0.5),
      vec3(0.1, 0.5, 0.8),
      smoothstep(0.0, 0.2, t));
}