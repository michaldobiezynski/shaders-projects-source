
varying vec2 vUvs;

uniform sampler2D diffuse;
uniform sampler2D overlay;
uniform vec4 tint;


void main(void) {
  vec4 diffuseSample = texture2D(diffuse, vUvs);

  gl_FragColor = diffuseSample * tint;
}