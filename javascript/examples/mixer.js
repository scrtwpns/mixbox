let width = 650;
let height = 650;
let center_x = width/2;
let center_y = height/2;
let outer_radius = 300;
let inner_radius = 100;
let circle_radius = 45;
var colors = [];
var centers_outside = [];
var centers_inside = [];
var sliders_pos = [];
var mix_t = [];
let numPigments = 0;
let step = 0;
let dragged = -1;

function setup() {
  createCanvas(650, 650);
  background(255);
  colorMode(RGB);
  stroke(125);
  strokeWeight(3);

  colors = [color( 255,236,4), color( 252,211,0), color( 255,105,0), color( 225,35,1), color( 191,0,18), color( 128,2,46), color( 78,1,66), color( 74,0,101), color( 16,31,61), color( 13, 27, 68), color( 25,  0, 89), color( 8,34,138), color( 12, 69,118), color(  6, 54, 51), color( 0,74,41), color( 84,50,36), color( 58,39,0), color(  13,9,1), color(249,250,249)];

  numPigments = colors.length;
  step = TWO_PI / numPigments;

  for(let i=0; i<numPigments; i++)
  {
    let x0 = center_x + sin(i * step) * inner_radius;
    let x1 = center_x + sin(i * step) * outer_radius;
    let y0 = center_y + cos(i * step) * inner_radius;
    let y1 = center_y + cos(i * step) * outer_radius;

    centers_inside.push( createVector(x0, y0));
    centers_outside.push(createVector(x1, y1));
    mix_t.push(0);
    sliders_pos.push(createVector(x1,y1));

    fill(colors[i]);
    line(x0, y0, x1, y1);
    ellipse(x1, y1, circle_radius, circle_radius);
    fill(200);
    ellipse(center_x, center_y, inner_radius*2, inner_radius*2);
  }

}

function draw() {

  if(dragged > -1)
  {
    mix_t[dragged] = get_t(centers_outside[dragged].x, centers_outside[dragged].y, centers_inside[dragged].x, centers_inside[dragged].y, mouseX, mouseY);
    sliders_pos[dragged] = createVector(centers_outside[dragged].x - sin(dragged * step) * mix_t[dragged] * (outer_radius-inner_radius),
                                        centers_outside[dragged].y - cos(dragged * step) * mix_t[dragged] * (outer_radius-inner_radius));

    background(255);
    let weights = 0;

    for(let i=0; i<numPigments; i++)
    {
      line(centers_inside[i].x, centers_inside[i].y, centers_outside[i].x, centers_outside[i].y);
      fill(colors[i]);
      ellipse(sliders_pos[i].x, sliders_pos[i].y, circle_radius, circle_radius);

      weights += mix_t[i];
    }

    if(weights > 0.000001)
    {
      let latent_mix = [0,0,0,0,0,0,0];
      for(let j=0; j<numPigments; j++)
      {
        if(mix_t[j]>0.000001)
        {
          let latent = mixbox.rgbToLatent(colors[j]);
          let t = mix_t[j]/weights;
          for(let k=0; k<latent.length; k++)
          {
            latent_mix[k] += latent[k] * t;
          }
        }
      }
      let mixed_color = mixbox.latentToRgb(latent_mix);
      fill(mixed_color);
      ellipse(center_x, center_y, inner_radius*2, inner_radius*2);
    }
    else
    {
      fill(200);
      ellipse(center_x, center_y, inner_radius*2, inner_radius*2);
    }

  }

}

function mousePressed()
{
  for(let i=0; i<numPigments; i++)
   {
     if(mouseX > sliders_pos[i].x - circle_radius/2 &&
        mouseX < sliders_pos[i].x + circle_radius/2 &&
        mouseY > sliders_pos[i].y - circle_radius/2 &&
        mouseY < sliders_pos[i].y + circle_radius/2)
     {
       dragged = i;
     }
   }
}

function mouseReleased()
{
  dragged = -1;
}

function get_t (ax, ay, bx, by, qx, qy)
{
  let u = createVector(bx-ax, by-ay);
  let v = createVector(qx-ax, qy-ay);

  let d = (u.x*v.x + u.y*v.y) / u.mag();
  let t = d/u.mag();

  return clamp(t, 0.0, 1.0);
}

function clamp(x, lowerlimit, upperlimit) {
  if (x<lowerlimit) {return lowerlimit;}
  else if(x>upperlimit){return upperlimit;}
  else {return x;}
}
