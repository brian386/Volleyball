import fisica.*;

//pallete
color blue   = color(29, 178, 242);
color brown  = color(166,120,24);
color green  = color(74,163,57);
color red    = color(224, 80, 61);
color yellow = color(242, 215, 16);

FWorld world;

//keys
boolean wkey, akey, skey, dkey, upkey, downkey, leftkey, rightkey;

FBox lground, rground;
FCircle ball;
float r1, r2;
//Player positions
  PVector Pos1 = new PVector(width/4, 300);
  PVector Pos2 = new PVector(0, 0);
  boolean leftCanJump;
  FPoly P1, P2;
 
// FCircle P1, P2;
 int score1, score2;
 
 //Images
 PImage sky;
 PImage ground;
//SETUP=====================
void setup(){
  //images
  sky = loadImage("sky.png");
  ground = loadImage("ground.png");
  //make window
  size(800, 600, FX2D);
  
  //init world
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 900);
  
  makeCourt();
  makePlayers();
}

void draw(){
  //background(255);
  image(sky, 0, 0, width, height);
  image(ground, width/2, height-100, width/2, 200);
  image(ground, 0, height-100, width/2, 200);
  leftCanJump = false;
  boolean rightCanJump = false;
  ArrayList<FContact> P1contacts = P1.getContacts();
  ArrayList<FContact> P2contacts = P2.getContacts();
  ArrayList<FContact> bcontacts = ball.getContacts();
  //CONTACTS=================================================
  for(FContact c: bcontacts){
    if(c.contains(lground)) {
      score2+=1;
      setup();
    }
    if(c.contains(rground)){
      score1+=1;
      setup();
    }
  }
  for(FContact c: P2contacts){
    if(c.contains(rground)) {
      rightCanJump = true;
    }
  }
  
  int i = 0;
  while (i < P1contacts.size()) {
    FContact c = P1contacts.get(i);
    if (c.contains(lground)) leftCanJump = true;
    i++;
  }

  //MOVEMENT KEYS==================
  if(wkey && leftCanJump) P1.addImpulse(0, -2200);
  if(akey){ 
    //P1.addImpulse(-1000, 0);
    P1.setVelocity(-300, P1.getVelocityY());
  } 
  if(dkey) {
    P1.setVelocity(300, P1.getVelocityY());
  }
  if(skey) P1.addImpulse(0, 100);
  if(upkey && rightCanJump) P2.addImpulse(0, -2200);
  if(leftkey){ 
    P2.setVelocity(-300, P2.getVelocityY());
  }
  if(rightkey) {
    P2.setVelocity(300, P2.getVelocityY());;
  }
  if(downkey) P2.addImpulse(0, 100);
  
  if(P1.getRotation() != 0) P1.setRotation(0);
  if(P2.getRotation() != 0) P2.setRotation(0);
  //if(P1.getVelocityX() > 300) P1.setVelocity(300, P1.getVelocityY());
  //if(P1.getVelocityX() < -300) P1.setVelocity(-300, P1.getVelocityY());
  
  //CANT JUMP OVER NET
  if(P1.getX() > 400-r1) P1.setPosition(400-r1, P1.getY());
  if(P2.getX() < 400+r2) P2.setPosition(400+r2, P2.getY());
  
  
  world.step();
  world.draw();
  
  //DRAW EYES
  
  fill(255);
  ellipse(P1.getX()+25, P1.getY()-20, 30, 30);
  
  float m = (ball.getY()-P1.getY()+20)/(ball.getX()-P1.getX()-25);
  float a = m*m +1;
  float b = -2*m*m*(ball.getX())+2*ball.getY()*m;
  float c = m*m*ball.getX()*ball.getX() - 2*ball.getX()*ball.getY()*m+ball.getY()*ball.getY()-255;
  
  float determinant = b * b - 4 * a * c;
  float x = (-b + sqrt(determinant)) / (2 * a);
  
  fill(0);
  ellipse(x, P1.getY()-20, 10, 10);
  //POINTS=============================
  fill(0);
  textSize(50);
  text(score1, 100, 100);
  text(score2, 700, 100);
  

}

//MAKE COURT=====================================================================
void makeCourt(){
  //LEFT WALL
  FBox LWall = new FBox(50, height);
  LWall.setPosition(-25, height/2);
  //vis
  LWall.setFill(0);
  //phys
  LWall.setStatic(true);
  LWall.setFriction(0);
  world.add(LWall);
  
  //RIGHT WALL
  FBox RWall = new FBox(50, height);
  RWall.setPosition(width+24, height/2);
  //vis
  RWall.setFill(0);
  //phys
  RWall.setStatic(true);
  RWall.setFriction(0);
  world.add(RWall);
  
  //LEFT GROUND
  
  lground = new FBox(width/2, 100);
  lground.setPosition(width/4, height-50);

  //vis
  lground.setFill(0, 0);
  //phys
  lground.setStatic(true);
  lground.setFriction(.2);
  world.add(lground);
  
    //RIGHT GROUND
  rground = new FBox(width/2, 100);
  rground.setPosition(3*width/4, height-50);

  //vis
  rground.setFill(0, 0);
  //phys
  rground.setStatic(true);
  rground.setFriction(.2);
  
  world.add(rground);
  
  //NET
  FBox net = new FBox(15, height/10);
  net.setPosition(width/2, 19*height/24);
  //vis
  net.setFill(0);
  //phys
  net.setStatic(true);
  
  world.add(net);
}
//PLAYERS AND BALL================================================================
void makePlayers(){
  //PLAYER 1
  Pos1 = new PVector(width/4, 400);
  r1 = 50;
   P1 = new FPoly();
  for(float angle = 0; angle < Math.PI; angle += PI/12){
    P1.vertex(-r1*cos(angle), -r1*sin(angle));
  }
  P1.setPosition(Pos1.x, Pos1.y);

  //vis
  P1.setFillColor(red);
  world.add(P1);
  
  //PLAYER 2
  r2 = 50;
  P2 = new FPoly();
  for(float angle = 0; angle < Math.PI; angle += PI/12){
    P2.vertex(-r2*cos(angle), -r2*sin(angle));
  }
  P2.setPosition(3*width/4, 400);
  //vis
  P2.setFillColor(red);
  world.add(P2);
  
  
  //Ball
  ball = new FCircle(20);
  ball.setPosition(width/4, 150);
  ball.setFillColor(green);
  ball.setRestitution(.8);
  ball.setDensity(0.01);
  world.add(ball);
  
}

//KEY PRESSED AND RELEASED=================================================================
void keyPressed(){
  if(key == 'w'|| key == 'W') wkey = true;
  if(key == 'a' || key == 'A') akey = true;
  if(key == 's' ||key == 'S') skey = true;
  if(key == 'd'|| key == 'D') dkey = true;
  
  if(keyCode == UP) upkey = true;
  if(keyCode == LEFT) leftkey = true;
  if(keyCode == RIGHT) rightkey = true;
  if(keyCode == DOWN) downkey = true;
}

void keyReleased(){
  if(keyCode == 'w'|| key == 'W') wkey = false;
  if(key == 'a'|| keyCode == 'A') {
    akey = false;
    P1.setVelocity(0, P1.getVelocityY());
  }
  if(key == 's' || key == 'S'){
    skey = false;
  }
  if(key == 'd'|| key == 'D'){
    dkey = false;
    P1.setVelocity(0, P1.getVelocityY());
  }
  if(keyCode == UP) upkey = false;
  if(keyCode == LEFT) {
    leftkey = false;
    P2.setVelocity(0, P2.getVelocityY());
  }
  if(keyCode == RIGHT) {
    rightkey = false;
    P2.setVelocity(0, P2.getVelocityY());
  }
  if(keyCode == DOWN) downkey = false;
  
}
