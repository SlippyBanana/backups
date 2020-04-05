PVector player;
PVector playerfacing;
int playerwidth = 50;
int playerheight = 50;
boolean notknocking;

int walkspeed = 4;



int lee = 5; // leeway for calculating the collision, as its not exact

float deltastun = 0;
float stuninc = 0.5;
float stuntime = 60;
boolean temp = false;
boolean allowbump = false;
boolean time = false;
public class player {

  void construct() {
    player = new PVector (200, 300);
    playerfacing = new PVector(0,1);
  }

  void move() {
//----------------------------------------------------
//THIS WILL PROB by removed, timer for bumping of enemy, check enemy - bump()
//----------------------------------------------------
if(bump){
 temp = true; 
}
    if (bump == false && temp) {
      time = true;
      temp = false;
    }
    if (deltastun != 0) {
      allowbump = false;
    }
    if(deltastun == 0 && bump == false){
     allowbump = true; 
    }
    
    if (time && deltastun <= stuntime) {
      deltastun += stuninc;
    }else if(deltastun > stuntime){
      time = false;
      deltastun = 0;
    }



    for (enemy e : enemies) {
      e.bump();
    }


    //movement for main
    //if Inputted left
    if (moveLEFT) {
      boolean canmove = true;
      //check if playermovement is obstructed by anything
      for (int i = 0; i < collidersmain1.size(); i++) {

        if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x-playerwidth/2, player.y - playerheight/2, player.x -playerwidth/2, player.y + playerheight/2)|| intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x - playerwidth/2, player.y - playerheight/2, player.x - playerwidth/2 - lee, player.y - playerheight/2)||intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x - playerwidth/2, player.y + playerheight/2, player.x - playerwidth/2 - lee, player.y + playerheight/2)) {
          canmove = false;
        }
      }
      // if everythings good, move and face direction
      if (canmove && bump == false) {
        player.x -= walkspeed;
        playerfacing.x = -1;
      playerfacing.y = 0;
      }
    } 
    //movement for right
    if (moveRIGHT) {
      boolean canmove = true;
      //check if playermovement is obstructed by anything
      for (int i = 0; i < collidersmain1.size(); i++) {

        if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x+playerwidth/2, player.y - playerheight/2, player.x +playerwidth/2, player.y + playerheight/2)|| intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x + playerwidth/2, player.y - playerheight/2, player.x + playerwidth/2 + lee, player.y - playerheight/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x + playerwidth/2, player.y + playerheight/2, player.x + playerwidth/2 + lee, player.y + playerheight/2)) {
          canmove = false;
        }
      }
      // if everythings good, move and face direction
      if (canmove && bump == false) {
        player.x += walkspeed;
        playerfacing.x = 1;
      playerfacing.y = 0;
      }
    } 
    //movement for up
    if (moveUP) {
      boolean canmove = true;
      //check if playermovement is obstructed by anything
      for (int i = 0; i < collidersmain1.size(); i++) {

        if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x-playerwidth/2, player.y - playerheight/2, player.x + playerwidth/2, player.y - playerheight/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x - playerwidth/2, player.y - playerheight/2, player.x - playerwidth/2, player.y - playerheight/2 - lee) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x + playerwidth/2, player.y - playerheight/2, player.x + playerwidth/2, player.y - playerheight/2 - lee)) {
          canmove = false;
        }
      }
      // if everythings good, move and face direction
      if (canmove && bump == false) {
        player.y -= walkspeed;
        playerfacing.x = 0;
      playerfacing.y = -1;
      }
    } 
    //Input Move Down
    if (moveDOWN) {
      boolean canmove = true;
      //check if playermovement is obstructed by anything
      for (int i = 0; i < collidersmain1.size(); i++) {

        if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x-playerwidth/2, player.y + playerheight/2, player.x + playerwidth/2, player.y + playerheight/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x - playerwidth/2, player.y + playerheight/2, player.x - playerwidth/2, player.y + playerheight/2 + lee) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x + playerwidth/2, player.y + playerheight/2, player.x + playerwidth/2, player.y + playerheight/2 + lee)) {
          canmove = false;
        }
      }
      // if everythings good, move and face direction
      if (canmove && bump == false) {
        player.y += walkspeed;
        playerfacing.x = 0;
      playerfacing.y = 1;
      }
    }
  }
  //say what direction is inputted
  boolean setmove(int k, boolean b) {
    switch (k) {
//return the Input as direction
    case UP:
      
      return moveUP = b;
      

    case DOWN:
      ;
      return moveDOWN = b;

    case LEFT:
      
      return moveLEFT = b;

    case RIGHT:
      
      return moveRIGHT = b;

    default:
      return b;
    }
  }
  //figure out if theres a collision

  void display() {
    
     
    
    
    //rect(player.x, player.y, playerwidth, playerheight);
    line(player.x-playerwidth/2, player.y - playerheight/2, player.x -playerwidth/2, player.y + playerheight/2);
    line(player.x+playerwidth/2, player.y - playerheight/2, player.x +playerwidth/2, player.y + playerheight/2);
    line(player.x-playerwidth/2, player.y - playerheight/2, player.x + playerwidth/2, player.y - playerheight/2);
    line(player.x-playerwidth/2, player.y + playerheight/2, player.x + playerwidth/2, player.y + playerheight/2);

    //line which way player is facing
    line(player.x, player.y, player.x + playerfacing.x * 100, player.y + playerfacing.y * 100);
    //display colliders in main world
    for (int i = 0; i < collidersmain1.size(); i++) {
      line(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y);
    }
  }
}
