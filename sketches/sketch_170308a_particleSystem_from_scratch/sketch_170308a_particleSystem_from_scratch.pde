/* jstephens 
 ParticleSystem gongfu 
 */

ArrayList<Particle> particles;
int totalParticles = 1000;
Particle particle;


void setup() {
  size(1024, 768);
  particle = new Particle(random(width), random(height));

  particles = new ArrayList<Particle>();

  for (int i = 0; i < totalParticles; i++) {
    particles.add(new Particle(random(width), random(height)));
  }
}


void draw() {
  ellipse(10, 10, 10, 19);
  particle.display();

  for (int i = particles.size()-1; i > 0; i--){
    particles[i].display();
    if (particles[i].isDead()){
      particles.remove(particles[i]);
     // particles.add(new Particle(random(width), random(height)));
    } 
  }
}