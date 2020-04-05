public class enemy {
  float deltabump = 0;
  boolean up = false;
  boolean down = false;
  boolean left = false;
  boolean right = false;

  int state = 0;//state describes the behavior, 0 is walking, 1 is following
  float posx;
  float posy;
  PVector pos;

  float w;
  float h;

  boolean canmove = true;
  boolean iswalking = false;
  float distance;
  float direction;
  float walkeddistance = 0;
  float speed = 2;
  float idletime = 5;
  float timeidled = 0;
  float idlespeed = 0.1;

  int seedistance = 500;
  
  PVector facing;

/*
type will describe attributs like willTrack, melee/projectile, seedistance, walkspeed
Enemy will also be Locationbound, e.g Dungeon- or Biomspecific
*/
  enemy(float posx_, float posy_, float width_, float height_, int type_) {
    posx = posx_;
    posy = posy_;
    w = width_;
    h = height_;
    int type = type_;
  }
  void construct() {
    
    pos = new PVector(posx, posy);
    facing = new PVector(0,1);
  }
  //AI is for movement and follow
  void AI() {
    //check for LineOfSight and adjust state
    boolean hasLineOfSight = true;
    float dis = dist(player.x, player.y, pos.x, pos.y);
    for (int i = 0; i < collidersmain1.size(); i++) {

      if (intersection(pos.x, pos.y, player.x, player.y, collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y) || dis > seedistance) {
        hasLineOfSight = false;
      }
    }
    if (hasLineOfSight) {
      state = 1;
    } else {
      state = 0;
    }
  }
  void show() {
    //Enemycollider and faceing
    line(pos.x, pos.y, pos.x + facing.x * 120, pos.y + facing.y * 120);
    rect(pos.x, pos.y, w, h);
    //draw LineOfSight
    if (state == 1) {
      line(pos.x, pos.y, player.x, player.y);
    }
    //AI state, walking
    if (state == 0) {
      if (timeidled <= idletime) {

        timeidled += idlespeed;
      }

      // set direction into a random direction 
      if (iswalking == false && timeidled > idletime) {
        distance = random(50, 200); 
        direction = random(0, 4);
        walkeddistance = 0;
        iswalking = true;
      }
      //Move in that direction
      if (iswalking && walkeddistance < distance) {
        if (direction > 0 && direction < 1) {//move to left
          if (canmove(-1, 0)) {
            pos.x -= speed;
            walkeddistance += speed;
            facing.x = -1;
            facing.y = 0;
          } else {
            walkeddistance = distance + 1;
          }
        }
        if (direction > 1 && direction < 2) {
          if (canmove(0, -1)) {
            pos.y -= speed;
            walkeddistance += speed;
            facing.x = 0;
            facing.y = -1;
          } else {
            walkeddistance = distance + 1;
          }
        }
        if (direction > 2 && direction < 3) {
          if (canmove(1, 0)) {
            pos.x += speed;
            walkeddistance += speed;
            facing.x = 1;
            facing.y = 0;
          } else {
            walkeddistance = distance + 1;
          }
        }
        if (direction > 3 && direction < 4) {
          if (canmove(0, 1)) {
            pos.y += speed;
            walkeddistance += speed;
            facing.x = 0;
            facing.y = 1;
          } else {
            walkeddistance = distance + 1;
          }
        }
      } else if (walkeddistance > distance) {
        iswalking = false; 
        timeidled = 0;
        walkeddistance = 0;
      }
    }
    if (state == 1) {
      follow();
    }
  }
  //check if enemy can move, e.g doesnt collide with walls or with other enemys
  //if so, dont allow movement
  boolean canmove(int x_, int y_) {
    int x = x_;
    int y = y_;
    boolean hit = false;
    if (x == 1 && y == 0) {
      for (int i = 0; i < collidersmain1.size(); i++) {
        if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x + w/2, pos.y - h/2, pos.x + w/2 + lee, pos.y - h/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x + w/2, pos.y - h/2, pos.x + w/2, pos.y + h/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x + w/2, pos.y + h/2, pos.x + w/2 + lee, pos.y + h/2)) {

          hit = true;
        }
      }
      for (enemy e : enemies) {
        if (pos.x != e.posx() && pos.y != e.posy()) {
          if (enemybump(e.posx(), e.posy(), e.s(), 1, 0)) {
            hit = true; 
            
          }
        }
      }
    }
    if (x == -1 && y == 0) {
      for (int i = 0; i < collidersmain1.size(); i++) {
        if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x - w/2, pos.y - h/2, pos.x - w/2 - lee, pos.y - h/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x - w/2, pos.y - h/2, pos.x - w/2, pos.y + h/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x - w/2, pos.y + h/2, pos.x - w/2 - lee, pos.y + h/2)) {
          hit = true;
        }
      }
      for (enemy e : enemies) {
        if (pos.x != e.posx() && pos.y != e.posy()) {
          if (enemybump(e.posx(), e.posy(), e.s(), -1, 0)) {
            hit = true; 
            
          }
        }
      }
    }
    if (x == 0 && y == -1) {
      for (int i = 0; i < collidersmain1.size(); i++) {
        if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x - w/2, pos.y - h/2, pos.x - w/2, pos.y - h/2 - lee) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x - w/2, pos.y - h/2, pos.x + w/2, pos.y - h/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x + w/2, pos.y - h/2, pos.x + w/2, pos.y - h/2 - lee)) {
          hit = true;
        }
      }
      for (enemy e : enemies) {
        if (pos.x != e.posx() && pos.y != e.posy()) {
          if (enemybump(e.posx(), e.posy(), e.s(), 0, -1)) {
            hit = true; 
            
          }
        }
      }
    }
    if (x == 0 && y == 1) {
      for (int i = 0; i < collidersmain1.size(); i++) {
        if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x - w/2, pos.y + h/2, pos.x - w/2, pos.y + h/2 + lee) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x - w/2, pos.y + h/2, pos.x + w/2, pos.y + h/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, pos.x + w/2, pos.y + h/2, pos.x + w/2, pos.y + h/2 + lee)) {
          hit = true;
        }
      }
      for (enemy e : enemies) {
        if (pos.x != e.posx() && pos.y != e.posy()) {
          if (enemybump(e.posx(), e.posy(), e.s(), 0, 1)) {
            hit = true; 
            
          }
        }
      }
    }


    if (hit) {
      return false;
    } else {
      return true;
    }
  }
  //ckeck if player is colliding with enemy, if so, bump him back
  boolean bump() {
    float t1 = pos.y - h/2;
    float t2 = player.y - playerheight/2;
    float b1 = pos.y + h/2;
    float b2 = player.y + playerheight/2;

    float l1 = pos.x - w/2;
    float l2 = player.x - playerwidth/2;
    float r1 = pos.x + w/2;
    float r2 = player.x + playerwidth/2;
    boolean colliding = false;
    float bumpdistance = 150;
    float knockspeed = 5;


    boolean intersectleft = false;
    boolean intersectright = false;
    boolean intersecttop = false;
    boolean intersectbottom = false;


    //check which direction player is a wall while kncoking back
    for (int i = 0; i < collidersmain1.size(); i++) {
      if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x-playerwidth/2, player.y - playerheight/2, player.x -playerwidth/2, player.y + playerheight/2)|| intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x - playerwidth/2, player.y - playerheight/2, player.x - playerwidth/2 - lee, player.y - playerheight/2)||intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x - playerwidth/2, player.y + playerheight/2, player.x - playerwidth/2 - lee, player.y + playerheight/2)) {
        intersectleft = true;
      }

      if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x+playerwidth/2, player.y - playerheight/2, player.x +playerwidth/2, player.y + playerheight/2)|| intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x + playerwidth/2, player.y - playerheight/2, player.x + playerwidth/2 + lee, player.y - playerheight/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x + playerwidth/2, player.y + playerheight/2, player.x + playerwidth/2 + lee, player.y + playerheight/2)) {
        intersectright = true;
      }
      if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x-playerwidth/2, player.y - playerheight/2, player.x + playerwidth/2, player.y - playerheight/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x - playerwidth/2, player.y - playerheight/2, player.x - playerwidth/2, player.y - playerheight/2 - lee) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x + playerwidth/2, player.y - playerheight/2, player.x + playerwidth/2, player.y - playerheight/2 - lee)) {
        intersecttop = true;
      }
      if (intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x-playerwidth/2, player.y + playerheight/2, player.x + playerwidth/2, player.y + playerheight/2) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x - playerwidth/2, player.y + playerheight/2, player.x - playerwidth/2, player.y + playerheight/2 + lee) || intersection(collidersmain1.get(i).x, collidersmain1.get(i).y, collidersmain2.get(i).x, collidersmain2.get(i).y, player.x + playerwidth/2, player.y + playerheight/2, player.x + playerwidth/2, player.y + playerheight/2 + lee)) {
        intersectbottom = true;
      }
    }

    //check if collision between enemy and player
    if (l2 < r1 && l1 < r2 && b2 > t1 && b1 > t2) {
      colliding = true;
    }
    //bump him in a specific direction
    // and check if the time is over
    if (left && deltabump <= bumpdistance) {
      
      if (intersectleft == false) {
        player.x -= knockspeed;
      }
      deltabump += knockspeed;
      if (deltabump >= bumpdistance) {
        left = false;
        bump = false;
        time = true;
      }
    }
    if (right && deltabump <= bumpdistance) {
      
      if (intersectright == false) {
        player.x += knockspeed;
      }
      deltabump += knockspeed;
      if (deltabump >= bumpdistance) {
        right = false;
        bump = false;
        time = true;
      }
    }
    if (up && deltabump <= bumpdistance) {
      
      if (intersecttop == false) {
        player.y -= knockspeed;
      }
      deltabump += knockspeed;
      if (deltabump >= bumpdistance) {
        up = false;
        bump = false;
        time = true;
      }
    }
    if (down && deltabump <= bumpdistance) {
      
      if (intersectbottom == false) {
        player.y += knockspeed;
      }
      deltabump += knockspeed;
      if (deltabump >= bumpdistance) {
        down = false;
        bump = false;
        time = true;
      }
    }
    //set the bump direction
    if(allowbump && bump == false){
    if (colliding) {
      if (player.x < pos.x) {
        if (player.y < pos.y - h/2 && player.y > pos.y + h/2 || player.y + playerheight/2 - lee > pos.y - h/2 && player.y - playerheight/2 + lee < pos.y + h/2) {
          left = true;
          bump = true;
          deltabump = 0;
          
          
        }
      }
    }

    if (colliding) {
      if (player.x > pos.x) {
        if (player.y < pos.y - h/2 && player.y > pos.y + h/2 || player.y + playerheight/2 - lee > pos.y - h/2 && player.y - playerheight/2 + lee < pos.y + h/2) {
          right = true;
          bump = true;
          deltabump = 0;
          

          
        }
      }
    }
    if (colliding) {
      if (player.y < pos.y) {
        if (player.x < pos.x - w/2 && player.x > pos.x + w/2 || player.x + playerwidth/2 - lee > pos.x - w/2 && player.x - playerwidth/2 + lee < pos.x + w/2) {
          up = true;
          bump = true;
          deltabump = 0;
          

          
        }
      }
    }
    if (colliding) {
      if (player.y >  pos.y) {
        if (player.x < pos.x - w/2 && player.x > pos.x + w/2 || player.x + playerheight/2 - lee > pos.x - w/2 && player.x - playerheight/2 + lee < pos.x + w/2) {
          down = true;
          bump = true;
          deltabump = 0;
          

          
        }
      }
    }
    }
    //and return if bumping
    if (bump) {
      return true;
    } else {
      return false;
    }
  }
  //AI for fallowing player and setting the facedirection
  void follow() {
    boolean canmoveright = false;
    boolean canmoveleft = false;
    boolean canmovedown = false;
    boolean canmoveup = false;
    float disx = dist(player.x, 0, pos.x, 0);
    float disy = dist(0, player.y, 0, pos.y);

    if (pos.x < player.x) {
      if(disx > disy){
       facing.x = 1;
       facing.y = 0;
      }
      for (enemy e : enemies) {
        if (e.posx() != pos.x || e.posy() != pos.y) {
          if (canmove(1, 0) && enemybump(e.posx(), e.posy(), e.s(), 1, 0) == false) {
            canmoveright = true;
          }
       }
      }
    }
    if (pos.x > player.x) {
      if(disx > disy){
       facing.x = -1;
       facing.y = 0;
      }
      for (enemy e : enemies) {
      if (e.posx() != pos.x || e.posy() != pos.y) {
          if (canmove(-1, 0) && enemybump(e.posx(), e.posy(), e.s(), -1, 0) == false) {
            canmoveleft = true;
          }
       }
      }
    }
    if (pos.y < player.y) {
      if(disy > disx){
       facing.x = 0;
       facing.y = 1;
      }
      for (enemy e : enemies) {
        if (e.posx() != pos.x || e.posy() != pos.y) {
          if (canmove(0, 1) && enemybump(e.posx(), e.posy(), e.s(), 0, 1) == false) {
            canmovedown = true;
          }
        }
      }
    }
    if (pos.y > player.y) {
      if(disy > disx){
       facing.x = 0;
       facing.y = -1;
      }
      for (enemy e : enemies) {
        if (e.posx() != pos.x || e.posy() != pos.y) {
          if (canmove(0, -1) && enemybump(e.posx(), e.posy(), e.s(), 0, -1) == false) {
            canmoveup = true;
          }
        }
      }
    }
    if (canmoveleft) {
      pos.x -= 2;
    }
    if (canmoveright) {
      pos.x += 2;
    }
    if (canmovedown) {
      pos.y += 2;
    }
    if (canmoveup) {
      pos.y -= 2;
    }
  }
  //return enemyspecific stats for other use
  float posx() {
    return pos.x;
  }
  float posy() {
    return pos.y;
  }
  float s() {
    return w;
  }
  //check if enemies are colliding with each other
  boolean enemybump(float x2, float y2, float size, int x, int y) {// number 1 is for actual target, 2 is for checktarget

    float t1 = pos.y - h/2;
    float t2 = y2 - size/2;
    float b1 = pos.y + h/2;
    float b2 = y2 + size/2;

    float l1 = pos.x - w/2;
    float l2 = x2 - size/2;
    float r1 = pos.x + w/2;
    float r2 = x2 + size/2;


    boolean bumping = false;

    boolean collidingleft = false;
    boolean collidingright = false;
    boolean collidingtop = false;
    boolean collidingbottom = false;

    if (l2 < r1 && l1 < r2 && b2 > t1 && b1 > t2) {
      if (pos.x + w/2 < x2 - size/2 + lee) {
        collidingright = true;
      }
      if (pos.x - w/2 > x2 + size/2 - lee) {
        collidingleft = true;
      }
      if (pos.y + h/2 < y2 - size/2 + lee) {
        collidingbottom = true;
      }
      if (pos.y - h/2 > y2 + size/2 - lee) {
        collidingtop = true;
      }
    }

    if (x == 1 && y == 0 && collidingright) {
      bumping = true;
    }
    if (x == -1 && y == 0 && collidingleft) {
      bumping = true;
    }
    if (x == 0 && y == -1 && collidingtop) {
      bumping = true;
    }
    if (x == 0 && y == 1 && collidingbottom) {
      bumping = true;
    }
    if (bumping) {
      return true;
    } else {
      return false;
    }
  }
  /*
  boolean bump(int x_, int y_){
   int x = x_;
   int y = y_;
   float dis = dist(pos.x, pos.y, player.x, player.y);
   float minDis = sqrt(2*(w*w));
   text(minDis, 300, 800);
   text(dis, 300, 750);
   
   boolean isbumping = false;
   if(x == 1 && y == 0){
   
   if(player.x < pos.x && minDis > dis){
   isbumping = true; 
   text("true", 300, 700);
   }
   }
   if(x == -1 && y == 0){
   
   if (player.x > pos.x && dis <= minDis){
   isbumping = true; 
   }
   }
   if(x == 0 && y == 1){
   
   if(player.y < pos.y && dis <= minDis){
   isbumping = true; 
   }
   }
   if(x == 0 && y == -1){
   
   if(player.y > pos.y && dis <= minDis){
   isbumping = true; 
   }
   }
   if(isbumping){
   return true; 
   }else{
   return false; 
   }
   }
   */
}
