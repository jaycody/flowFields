// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flow Field Following

// Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html

// Flowfield object
FlowField flowfield;
PShape arrow;
PImage a;
Vehicle v;

void setup() {
  size(1800, 540);
  // Make a new flow field with "resolution" of 16
  v = new Vehicle(new PVector(random(width), random(height)), 18, .5);
  flowfield = new FlowField(60);
  arrow = loadShape("arrow.svg");
  a = loadImage("arrow60.png");
}

void draw() {
  background(255);
  // Display the flowfield in "debug" mode
  translate(30,30);
  flowfield.display();
  //saveFrame("ch6_exc6.png");
  v.run();
  v.follow(flowfield);
  //noLoop();
}
// Make a new flowfield
void mousePressed() {
  flowfield.init();
}