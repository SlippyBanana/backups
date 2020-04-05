/*
Zelda Ripoff by Niklas Benkhoff @2020
 Started on 25th of May 2020
 This program is trying to resemble one of the most iconic games in history:
 The Legend of Zelda: A Link to the Past
 I came across this game because of the best friend of mine, we speedrun this
 game randomized. When Corona struck and when we had a lot of spare time,
 I started to work on this. 
 Special Thanks to
 Lars H.
 Julian H.
 and of course, the origin of my programming knowledge,
 The Coding Train aka Daniel Shiffman
 */





player p1;
environment ev;


boolean moveUP, moveRIGHT, moveLEFT, moveDOWN = false;
boolean bump = false;

ArrayList <PVector>collidersmain1, collidersmain2;
ArrayList <enemy> enemies;

int xoff = 0;
int yoff = 0;
//mapheight/width is how many images fit in the main world
// width* imagewidth gives total map size in px
int mapwidth = 10;
int mapheight = 10;

int imagewidth = 256;
int imageheight = 256;


void setup() {
  //fullScreen(P2D);
  size(800, 800, P2D); 
  rectMode(CENTER);
  p1 = new player();
  ev = new environment();
  ev.construct();
  p1.construct();

  collidersmain1 = new ArrayList<PVector>();
  collidersmain2 = new ArrayList<PVector>();
  enemies = new ArrayList <enemy>();
  enemies.add(new enemy(400, 500, 50, 50, 0));
  enemies.add(new enemy(600, 500, 100, 100, 0));
  for (enemy e : enemies) {
    e.construct();
  }

  collidersmain1.add(new PVector(100, 100));
  collidersmain2.add(new PVector(100, 300));

  collidersmain1.add(new PVector(100, 300));
  collidersmain2.add(new PVector(300, 500));

  collidersmain1.add(new PVector(500, 800));
  collidersmain2.add(new PVector(300, 500));

  collidersmain1.add(new PVector(1280, 1280));
  collidersmain2.add(new PVector(0, 1280));

  //collidersmain1.add(new PVector(1280, 0));
  //collidersmain2.add(new PVector(1280, 1280));

  collidersmain1.add(new PVector(0, 0));
  collidersmain2.add(new PVector(1280, 0));

  collidersmain1.add(new PVector(0, 0));
  collidersmain2.add(new PVector(0, 1280));
}


void draw() {
  translate(0, 0);
  background(0);
  fill(255);
  stroke(255);


  if (player.y < height/6 - yoff) {
    yoff += walkspeed;
  }
  if (player.y > height - height/6 - yoff) {
    yoff -= walkspeed;
  }
  if (player.x < width/6 - xoff) {
    xoff += walkspeed;
  }
  if (player.x > width - width/6 - xoff) {
    xoff -= walkspeed;
  }
  translate(xoff, yoff);
  ev.showbackground();
  p1.display();
  p1.move();
  for (enemy e : enemies) {
    e.AI();
    e.show();
  }
}

void keyPressed() {                    //fucntions für movement, siehe class player
  p1.setmove(keyCode, true);
}

void keyReleased() {
  p1.setmove(keyCode, false);
}
boolean intersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  float den = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);
  float t = ((x1-x3)*(y3-y4)-(y1-y3)*(x3-x4))/den;
  float u = -((x1-x2)*(y1-y3)-(y1-y2)*(x1-x3))/den;

  if (0 <= t && t <= 1 && 0<= u && u<= 1) {
    return true;
  } else {
    return false;
  }
}
boolean bump(float x1, float y1, float x2, float y2, int size1, int size2) {//check bump between two object, x1 y1 is the target object
  float t1 =  y1 - size1/2;
  float t2 =  y2 - size2/2;
  float b1 =  y1 + size1/2;
  float b2 =  y2 + size2/2;

  float l1 =  x1 - size1/2;
  float l2 =  x2 - size2/2;
  float r1 =  x1 + size1/2;
  float r2 =  x2 + size2/2;

  if (l2 < r1 && l1 < r2 && b2 < t1 && b1 < t2) {
    return true;
  } else {
    return false;
  }
}
