
varying vec2 vUvs;

void main() {
  vec3 colour = vec3(0.0);

  float value1 = vUvs.x;
  // float value2 = smoothstep(0.0, 1.0, vUvs.x);
  float value2 = clamp(vUvs.x, 0.25, 0.75);

  float line = smoothstep(0.0, 0.005, abs(vUvs.y - 0.5));
  float linearLine = smoothstep(0.0, 0.0075, abs(vUvs.y - mix(0.5, 1.0, value1)));
  float smoothLine = smoothstep(0.0, 0.0075, abs(vUvs.y - mix(0.0, 0.5, value2)));

  vec3 red = vec3(1.0, 0.0, 0.0);
  vec3 blue = vec3(0.0, 0.0, 1.0);
  vec3 white = vec3(1.0, 1.0, 1.0);

  if (vUvs.y > 0.5) {
    colour = mix(red, blue, value1);
  } else {
    colour = mix(red, blue, value2);
  }

  colour = mix(white, colour, line);
  colour = mix(white, colour, linearLine);
  colour = mix(white, colour, smoothLine);

  gl_FragColor = vec4(colour, 1.0);
}