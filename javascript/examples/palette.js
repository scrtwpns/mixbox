var visited = []; // coordinates of the boxes the mouse has visited while pressed once
var boxes = [];   // all boxes that should be displayed and colored, item is an array [x, y, R, G, B]
let boxSize = 40;
let color1;
let color2;
let valid_start = false;
let valid_end = false;

function setup() {

  createCanvas(800, 680);
  background(80);
  colorMode(RGB);
  rectMode(CENTER);

  boxes.push([ 60, 60,[ 13,  27,  68]]); // phthalo blue
  boxes.push([580, 180,[255, 236,   4]]); // bis yellow
  boxes.push([420,  60,[255, 236,   4]]); // bis yellow
  boxes.push([220, 300,[255, 208,   0]]); // hansa yellow
  boxes.push([420, 380,[ 25,   0,  89]]); // ultramarine blue
  boxes.push([500, 260,[ 25,   0,  89]]); // ultramarine blue
  boxes.push([700, 380,[225,  35,   1]]); // cadmium red
  boxes.push([580, 580,[128,   2,  46]]); // magenta
  boxes.push([100, 580,[249, 250, 249]]); // white
  boxes.push([260, 580,[249, 250, 249]]); // white
  drawBoxes();
}

function draw()
{
  // record visited boxes
  if(mouseIsPressed === true)
  {
    let x = snapToGrid(mouseX);
    let y = snapToGrid(mouseY);

    let alreadyIn = false;
    for(let v=0; v<visited.length; v++)
    {
      if(visited[v][0]==x && visited[v][1]==y) {alreadyIn = true};
    }
    if(!alreadyIn) {visited.push([x,y]);}
  }

  // draw overlay on visited boxes
  if (visited.length > 0)
  {
    stroke(230);
    noFill();
    setLineDash([5, 5]);
    for(let v=0; v<visited.length; v++)
    {
      rect(visited[v][0], visited[v][1], boxSize, boxSize);
    }
  }
}

function mousePressed()
{
  // sample color from canvas
  [color1, valid_start] = sampleColor(snapToGrid(mouseX), snapToGrid(mouseY));
}

function mouseReleased()
{
  // sample color from canvas
  [color2, valid_end] = sampleColor(snapToGrid(mouseX), snapToGrid(mouseY));

  // calculate color of visited boxes & push them into boxes
  if(mouseinside())
  {
    if(valid_start && valid_end)
    {
      let numVisited = visited.length;
      for(let v=0; v<numVisited; v++)
      {
        let t = numVisited>1 ? v * 1.0/(numVisited-1) : 1;
        let mixedColor = mixbox.lerp(color1, color2, t);
        boxes.push([visited[v][0], visited[v][1], mixedColor]);
      }
    }
    else{alert("You must start and end inside colored squares.");}
  }


  // clear visited array
  visited = [];

  // redraw screen to erase the overlay, clear background, draw boxes
  background(80);
  drawBoxes();

}

function drawBoxes()
{
  noStroke();
  for(let b=0; b<boxes.length; b++)
  {
    fill(color(boxes[b][2]));
    rect(boxes[b][0], boxes[b][1], boxSize, boxSize);
  }
}

function sampleColor (x, y)
{
  for(let b=0; b<boxes.length; b++)
  {
    if(boxes[b][0] == x && boxes[b][1] == y)
    {
      return [color(boxes[b][2]), true];
    }
  }

  return [color(255), false];
}

function snapToGrid (x){
  return boxSize/2 + floor(x/boxSize) * boxSize;
}

function setLineDash(list) {
  drawingContext.setLineDash(list);
}

function mouseinside(){
  if(mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {return true;}
  else {return false};
}
