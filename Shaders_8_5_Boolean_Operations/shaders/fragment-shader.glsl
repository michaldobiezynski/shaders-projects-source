
varying vec2 vUvs;
uniform vec2 resolution;
uniform float time;

vec3 YELLOW = vec3(1.0, 1.0, 0.5);
vec3 BLUE = vec3(0.25, 0.25, 1.0);
vec3 RED = vec3(1.0, 0.25, 0.25);
vec3 GREEN = vec3(0.25, 1.0, 0.25);
vec3 PURPLE = vec3(1.0, 0.25, 1.0);

float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

vec3 BackgroundColour() {
  float distFromCenter = length(abs(vUvs - 0.5));

  float vignette = 1.0 - distFromCenter;
  vignette = smoothstep(0.0, 0.7, vignette);
  vignette = remap(vignette, 0.0, 1.0, 0.3, 1.0);

  return vec3(vignette);
}

vec3 drawGrid(
  vec3 colour, vec3 lineColour, float cellSpacing, float lineWidth) {
  vec2 center = vUvs - 0.5;
  vec2 cells = abs(fract(center * resolution / cellSpacing) - 0.5);
  float distToEdge = (0.5 - max(cells.x, cells.y)) * cellSpacing;
  float lines = smoothstep(0.0, lineWidth, distToEdge);

  colour = mix(lineColour, colour, lines);

  return colour;
}

float sdfCircle(vec2 p, float r) {
  return length(p) - r;
}

float sdfLine(vec2 p, vec2 a, vec2 b) {
  vec2 pa = p - a;
  vec2 ba = b - a;
  float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);

  return length(pa - ba * h);
}

float sdfBox(vec2 p, vec2 b) {
  vec2 d = abs(p) - b;
  return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Inigo Quilez
// https://iquilezles.org/articles/distfunctions2d/
float sdfHexagon( in vec2 p, in float r ) {
  const vec3 k = vec3(-0.866025404, 0.5, 0.577350269);
  p = abs(p);
  p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
  p -= vec2(clamp(p.x, -k.z*r, k.z*r), r);
  return length(p)*sign(p.y);
}

float opUnion(float d1, float d2) {
  return min(d1, d2);
}

float opSubtraction(float d1, float d2) {
  return max(-d1, d2);
}

float opIntersection(float d1, float d2) {
  return max(d1, d2);
}

mat2 rotate2D(float angle) {
  float s = sin(angle);
  float c = cos(angle);
  return mat2(c, -s, s, c);
}

float softMax(float a, float b, float k) {
  return log(exp(k * a) + exp(k * b)) / k;
}

float softMin(float a, float b, float k) {
  return -softMax(-a, -b, k);
}

float softMinValue(float a, float b, float k) {
  float h = exp(-b * k) / (exp(-a * k) + exp(-b * k));
  // float h = remap(a - b, -1.0 / k, 1.0 / k, 0.0, 1.0);
  return h;
}

void main() {
  vec2 pixelCoords = (vUvs - 0.5) * resolution;
  
  vec3 colour = BackgroundColour();
  colour = drawGrid(colour, vec3(0.5), 10.0, 1.0);
  colour = drawGrid(colour, vec3(0.0), 100.0, 2.0);

  // float d = sdfCircle(pixelCoords, 300.0);
  float box = sdfBox(rotate2D(time * 0.5) * pixelCoords, vec2(200.0, 100.0));
  float d1 = sdfCircle(pixelCoords - vec2(-300.0, -150.0), 150.0);
  float d2 = sdfCircle(pixelCoords - vec2(300.0, -150.0), 150.0);
  float d3 = sdfCircle(pixelCoords - vec2(0.0, 200.0), 150.0);
  float d = opUnion(opUnion(d1, d2), d3);

  vec3 sdfColour = mix(
      RED, BLUE, smoothstep(0.0, 1.0, softMinValue(box, d, 0.01)));

  d = softMin(box, d, 0.05);
  colour = mix(sdfColour * 0.5, colour, smoothstep(-1.0, 1.0, d));
  colour = mix(sdfColour, colour, smoothstep(-5.0, 0.0, d));

  gl_FragColor = vec4(colour, 1.0);
}