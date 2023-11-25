
varying vec2 vUvs;
uniform vec2 resolution;
uniform float time;

vec3 YELLOW = vec3(1.0, 1.0, 0.5);
vec3 BLUE = vec3(0.25, 0.25, 1.0);
vec3 RED = vec3(1.0, 0.25, 0.25);
vec3 GREEN = vec3(0.25, 1.0, 0.25);
vec3 PURPLE = vec3(1.0, 0.25, 1.0);

// The MIT License
// Copyright © 2013 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org/
//
// https://www.shadertoy.com/view/lsf3WH
// SimonDev: Renamed function to "Math_Random" from "hash"
float Math_Random(vec2 p)  // replace this by something better
{
  p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
  return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
}

float noise(vec2 coords) {
  vec2 texSize = vec2(1.0);
  vec2 pc = coords * texSize;
  vec2 base = floor(pc);

  float s1 = Math_Random((base + vec2(0.0, 0.0)) / texSize);
  float s2 = Math_Random((base + vec2(1.0, 0.0)) / texSize);
  float s3 = Math_Random((base + vec2(0.0, 1.0)) / texSize);
  float s4 = Math_Random((base + vec2(1.0, 1.0)) / texSize);

  vec2 f = smoothstep(0.0, 1.0, fract(pc));

  float px1 = mix(s1, s2, f.x);
  float px2 = mix(s3, s4, f.x);
  float result = mix(px1, px2, f.y);
  return result;
}

float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

float sdfLine(vec2 p, vec2 a, vec2 b) {
  vec2 pa = p - a;
  vec2 ba = b - a;
  float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);

  return length(pa - ba * h);
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

float evaluateFunction(float x) {
  float y = 0.0;

  float amplitude = 128.0;
  float frequency = 1.0 / 64.0;

  y += noise(vec2(x) * frequency) * amplitude;
  y += noise(vec2(x) * frequency * 2.0) * amplitude * 0.5;
  y += noise(vec2(x) * frequency * 4.0) * amplitude * 0.25;

  return y;
}

float plotFunction(vec2 p, float px, float curTime) {
  float result = 100000.0;
  
  for (float i = -5.0; i < 5.0; i += 1.0) {
    vec2 c1 = p + vec2(px * i, 0.0);
    vec2 c2 = p + vec2(px * (i + 1.0), 0.0);

    vec2 a = vec2(c1.x, evaluateFunction(c1.x + curTime));
    vec2 b = vec2(c2.x, evaluateFunction(c2.x + curTime));
    result = min(result, sdfLine(p, a, b));
  }

  return result;
}

void main() {
  vec2 pixelCoords = (vUvs - 0.5) * resolution;

  vec3 colour = BackgroundColour();
  colour = drawGrid(colour, vec3(0.5), 10.0, 1.0);
  colour = drawGrid(colour, vec3(0.0), 100.0, 2.0);

  // Draw a horizontal blue line down at 0
  colour = mix(vec3(0.25, 0.25, 1.0), colour, smoothstep(2.0, 3.0, abs(pixelCoords.y)));

  // Draw graph of our function
  float distToFunction = plotFunction(pixelCoords, 2.0, time * 96.0);
  vec3 lineColour = RED * mix(1.0, 0.25, smoothstep(0.0, 3.0, distToFunction));
  float lineBorder = smoothstep(4.0, 6.0, distToFunction);

  colour = mix(lineColour, colour, lineBorder);

  gl_FragColor = vec4(colour, 1.0);
}