
varying vec2 vUvs;

uniform sampler2D diffuse;

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

vec4 noise(vec2 coords) {
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
  return vec4(result);
}

vec4 filteredSample(sampler2D target, vec2 coords) {
  vec2 texSize = vec2(2.0);
  vec2 pc = coords * texSize - 0.5;
  vec2 base = floor(pc) + 0.5;

  vec4 s1 = texture2D(target, (base + vec2(0.0, 0.0)) / texSize);
  vec4 s2 = texture2D(target, (base + vec2(1.0, 0.0)) / texSize);
  vec4 s3 = texture2D(target, (base + vec2(0.0, 1.0)) / texSize);
  vec4 s4 = texture2D(target, (base + vec2(1.0, 1.0)) / texSize);

  vec2 f = smoothstep(0.0, 1.0, fract(pc));

  vec4 px1 = mix(s1, s2, f.x);
  vec4 px2 = mix(s3, s4, f.x);
  vec4 result = mix(px1, px2, f.y);
  return result;
}

void main(void) {
  vec4 colour = noise(vUvs * 20.0);

  gl_FragColor = colour;
}