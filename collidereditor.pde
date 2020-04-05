ArrayList <PVector> xy1;
ArrayList <PVector> xy2;
boolean press = false;

float anewMouseX = 0;
float anewMouseY = 0;
float atempMouseX = 0;
float atempMouseY = 0;
boolean click = false;

public class coleditor {



  



  JSONArray collider;

  void construct() {

    xy1 = new ArrayList <PVector>();
    xy2 = new ArrayList <PVector>();
    collider = new JSONArray();
  }

  void show() {

    atempMouseX = (mouseX + imagesize/2) / imagesize;
    anewMouseX = round(atempMouseX) * imagesize;

    atempMouseY = (mouseY + imagesize/2) / imagesize;
    anewMouseY = round(atempMouseY) * imagesize;
    
    noFill();
    stroke(255);
    

    //draw gridlines
    
    
    if (click && mouseX < width/2 + imagesize) {
      line(xy2.get(xy2.size() - 1).x * imagesize, xy2.get(xy2.size() - 1).y * imagesize, atempMouseX * imagesize, atempMouseY * imagesize);
    }
    
    
    
  }
  void show2(){
   for (int i = 0; i < xy1.size(); i++) {
      line(xy1.get(i).x * imagesize, xy1.get(i).y * imagesize, xy2.get(i).x * imagesize, xy2.get(i).y * imagesize);
    } 
    if (keyPressed && press == false) {
      savecollider();
      savemaptiles();
      press = true;
    }
    if(anewMouseX <= chunkwidth * imagesize && anewMouseY <= chunkheight * imagesize){
    strokeWeight(6);
    point(anewMouseX, anewMouseY);
    strokeWeight(3);
    }
  }

  void savecollider(){


  for(int i = 0; i < xy1.size(); i++){

   JSONObject colliders = new JSONObject();

   colliders.setInt("id", i);
   colliders.setFloat("x1", xy1.get(i).x);
  colliders.setFloat("y1", xy1.get(i).y);
   colliders.setFloat("x2", xy2.get(i).x);
   colliders.setFloat("y2", xy2.get(i).y);

    collider.setJSONObject(i, colliders);
  }
   saveJSONArray(collider, "data/collider.json");
  }
}
