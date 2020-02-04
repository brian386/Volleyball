import fisica.*;
float pos = 0;
//pallete
color blue   = color(29, 178, 242);
color brown  = color(166, 120, 24);
color green  = color(74, 163, 57);
color red    = color(224, 80, 61);
color yellow = color(242, 215, 16);
int mode = 0;
FWorld world;

//keys
boolean wkey, akey, skey, dkey, upkey, downkey, leftkey, rightkey;
boolean AI = true;
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
PImage ground, greenPlayer, ballImage;
//SETUP=====================
void setup() {
  //images
  ballImage = loadImage("ball.png");
  ballImage.resize(20, 20);
  greenPlayer = loadImage("green.png");
  greenPlayer.resize(120, 60);
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

void draw() {
  if (mode == 0) {
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
    for (FContact c : bcontacts) {
      if (c.contains(lground)) {
        score2+=1;
        setup();
        ball.setPosition(width/4, 150);
      }
      if (c.contains(rground)) {
        score1+=1;
        setup();
        ball.setPosition(3*width/4, 150);
      }
    }


    for (FContact c : P2contacts) {
      if (c.contains(rground)) {
        rightCanJump = true;
      }
    }

    int i = 0;
    while (i < P1contacts.size()) {
      FContact c = P1contacts.get(i);
      if (c.contains(lground)) leftCanJump = true;
      i++;
    }

    //MOVEMENT KEYS============================
    if (wkey && leftCanJump) P1.addImpulse(0, -2200);
    if (akey) { 
      //P1.addImpulse(-1000, 0);
      P1.setVelocity(-300, P1.getVelocityY());
    } 
    if (dkey) {
      P1.setVelocity(300, P1.getVelocityY());
    }
    if (skey) P1.addImpulse(0, 100);


    //P2

    float a, b, c, t, dx;
    if (AI == false) {
      if (upkey && rightCanJump) P2.addImpulse(0, -2000);
      if (leftkey) { 
        P2.setVelocity(-300, P2.getVelocityY());
      }
      if (rightkey) {
        P2.setVelocity(300, P2.getVelocityY());
      }

      if (downkey) P2.addImpulse(0, 100);
    } else {
      //AI==========================================================
      //for (FContact con : P1contacts) {
      //  if (con.contains(ball)) {
      // if(dist(ball.getX(), ball.getY(), P1.getX(), P1.getY())< 100){
       //POSITION
        a = 0.5*900;
      b = ball.getVelocityY();
      c = ball.getY() - 500;
      float determinant = b * b - 4 * a * c;
      t = (-b + sqrt(determinant)) / (2 * a);
      dx = ball.getVelocityX()*t;
      pos = (ball.getVelocityX() >=0) ? ball.getX() +dx+15: ball.getX()+dx+20;

      if (pos > 800) pos = 800 - pos%800;
      if (pos < 400) pos = 600;
      
      for (FContact c2 : P2contacts) {
        if (dist(ball.getX(), ball.getY(), P2.getX(), P2.getY()) < 100 && c2.contains(rground)) {
          P2.addImpulse(0, -600);
        }
      }
      //  }
      //}
      println(pos);
      //AI MOVING_______________
      
      if (P2.getX() > pos+2) {
        P2.setVelocity(-260, P2.getVelocityY());
        // P2.addImpulse(-100, 0);
      } else if(P2.getX() < pos-2){
        P2.setVelocity(260, P2.getVelocityY());
        //P2.addImpulse(100, 0);
      } else{
        P2.setVelocity(0, P2.getVelocityY());
      }
    }

    P1.setRotatable(false);
    P2.setRotatable(false);
    //if (P1.getRotation() != 0) P1.setRotation(0);
    //if (P2.getRotation() != 0) P2.setRotation(0);
    //if(P1.getVelocityX() > 300) P1.setVelocity(300, P1.getVelocityY());
    //if(P1.getVelocityX() < -300) P1.setVelocity(-300, P1.getVelocityY());

    //CANT JUMP OVER NET
    if (P1.getX() > 400-r1-10) P1.setPosition(400-r1-10, P1.getY());
    if (P2.getX() < 400+r2+10) P2.setPosition(400+r2+10, P2.getY());
    //WIN
    if (score1 == 3 || score2 ==3) {
      mode = 1;
    }
    //DRAW WORLD+++++++++++++++++++++++++++++++++++++++++++++
    world.step();
    world.draw();
    //DRAW EYES==========================================================

    fill(255);
    ellipse(P1.getX()+25, P1.getY()-20, 30, 30);
    float p1 = P1.getX() +25;
    float q1 = P1.getY()-20;
    float xb1 = ball.getX();
    float yb1 = ball.getY();
    //float m = (ball.getY()-P1.getY()+20)/(ball.getX()-P1.getX()-25);

    //float a = 1 + m*m;
    //float b = -2*xb - 2*m*m*xb + 2*m*yb - 2*m*q;
    //float c = p*p + m*m*xb*xb - 2*m*xb*yb + 2*m*xb*q + yb*yb - 2*yb*q + q*q -225;


    //float determinant = b * b - 4 * a * c;
    //float x = (-b + sqrt(determinant)) / (2 * a);
    PVector pvel = new PVector((xb1 -p1), (yb1 -q1));
    pvel.setMag(8);
    float px1 = p1;
    float py1 = q1;

    if (dist(p1, q1, px1, py1) <25) {
      px1 += pvel.x;
      py1 += pvel.y;
    }
    fill(0);
    ellipse(px1, py1, 10, 10);

    fill(255);
    ellipse(P2.getX()-25, P2.getY()-20, 30, 30);
    float p2 = P2.getX() -25;
    float q2 = P2.getY()-20;
    float xb2 = ball.getX();
    float yb2 = ball.getY();

    PVector pvel2 = new PVector((xb2 -p2), (yb2 -q2));
    pvel2.setMag(8);
    float px2 = p2;
    float py2 = q2;

    if (dist(p2, q2, px2, py2) <25) {
      px2 += pvel2.x;
      py2 += pvel2.y;
    }
    fill(0);
    ellipse(px2, py2, 10, 10);
    //POINTS=============================
    fill(0);
    textSize(50);
    text(score1, 100, 100);
    text(score2, 700, 100);
  } else {
    //MODE 1---------------------------------------------
    background(255);
    textSize(100);
    if (score1 > score2) {
      text("Player 1 Wins", 100, 300);
    } else {
      text("Player 2 Wins", 100, 300);
    }

    world = new FWorld();
  }
}

//MAKE COURT=====================================================================
void makeCourt() {
  //LEFT WALL
  FBox LWall = new FBox(50, 4*height);
  LWall.setPosition(-25, height/2);
  //vis
  LWall.setFill(0);
  //phys
  LWall.setStatic(true);
  LWall.setFriction(0);
  world.add(LWall);

  //RIGHT WALL
  FBox RWall = new FBox(50, 4*height);
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
void makePlayers() {
  //PLAYER 1
  Pos1 = new PVector(width/4, 400);
  r1 = 50;
  P1 = new FPoly();
  for (float angle = 0; angle < Math.PI; angle += PI/12) {
    P1.vertex(-r1*cos(angle), -r1*sin(angle));
  }
  P1.setPosition(Pos1.x, Pos1.y);

  //vis
  P1.setFillColor(green);
  //P1.attachImage(greenPlayer);
  world.add(P1);

  //PLAYER 2
  r2 = 50;
  P2 = new FPoly();
  for (float angle = 0; angle < Math.PI; angle += PI/12) {
    P2.vertex(-r2*cos(angle), -r2*sin(angle));
  }
  P2.setPosition(3*width/4, 400);
  //vis
  P2.setFillColor(red);
  world.add(P2);
  //P2.attachImage(greenPlayer);

  //Ball
  ball = new FCircle(20);
  ball.setPosition(width/4, 150);
  ball.setFillColor(yellow);
  ball.setRestitution(1);
  ball.setDensity(3);
  ball.attachImage(ballImage);
  world.add(ball);
}

//KEY PRESSED AND RELEASED=================================================================
void keyPressed() {
  if (key == 'w'|| key == 'W') wkey = true;
  if (key == 'a' || key == 'A') akey = true;
  if (key == 's' ||key == 'S') skey = true;
  if (key == 'd'|| key == 'D') dkey = true;

  if (keyCode == UP) upkey = true;
  if (keyCode == LEFT) leftkey = true;
  if (keyCode == RIGHT) rightkey = true;
  if (keyCode == DOWN) downkey = true;
}

void keyReleased() {
  if (keyCode == 'w'|| key == 'W') wkey = false;
  if (key == 'a'|| keyCode == 'A') {
    akey = false;
    P1.setVelocity(0, P1.getVelocityY());
  }
  if (key == 's' || key == 'S') {
    skey = false;
  }
  if (key == 'd'|| key == 'D') {
    dkey = false;
    P1.setVelocity(0, P1.getVelocityY());
  }
  if (keyCode == UP) upkey = false;
  if (keyCode == LEFT) {
    leftkey = false;
    P2.setVelocity(0, P2.getVelocityY());
  }
  if (keyCode == RIGHT) {
    rightkey = false;
    P2.setVelocity(0, P2.getVelocityY());
  }
  if (keyCode == DOWN) downkey = false;
}

void mouseReleased() {
  if (mode !=0) {
    mode = 0;
    setup();
    score1 = 0;
    score2 = 0;
  }
}
