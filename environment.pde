class environment {
  PImage grass;
  PImage flowers;
  
 
  boolean isGrass[][];
 void construct(){
   flowers = loadImage("grassflowers.png");
   flowers.resize(imagewidth, imageheight);
   grass = loadImage("grass.png");
   grass.resize(imagewidth, imagewidth);
   isGrass = new boolean[mapwidth][mapheight];
   for(int i = 0; i < mapheight; i++){
    for(int j = 0; j < mapwidth; j++){
      float chooser = random(0,10);
       if(chooser < 1){
       isGrass[i][j] = false;
       }else{
        isGrass[i][j] = true;
       }
    }
     
   }
   
 }
 void showbackground(){
   for (int i = 0; i < mapheight; i++){
     for(int j = 0; j < mapwidth; j++){
       if(isGrass[i][j]){
        image(grass, j * imagewidth, i * imageheight); 
       }else{
        image(flowers, j * imagewidth, i * imageheight); 
       }
     }
   }
   
 }
}
