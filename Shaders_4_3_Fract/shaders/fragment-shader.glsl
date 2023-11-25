
varying vec2 vUvs;

uniform vec2 resolution;

vec3 red = vec3(1.0, 0.0, 0.0);
vec3 blue = vec3(0.0, 0.0, 1.0);
vec3 white = vec3(1.0, 1.0, 1.0);
vec3 black = vec3(0.0, 0.0, 0.0);
vec3 yellow = vec3(1.0, 1.0, 0.0);

void main() {
  vec3 colour = vec3(0.75);

  // grid
  vec2 center = vUvs - 0.5;
  vec2 cell = fract(center * resolution / 100.0);
  cell = abs(cell - 0.5);
  float distToCell = 1.0 - 2.0 * max(cell.x, cell.y);

  float cellLine = smoothstep(0.0, 0.05, distToCell);

  float xAxis = smoothstep(0.0, 0.002, abs(vUvs.y - 0.5));
  float yAxis = smoothstep(0.0, 0.002, abs(vUvs.x - 0.5));

  // Lines
  vec2 pos = center * resolution / 100.0;
  float value1 = pos.x;
  float value2 = mod(pos.x, 1.0);
  float functionLine1 = smoothstep(0.0, 0.075, abs(pos.y - value1));
  float functionLine2 = smoothstep(0.0, 0.075, abs(pos.y - value2));

  colour = mix(black, colour, cellLine);
  colour = mix(blue, colour, xAxis);
  colour = mix(blue, colour, yAxis);
  colour = mix(yellow, colour, functionLine1);
  colour = mix(red, colour, functionLine2);

  gl_FragColor = vec4(colour, 1.0);
}
