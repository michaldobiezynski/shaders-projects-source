
varying vec2 vUvs;

uniform sampler2D diffuse;
uniform sampler2D overlay;
uniform vec4 tint;


void main(void) {
  vec2 uvs = vUvs * vec2(3.0, 2.0);

  vec4 diffuseSample = texture2D(diffuse, uvs);

  gl_FragColor = diffuseSample;
}