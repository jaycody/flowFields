class Vehicle {

  PVector gridVector;

  PVector loc;
  PVector vel;
  PVector acc;
  PVector size;

  float   currentHeading;
  boolean alignVehicle;
  float   rotVel;
  float   rotAcc;
  
  float   maxspeed;  // stops teleportation
  float   maxforce;  // ability to steer


  color   refColor;
  color   strokeColor;
  float   brightnessFromCell;
  float   alpha;

  Vehicle(boolean align_) {
    gridVector  = new PVector(0, 0);

    loc         = new PVector(random(width), random(height));
    vel         = new PVector(0, 0);
    acc         = new PVector(0, 0);
    size        = new PVector(gridResolution, gridResolution); 

    currentHeading     = loc.heading2D();          // initialize heading via location
    alignVehicle       = align_;
    
    maxspeed           = random(2.0, 5.0); //2, 5
    maxforce           = random(.1, .5); //.1, .5

    refColor    = color(255, 0, 0);
    strokeColor = color(255, 0, 0);
    alpha       = random(15,45);
  }

  /////////////////////////////////////////////////////////////////////
  /////////// FOLLOW FLOWFIELD ////////////////////
  // time to add some autonomousness
  /* 1. calc desired vector: goal vector - current position
   2. scale desire by max speed to prohibit teleportation
   3. calc steering force: desired vector - current velocity
   4. limit steering force based on max ability (maxforce)
   5. apply steering force by adding it to acceleration
   6. acceleration informs velocity
   7. velocity informs location
   8. reset acceleration to zero
   */
  void follow(FlowField flow) {      
    //PVector desired = flow.lookup(loc);
    gridVector = flow.lookup(loc);

    if (alignVehicle) alignTo(gridVector);

    // scale it up by maxspeed
    gridVector.mult(maxspeed);        //gridVector.mult(maxspeed*theta); change velocity based on angle
    // calculate steering force
    // PVector steering = PVector.sub(desired, velocity);
    //  - but without creating a temp PVector it looks like...
    //      desired.sub(velocity); or 
    gridVector.sub(vel);
    gridVector.limit(maxforce);
    applyForce(gridVector);
  }

  void applyForce(PVector force) {
    acc.add(force);
  }
  ////////////// END FOLLOW FLOWFIELD
  ///////////////////////////////////////////////////////////////////////



  ///////////////////////////////////////////////////////////////////////
  ////////////// ALIGN TO VECTOR FIELD
  void alignTo(PVector desiredAlignment) {
    float desiredHeading = desiredAlignment.heading2D();

    // scale to maxspeed
    desiredHeading *= maxspeed*.0001;

    // calculate steering force
    float alignmentForce = desiredHeading - currentHeading;

    // limit to maxforce
    if (alignmentForce > maxforce*.01) alignmentForce = maxforce*.01;
    if (alignmentForce < -maxforce*.01) alignmentForce = -maxforce*.01;

    applyRotationForce(alignmentForce);
  }

  void applyRotationForce(float rotationForce) {
    rotAcc += rotationForce;
  }

  void updateHeading() {
    // update velocity
    rotVel += rotAcc;
    
    // limit velocity
    if (rotVel > .1) rotVel = .1;
    if (rotVel < -.1) rotVel = -.1;
   
    // update current heading
    currentHeading += rotVel;
    // clear acceleration
    rotAcc = 0;
    //rotVel = 0;
  }
  ////////////// END ALIGN TO VECTOR FIELD
  ///////////////////////////////////////////////////////////////////////



  void update() {
    // update velocity with current forces
    vel.add(acc);
    // limit velocity to max speed
    vel.limit(maxspeed);
    // update location by dist/frame (velocity)
    loc.add(vel);
    // reset acc
    acc.mult(0);
    
    if(alignVehicle) updateHeading();
  }


  void display() {
    //heading = vel.heading2D();

    fill(refColor, alpha);
    stroke(refColor, 255);

    pushMatrix();
    translate(loc.x, loc.y);
    rotate(currentHeading);
    //rect(0, 0, (size.x*(cos(theta))*1.5), (size.y*(sin(theta)))*1.5);
    rect(0, 0, size.x, size.y);
    popMatrix();
  }

  void getBrightnessFrom(FlowField flow) {
    brightnessFromCell = flow.lookupBrightness(loc);
  }

  void getColorFrom(FlowField flow) {
    refColor = flow.lookupColor(loc);
  }

  void borders() {
    if (loc.x < -size.x) loc.x = width + size.x;
    if (loc.y < -size.y) loc.y = height + size.y;

    if (loc.x > width + size.x) loc.x = -size.x;
    if (loc.y > height + size.y) loc.y = -size.y;
  }
}