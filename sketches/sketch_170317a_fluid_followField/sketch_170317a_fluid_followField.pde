/* jstephens 
 ParticleSystem gongfu 
 
 NEXT:
 [ ] add vehicle behavior SEEK (steering force = desired - current
 [ ] reduce the size of the new particle images and remove size contraints from  image(t, loc.x, loc.y, 30, 30);
 [x] add isEmpty() to check particle system similar to isDead() checks a particle
 [x] add vel & acc to particle class
 [x] jump to the ParticleSystem class
 [x] ArrayList of systems of systems
 [x] MultiVerse class
 [x] inheritance --> 
 [x] class Vehichle extends Particle
 [x] polymorphism
 
 NOTES:
 
 Inheritance:
 1. inherit everything
 2. add data or functionality
 3. override functions
 4. super
 */



MetaSystem meta;

boolean isMacMini = true;   // see notes below for isMacMini scope

void setup() {
  size(1024, 768);
  //size(1024, 768, P2D);  // P2D crashing sketch on MacMini


  meta = new MetaSystem();
}

void draw() {
  fill(0, 5);
  rect(0, 0, width, height);
  meta.runAllSystems();
}





/* isMacMini boolean affects the following:
in class MetaSystem:
void addNewParticleSystem(int pTexIndex_) {
    int totalParticles;
    // P2D crashes MacMini. The isMacMini helps me switch environments
    if (isMacMini) {
      totalParticles = int(random(90, 100));  // P2D crashes MacMini. Switch to simple config is MacMini
    } else {
      totalParticles = int(random(9000, 10000));  // P2D crashes MacMini. Switch to simple config is MacMini
    }
    
    
in class Particle:
void run() {
    update();
    if (isMacMini) {
      display();
    } else {
      render(pTex);     // texture passed to particle constructor from PS object
    }
  }
  
  */