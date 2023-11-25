
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

vec3 drawGrid(vec3 colour, vec3 lineColour, float cellSpacing, float lineWidth) {
  vec2 center = vUvs - 0.5;
  vec2 cellPosition = abs(fract(center * resolution / vec2(cellSpacing)) - 0.5);
  float distToEdge = (0.5 - max(cellPosition.x, cellPosition.y)) * cellSpacing;
  float lines = smoothstep(0.0, lineWidth, distToEdge);

  colour = mix(lineColour, colour, lines);

  return colour;
}

vec3 BackgroundColour() {
  float distFromCenter = length(abs(vUvs - 0.5));

  float vignette = 1.0 - distFromCenter;
  vignette = smoothstep(0.0, 0.7, vignette);
  vignette = remap(vignette, 0.0, 1.0, 0.3, 1.0);

  return vec3(vignette);
}

void main() {
  vec2 pixelCoords = (vUvs - 0.5) * resolution;

  vec3 colour = BackgroundColour();
  colour = drawGrid(colour, vec3(0.5), 10.0, 1.0);
  colour = drawGrid(colour, vec3(0.0), 100.0, 2.0);

  gl_FragColor = vec4(colour, 1.0);
}