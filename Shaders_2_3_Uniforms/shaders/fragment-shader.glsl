
varying vec2 vUvs;

uniform vec4 colour1;
uniform vec4 colour2;

void main() {
  gl_FragColor = mix(colour1, colour2, vUvs.x);
}