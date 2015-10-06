class Ghost {
  
  float xPos, yPos;
  
  float xSpeed = 1;
  
  PImage ghost;
  
  Ghost(float x, float y) {
    xPos = x;
    yPos = y;  
    
    ghost = loadImage("data/ghostright.png");   
  }
  
  void display() {
    image(ghost, xPos, yPos, 200, 161);
    xPos += xSpeed;
    if (xPos > 800) {
      xPos -= 800;
      yPos = random(height);
    } 
  }
}
