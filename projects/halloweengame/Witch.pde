class Witch {
  
  float xPos, yPos;
  
  float xSpeed = 1;
  
  PImage witch;
  
  Witch(float x, float y) {
    xPos = x;
    yPos = y;  
    
    witch = loadImage("data/witch.png");   
  }
  
  void display() {
    image(witch, xPos, yPos);
    xPos -= xSpeed;
    if (xPos < 0) {
      xPos += 800;
      yPos = random(height);
    } 
  }
}
