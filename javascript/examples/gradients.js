let colorPicker_A;
let colorPicker_B;
let color_A;
let color_B;

function setup() {
  createCanvas(650, 465);
  background(255);
  colorMode(RGB);

  colorPicker_A = createColorPicker('#002185');
  colorPicker_A.parent('picker-A');
  color_A = colorPicker_A.color();

  colorPicker_B = createColorPicker('#fcd200');
  colorPicker_B.parent('picker-B');
  color_B = colorPicker_B.color();

  drawGradient("Mixbox", color_A, color_B, 50, 200, 65, 465);
  drawGradient("RGB", color_A, color_B, 250, 400, 65, 465);
  drawGradient("OkLab", color_A, color_B, 450, 600, 65, 465);

}

function draw() {

  if(color_A.toString() != colorPicker_A.color().toString() || color_B.toString() != colorPicker_B.color().toString())
  {
    background(255);

    color_A = colorPicker_A.color();
    color_B = colorPicker_B.color();

    drawGradient("Mixbox", color_A, color_B, 50, 200, 65, 465);
    drawGradient("RGB", color_A, color_B, 250, 400, 65, 465);
    drawGradient("OkLab", color_A, color_B, 450, 600, 65, 465);
  }

}

function drawGradient(method, color1, color2, x1, x2, y1, y2)
{
  textSize(28);
  textStyle(BOLD);
  fill(79, 118, 123);
  text(method, x1 + (x2-x1)/2 - textWidth(method)/2, y1-30);
  let mixedColor;

  for (let y = y1; y <= y2; y++)
    {
      let t = (y-y1)/(y2-y1);
      if(match(method, 'Mixbox'))
      {
        mixedColor = mixbox.lerp(color1, color2, t);
      }
      else if(match(method, 'RGB'))
      {
        mixedColor = lerpColor(color1, color2, t);
      }
      else if(match(method, 'OkLab'))
      {
        let c1 = [red(color1), green(color1), blue(color1)];
        let c2 = [red(color2), green(color2), blue(color2)];
        let tmp = linear_to_rgb (oklab_to_linear_srgb(linearMix(linear_srgb_to_oklab(rgb_to_linear(c1)),linear_srgb_to_oklab(rgb_to_linear(c2)),t)));
        mixedColor = color(tmp[0], tmp[1], tmp[2]);
      }
      strokeWeight(2);
      stroke(mixedColor);
      line(x1, y, x2, y);
      noStroke();
    }
}

/* THE FOLLOWING CODE IS HANDLING THE CONVERSION TO OkLAB SPACE */
/* https://bottosson.github.io/posts/oklab/ */

function linear_srgb_to_oklab(c)
{
  let l = 0.4122214708 * c[0] + 0.5363325363 * c[1] + 0.0514459929 * c[2];
	let m = 0.2119034982 * c[0] + 0.6806995451 * c[1] + 0.1073969566 * c[2];
	let s = 0.0883024619 * c[0] + 0.2817188376 * c[1] + 0.6299787005 * c[2];

  let l_ = Math.cbrt(l);
  let m_ = Math.cbrt(m);
  let s_ = Math.cbrt(s);

  var lab = [ 0.2104542553*l_ + 0.7936177850*m_ - 0.0040720468*s_,
              1.9779984951*l_ - 2.4285922050*m_ + 0.4505937099*s_,
              0.0259040371*l_ + 0.7827717662*m_ - 0.8086757660*s_ ];

  return lab;
}

function oklab_to_linear_srgb(c)
{
    let l_ = c[0] + 0.3963377774 * c[1] + 0.2158037573 * c[2];
    let m_ = c[0] - 0.1055613458 * c[1] - 0.0638541728 * c[2];
    let s_ = c[0] - 0.0894841775 * c[1] - 1.2914855480 * c[2];

    let l = l_*l_*l_;
    let m = m_*m_*m_;
    let s = s_*s_*s_;

    var lrgb =  [ 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
                 -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
                 -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s];
    return lrgb;
}

function rgb_to_linear(rgb) // receiving Color object, returning array of 3 linear RGB values in range 0-1
{
  var res = [0,0,0];
  var float_rgb = [rgb[0]/255, rgb[1]/255, rgb[2]/255];
  for (let i = 0; i < 3; ++i)
  {
    let c = float_rgb[i];
    if (c >= 0.04045)
        res[i] = pow((c + 0.055)/(1 + 0.055), 2.4);
    else
        res[i] = c / 12.92;
  }
  return res;
}

function linear_to_rgb(lrgb) // receiving array of 3 linear RGB values, returning an array of gamma encoded RGB values in range 0-255
{
  var res = [0,0,0];
  for (let i = 0; i < 3; ++i)
  {
    let c = lrgb[i];
    if (c >= 0.0031308)
        res[i] = 1.055 * pow(c, 1.0/2.4) - 0.055;
    else
        res[i] = 12.92 * c;
  }
  return [round(res[0]*255), round(res[1]*255), round(res[2]*255)];
}

function linearMix (a, b, t)
{
  var res = [0,0,0];
  for(let i=0; i<3; i++)
  {
    res[i] = a[i] * (1-t) + b[i]*t;
  }
  return res;
}
