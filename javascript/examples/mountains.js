let magenta, yellow, phthalo_blue, titanium_white, phthalo_medium;

function setup()
{
  createCanvas(800, 650);
  background(80);
  colorMode(RGB);
  strokeWeight(2);

  magenta = color(128,2,46);
  yellow = color(255,236,4);
  phthalo_blue = color(13,27,68);
  titanium_white = color(249,251,249);
  phthalo_medium = color(mixbox.lerp(phthalo_blue, titanium_white, 0.5));
}

function draw()
{
  for(let y=0; y<height; y++ )
  {
    let t = y*0.8/(height/2.3);
    let mix_col = mixbox.lerp(magenta, yellow,t);
    stroke(mix_col);
    line(0, y, width, y);
    noStroke();
  }

  draw_mountain(460, 350, width/4, height);
  draw_mountain(430, 550, width/4*3, height);
  draw_mountain(370, 200, width/2-100, height);
  draw_mountain(250, 250, width/4*2.7, height);

  draw_sun(width/2, height/4, 100);

  updatePixels();
  noLoop();
}

function draw_mountain (mount_height, mount_width, base_x, base_y)
{
  let xoff1 = random(0, 300);
  let xoff2 = random(0, 300);
  let xoff3 = random(0, 300);
  let nScl1 = 0.009;
  let nScl2 = 0.009;
  let mountain_curr_width = 2;

  for(let y=0; y<mount_height; y++)
  {
    let middle = noise(xoff1) * mountain_curr_width;
    let x1 = -mountain_curr_width - noise(xoff2)*mountain_curr_width/2;
    let x2 =  mountain_curr_width + noise(xoff3)*mountain_curr_width/2;

    for(let x=x1; x<middle; x++)
    {
      let t = (x -x1) / (middle - x1);
      let gradient_color = mixbox.lerp(phthalo_blue, phthalo_medium, t);
          gradient_color = mixbox.lerp(gradient_color, titanium_white, (1-y/mount_height)/1.5);
      set(base_x + x, (base_y-mount_height) + y, color(gradient_color));
    }
    for(let x=middle; x<x2; x++)
    {
      let t = pow((x-middle)/(x2-middle), 1.5);
      let gradient_color = mixbox.lerp(titanium_white, phthalo_medium, t);
          gradient_color = mixbox.lerp(gradient_color, titanium_white, (1-y/mount_height)/1.5);
      set(base_x + x, (base_y-mount_height) + y, color(gradient_color));
    }
    mountain_curr_width += mount_width/mount_height * (exp(y/mount_height * 1.5)-0.3);
    xoff1 += nScl1;
    xoff2 += nScl2;
    xoff3 += nScl2;
  }
}

function draw_sun(center_x, center_y, radius)
{
  for (let y = center_y-radius/2; y < center_y+radius/2; y++)
  {
    for (let x = center_x-radius/2; x < center_x+radius/2; x++)
    {
      let d = dist(x,y,center_x,center_y);
      if (d < radius/2)
      {
        let sun_color = mixbox.lerp(titanium_white, get(x,y), 0.5);
        sun_color = mixbox.lerp(get(x,y), sun_color, (y-(center_y-radius/2))/radius); // vertical fade
        set(x, y, color(sun_color));
      }
    }
  }
}
