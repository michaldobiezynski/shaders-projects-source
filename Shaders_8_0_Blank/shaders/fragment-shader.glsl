
varying vec2 vUvs;
uniform vec2 resolution;
uniform float time;


float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

void main() {
  vec2 pixelCoords = (vUvs - 0.5) * resolution;
  
  vec3 colour = vec3(0.0);

  gl_FragColor = vec4(colour, 1.0);
}