class CandyCorn {
  
  float xPos, yPos, fallSpeed, rotation;
  
  float perlinIndex;
  
  float angle = 0;
  
  float size = 150;
  
  CandyCorn(float x, float y, float f, float z) {
    xPos = x;
    yPos = y;  
    
    // pick a random perlin noise index
    perlinIndex = random(0, 100000);
    
    fallSpeed = f;
    rotation = z;
  }
  
  boolean checkHit(float x, float y)
  {
    // touching
    if (x > xPos-(size/2) && x < xPos+(size/2) && y > yPos-(size/2) && y < yPos+(size/2))
    {
      //hide the candy
      yPos = random(-300, -50);
      
      return true;
    }
    else
    {
      return false;
    }
    
  }
  
  void display() {
    // grab a random number from the Perlin noise generator
    float r = noise(perlinIndex);
    
    // turn that number into a number between -2 and 2 to simulate our swaying left and right
    float xMovement = map(r, 0, 1, -2, 2);
    
    // add xMovement to our xPos
    xPos += xMovement;
    
    // prevent the candy corn from going off the right or left edges
    xPos = constrain(xPos, 0, width-50);
   
    //always dropping
    yPos += fallSpeed;
    
    // wrapping
    if (yPos > height)
    {
      yPos = -50;
    }
    
    // add a small amount to our Perlin noise location so next time we get a different random #
    perlinIndex += 0.01;
    
    //rotate corn
    pushMatrix();
    translate(xPos, yPos);
    rotate( radians(angle) );

    image(candyCorn, 0, 0);  
     
    popMatrix();
    
    angle += rotation;
  }
  
}
