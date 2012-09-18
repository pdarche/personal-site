/* @pjs preload="peterdarche.png, bigfelt.jpg"; crisp="true"*/

Vehicle seeker;
ArrayList<Vehicle> seekers;
ArrayList<PVector> targets;
PImage bg;
PImage felt;
boolean moveem = false;

void setup() {
  size(960, 500);

  smooth();
  seekers = new ArrayList<Vehicle>();
  targets = new ArrayList<PVector>();

  felt = loadImage("bigfelt.jpg");
  bg = loadImage("peterdarche.png");
  bg.loadPixels();

  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      int pixelLoc = i + (j * width);
      if ((bg.pixels[pixelLoc] == color(1073741824) || bg.pixels[pixelLoc] == color(536870912) || bg.pixels[pixelLoc] == color(1342177280))) { //1342177280, 536870912, 805306368, 1073741824
        PVector loc = new PVector(i, j);  
        targets.add(loc);
        seeker = new Vehicle(random(0, width), random(0, height));
        seekers.add(seeker);
      }
    }
  }
  smooth();
} 

void draw() {
  background(felt);
  for (int i = 0; i < targets.size(); i++) {
    PVector t = (PVector) targets.get(i);
    Vehicle s = (Vehicle) seekers.get(i);

    // Call the appropriate steering behaviors for our agents
    s.arrive(t);
    s.update();
    s.display();
  }
}

class Vehicle {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  Vehicle(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 3.0;
    maxspeed = 4;
    maxforce = 0.1;
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelerationelertion to 0 each cycle
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    
    applyForce(steer);
  }
  
  // A method that calculates a steering force towards a target, slowing down as target approaches
  // STEER = DESIRED MINUS VELOCITY
  void arrive(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    float d = desired.mag();
    
    // Normalize desired and scale with arbitrary damping within 100 pixels
    desired.normalize();
    if (d < 100 && d > 2) desired.mult(maxspeed*(d/50));
    else desired.mult(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }
    
  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(0,0,0, 40);
    noStroke();
    ellipse(location.x, location.y, 5, 5);
  }
}



