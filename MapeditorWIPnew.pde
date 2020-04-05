/*
A program to save colliders and mapdata for my Zelda Ripoff.Saves the positions relative to upper left corner ( 0, 0 -> chunkwidth, chunkheight), needs later to be scaled
 to appropriate imagesize, in this context imagesize (variable below).
 
 */
ArrayList <PVector> enddatapos;
ArrayList <PImage> enddatafile;
StringList enddataname;

boolean tempclick = false;

boolean showmap = true;

PImage[] data;
PVector[] position;

coleditor editor;
button c;
button t;
button map;


int mode = 1;

//this number need to be updated, tells how many sprites you have
int numberofdata = 3;
int imagesize = 50;

int holdingindex;

int chunkwidth = 10;
int chunkheight = 10;

float tempMouseX;
float tempMouseY;

float tempMouseX2;
float tempMouseY2;

JSONArray maptiles;

int mapsize = 16;

int index_x = 0;
int index_y = 0;

int[][] chunkmap;
void setup() {
  
  chunkmap = new int[mapsize][mapsize];
  
  maptiles = new JSONArray();

  editor = new coleditor();
  editor.construct();
  c = new button(width/2, height - 100, width/4, 100, "Collidermode");
  t = new button(width - width/4, height - 100, width/4, 100, "Tilemode");
  map = new button(width - width/4, height - 200, width/4, 100, "Show Map");
  c.construct();
  t.construct();
  enddatapos = new ArrayList <PVector>();
  enddataname = new StringList();
  enddatafile = new ArrayList <PImage>();
  data = new PImage[numberofdata];
  position = new PVector[numberofdata];

  int dataxpos = width/2;
  int dataypos = 0;
  //load all files into memory, they need to be labeled in a order of data0.png, data1.png etc.
  for (int i = 0; i < numberofdata; i++) {
    data[i] = loadImage("data" + i + ".png"); 
    position[i] = new PVector(dataxpos, dataypos);
    if (dataxpos < width - imagesize) {
      dataxpos+= imagesize;
    } else {
      dataxpos = width/2;
      dataypos += imagesize;
    }
  }
  size(1600, 800);
}

void draw() {


// calculate new Mouse positions based on grid
  tempMouseX = mouseX/imagesize;
  tempMouseY = mouseY/imagesize;

  tempMouseX2 = round(tempMouseX);
  tempMouseY2 = round(tempMouseY);



  background(0);
  stroke(255);
  //middle cutline
  
  //only if chunk is viewble
  
  line(width/2, 0, width/2, height);
  if(showmap == false){




  if (mode == 1) {
    //delete collider if collider is not full
    if(xy2.size() > xy1.size()){
     xy2.remove(xy2.size() - 1); 
     if(click){
       click = false;
     }
      
    }
    
    
    
    
    
    //set which tile to draw
    for (int i = 0; i < data.length; i++) {
      image(data[i], position[i].x, position[i].y, imagesize, imagesize); 
      
      if (mouseX > position[i].x && mouseX < position[i].x + imagesize && mouseY > position[i].y && mouseY < position[i].y + imagesize) {
        if (clicked()) {
          holdingindex = i;
        }
        
      }
    }
    //create an outline to the selected tile
    noFill();
    rect(position[holdingindex].x, position[holdingindex].y, imagesize, imagesize);
    if (mousePressed && mouseX < chunkwidth * imagesize && mouseY < chunkheight * imagesize) {
      boolean setimage = true;
      
      for (int i = 0; i < enddatapos.size(); i++) {
        //change this line check for SAME IMAGE, enables overwrite
        //reset the overwritten piece
        if (tempMouseX2 == enddatapos.get(i).x && tempMouseY2 == enddatapos.get(i).y && data[holdingindex] == enddatafile.get(i)) {
          setimage = false;
        
        }else if(tempMouseX2 == enddatapos.get(i).x && tempMouseY2 == enddatapos.get(i).y){
         enddatapos.remove(i);
         enddataname.remove(i);
         enddatafile.remove(i);
        
          
        }
      }
      //set the image to this postion
      if (setimage) {
        enddatapos.add(new  PVector(tempMouseX2, tempMouseY2));
        enddataname.append("data" + holdingindex + ".png");
        enddatafile.add(data[holdingindex]);
      }
    }
  }
  //draw a preview on canvas
  for (int i = 0; i < enddatapos.size(); i++) {
    image(enddatafile.get(i), enddatapos.get(i).x * imagesize, enddatapos.get(i).y * imagesize, imagesize, imagesize);
  }
  t.clicked();
  c.clicked();
  t.show();
  c.show();
  
  editor.show2();
  
  if (mode == 0) {
    editor.show();
  }
  //show grid
  fill(255);
  strokeWeight(0.25);
  for (float i = 0; i < imagesize * chunkwidth; i = i + imagesize) {
      line(i, 0, i, imagesize * chunkheight); 
      line(0, i, imagesize * chunkwidth, i);
    }
strokeWeight(3);
  }else if(showmap){
    strokeWeight(0.25);
    int spacer = 50;
   for(int i = 0; i < spacer * mapsize; i = i + spacer){
    
     line(i, 0, i, mapsize * spacer);
     line(0, i, mapsize * spacer, i);
    
   }
   
  }
}
void mousePressed() {
  if(showmap == false){
  if(t.clicked()){
   mode = 1; 
  }else if(c.clicked()){
   mode = 0; 
  }

  tempclick = true;
  if (mouseX < imagesize * chunkwidth + imagesize/2 && mouseY < imagesize * chunkheight + imagesize/2 && mode == 0) {
    if (click == false) {
      click = true;
      //restrict drawing space for collides withing drawing space, set up by chunkwidth data

      xy2.add(new PVector(atempMouseX, atempMouseY));
    } else {
      //restrict drawing space for collides withing drawing space, set up by chunkwidth data

      xy1.add(new PVector(atempMouseX, atempMouseY));

      click = false;
    }
  }
  }
}
boolean clicked() {
  if (tempclick) {
    tempclick = false;
    return true;
  } else {
    return false;
  }
}
void keyReleased() {
  if(showmap == false){
  press = false;
  }
}
void mouseReleased(){
  if(showmap == false){
 tempclick = false; 
  }
}

void savemaptiles() {

  for (int i = 0; i < enddatafile.size(); i++) {
    JSONObject tiles = new JSONObject();

    tiles.setInt("id", i);
    tiles.setString("name", enddataname.get(i));
    tiles.setFloat("posx", enddatapos.get(i).x);
    tiles.setFloat("posy", enddatapos.get(i).y);

    maptiles.setJSONObject(i, tiles);
  }
  saveJSONArray(maptiles, "data/maptiles.json");
}
