varying vec2 vUvs;

uniform sampler2D diffuse1;
uniform float time;

float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

void main() {
  vec3 colour = vec3(0.0);

  float t1 = sin(vUvs.x * 100.0);
  float t2 = sin(vUvs.y * 100.0);

  colour = vec3(t1 * t2);

  gl_FragColor = vec4(colour, 1.0);
}
