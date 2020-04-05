class button {
  float x;
  float y;
  float sizex;
  float sizey;
  int col;
  String text;
  button(float x_, float y_, float sizex_, float sizey_, String text_) {
    x = x_;
    y = y_;
    sizex = sizex_;
    sizey = sizey_;
    text = text_;
  }
  void construct() {
    col = 255;
  }
  void show() {
    fill(col);
    rect(x, y, sizex, sizey);
    rectMode(CENTER);
    textMode(CENTER);
    fill(0);
    textSize(25);
    text(text, x + sizex/2 - 85 , y + sizey/2);
    rectMode(CORNER);
  }
  boolean clicked() {
    if (mouseX > x && mouseX < x + sizex && mouseY > y && mouseY < y + sizey) {
      col = 100;
      return true;
    } else {
      col = 255;
      return false;
    }
  }
}
