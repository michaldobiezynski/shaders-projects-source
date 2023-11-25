
uniform vec2 resolution;
varying vec2 vUvs;
uniform float time;

float sdfLine(vec2 p, vec2 a, vec2 b) {
  vec2 pa = p - a;
  vec2 ba = b - a;
  float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);

  return length(pa - ba * h);
}

float sdfCircle(vec2 p, float r) {
    return length(p) - r;
}

float sdRoundedBox( in vec2 p, in vec2 b, in vec4 r )
{
    r.xy = (p.x>0.0)?r.xy : r.zw;
    r.x  = (p.y>0.0)?r.x  : r.y;
    vec2 q = abs(p)-b+r.x;
    return min(max(q.x,q.y),0.0) + length(max(q,0.0)) - r.x;
}

vec3 DrawSlider(vec3 colour, vec2 pixelCoords, vec2 pos, float t) {
  float bgDistBlur = sdRoundedBox(pixelCoords - pos - vec2(10.0, -10.0), vec2(300.0, 120.0), vec4(20.0));
  float bgDist = sdRoundedBox(pixelCoords - pos, vec2(300.0, 120.0), vec4(20.0));
  vec3 bgColour = mix(vec3(0.1), vec3(0.05), smoothstep(-200.0, -1.0, bgDist));
  colour = mix(bgColour, colour, pow(smoothstep(0.0, 30.0, bgDistBlur), 0.25));
  colour = mix(bgColour, colour, smoothstep(-1.0, 0.0, bgDist));
  // colour = mix(box1Colour, colour, pow(smoothstep(0.0, 40.0, box1Dist), 0.25));

  vec2 sliderMin = (pos + vec2(-200.0, -75.0));
  vec2 sliderMax = (pos + vec2(200.0, -75.0));
  colour = mix(
    vec3(1.0), colour, smoothstep(
        2.0, 4.0, sdfLine(
            pixelCoords, sliderMin, sliderMax)));

  vec3 startColour = vec3(1.0, 0.6, 0.1);
  vec3 endColour = vec3(0.1, 0.6, 1.0);

  float box1Dist = sdRoundedBox(pixelCoords - (pos + vec2(-200.0, 50.0)), vec2(50.0), vec4(10.0));
  vec3 box1Colour = startColour;
  box1Colour = mix(box1Colour, box1Colour * 0.5, smoothstep(-4.0, -1.0, box1Dist));
  colour = mix(box1Colour, colour, smoothstep(-1.0, 1.0, box1Dist));
  // colour = mix(box1Colour, colour, pow(smoothstep(0.0, 40.0, box1Dist), 0.25));

  float box2Dist = sdRoundedBox(pixelCoords - (pos + vec2(200.0, 50.0)), vec2(50.0), vec4(10.0));
  vec3 box2Colour = endColour;
  box2Colour = mix(box2Colour, box2Colour * 0.5, smoothstep(-4.0, -1.0, box2Dist));
  colour = mix(box2Colour, colour, smoothstep(-1.0, 1.0, box2Dist));
  // colour = mix(box2Colour, colour, pow(smoothstep(0.0, 40.0, box2Dist), 0.25));

  vec3 sliderColour = mix(startColour, endColour, t);
  float box3Dist = sdRoundedBox(pixelCoords - (pos + vec2(0.0, 50.0)), vec2(50.0), vec4(10.0));
  vec3 box3Colour = sliderColour;
  box3Colour = mix(box3Colour, box3Colour * 0.5, smoothstep(-4.0, -1.0, box3Dist));
  colour = mix(box3Colour, colour, smoothstep(-1.0, 1.0, box3Dist));
  // colour = mix(box3Colour, colour, pow(smoothstep(0.0, 40.0, box3Dist), 0.25));

  float sliderBallDist = sdfCircle(pixelCoords - mix(sliderMin, sliderMax, t), 35.0);
  vec3 sliderBallColour = sliderColour;
  sliderBallColour = mix(sliderBallColour, sliderBallColour * 0.5, smoothstep(-6.0, -1.0, sliderBallDist));
  colour = mix(sliderBallColour, colour, smoothstep(-1.0, 1.0, sliderBallDist));

  return colour;
}

void main() {
  vec2 pixelCoords = (vUvs - 0.5) * resolution;

  vec3 colour = vec3(48.0 / 255.0);

  float t = clamp(fract(time * 0.2) * 3.0 - 1.0, 0.0, 1.0);
  colour = DrawSlider(colour, pixelCoords, vec2(0.0, 250.0), step(0.5, t));
  colour = DrawSlider(colour, pixelCoords, vec2(0.0, -50.0), t);
  colour = DrawSlider(colour, pixelCoords, vec2(0.0, -350.0), smoothstep(0.0, 1.0, t));


  // Top slider
  vec2 sliderMin = vec2(-800.0, 450.0);
  vec2 sliderMax = vec2(800.0, 450.0);
  colour = mix(
    vec3(1.0), colour, smoothstep(
        2.0, 4.0, sdfLine(
            pixelCoords, sliderMin, sliderMax)));

  float sliderBallDist = sdfCircle(pixelCoords - mix(sliderMin, sliderMax, fract(time * 0.2)), 35.0);
  vec3 sliderBallColour = vec3(0.25, 1.0, 0.25);
  sliderBallColour = mix(sliderBallColour, sliderBallColour * 0.5, smoothstep(-6.0, -1.0, sliderBallDist));
  colour = mix(sliderBallColour, colour, smoothstep(-1.0, 0.0, sliderBallDist));


  // colour = vec3(dFdx(pixelCoords.x), dFdy(pixelCoords.y), 1.0);

  gl_FragColor = vec4(colour, 1.0);
}