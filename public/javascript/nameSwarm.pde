/* @pjs preload="peterdarche.png"; crisp="true";  isTransparent = true*/

PImage bg;
ArrayList<Mover> movers;
ArrayList<Attractor> attractors;
Mover m;
Attractor a;

void setup() {
  background(255);
  size(960, 500, OPENGL);
  smooth();
  movers = new ArrayList<Mover>();
  attractors = new ArrayList<Attractor>();

  bg = loadImage("peterdarche.png");
  bg.loadPixels();
   
   for (int i = 0; i < width; i++) {
     for (int j = 0; j < height; j++) {
       int pixelLoc = i + (j * width);
       if ((bg.pixels[pixelLoc] == color(1073741824) || bg.pixels[pixelLoc] == color(536870912))) { //1342177280, 536870912, 805306368, 1073741824
         PVector loc = new PVector(i, j);  
         Attractor a = new Attractor(loc);
         attractors.add(a);
       }
     }
   }
   
  for (int i = 0; i < attractors.size(); i++) {
    m = new Mover(random(0.1, 2), random(width), random(0));
    movers.add(m);
  }
}  

void draw() {
  background(255);
  
  for(int i = 0; i < attractors.size(); i++){
    Attractor attr = (Attractor) attractors.get(i);
    Mover mov = (Mover) movers.get(i);
    PVector force = attr.attract(mov);
    mov.applyForce(force);
    mov.run();
  }

if(mousePressed){
    PVector mousePos = new PVector(mouseX, mouseY);
    for(int i = 0; i < movers.size(); i++){
      Mover tempMover = (Mover) movers.get(i);
      PVector distance = PVector.sub(mousePos, tempMover.location);
      distance.normalize();
      tempMover.applyForce(distance);
    }
  }
}

class Attractor {
  float mass;         
  PVector location;   
  float g;

  Attractor(PVector _location) {
    location = _location;
    mass = 20;
    g = 1.4;
  }

  PVector attract(Mover m) {
    PVector force = PVector.sub(location,m.location);             
    float distance = force.mag();                                 
    distance = constrain(distance,5.0,25.0);                      
    force.normalize();                                            
    float strength = (g * mass * m.mass) / (distance * distance); 
    force.mult(strength);                                         
    return force;
  }

  // Method to display
  void display() {
    stroke(0);
    fill(0);
    ellipse(location.x,location.y,20,20);
  }
}


class Mover {

  PVector location, velocity, acceleration;
  float mass;

  Mover(float m, float x, float y) {
    mass = m;
    location = new PVector(x, y);
    velocity = new PVector(random(-1,3), random(-1,5));
    acceleration = new PVector(0, 0);
  }

  void run() {
    //repel();
    update();
    display();
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void repel() {
    Iterator<Mover> it = movers.iterator();
    while (it.hasNext ()) {
      Mover other = it.next();
      PVector bump = PVector.sub(location, other.location);
      float distance = bump.mag();
      if (distance <= mass*12) {
        bump.normalize();
        float strength = other.mass;
        bump.mult(strength);
        bump.div(10);
        acceleration.add(bump);
      }
    }
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.div(1.01);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    noStroke();
    fill(0, 0, 0, 40);
    ellipse(location.x, location.y, 5, 5);
  }
}




