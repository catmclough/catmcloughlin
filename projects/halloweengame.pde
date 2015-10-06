/**
 * @author Catherine McLoughlin
 */

/* @pjs preload= "data/halloween_background.png", "data/pumpkin_normal.png",
"data/pumpkin_shocked.png", "data/candy_corn.png", "data/ghostright.png";*/

// import minim library
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//initialize audio variable
Minim minim;

//initialize audio file
AudioPlayer song3;

Witch bertha;
Ghost casper;

CandyCorn[] candies = new CandyCorn[15];

PImage backgroundImage;
PImage pumpkinNormal;
PImage scaredPumpkin;
PImage candyCorn;

int state = 1;
int numGrabs = 0;
int witchGrabs = 0;

int numFrames = 27;
int currentFrame = 0;
PImage[] images = new PImage[numFrames];


void setup() {
  size(800, 600);

  // set up Minim
  minim = new Minim(this);

  //load audio file
  song3 = minim.loadFile("data/monster_mash.mp3");;

  song3.play();

  backgroundImage = loadImage("data/halloween_background.png");
  pumpkinNormal = loadImage("data/pumpkin_normal.png");
  scaredPumpkin = loadImage("data/pumpkin_shocked.png");
  candyCorn = loadImage("data/candy_corn.png");

  bertha = new Witch(800, random(height));
  casper = new Ghost(0, random(height));

   // create our candy objects
  for (int i = 0; i < candies.length; i++)
  {
    // build a new candy and store it in the appropriate slot
    candies[i] = new CandyCorn(random(0,width), random(0,height), random(5), random(1, 3));
  }

  // increase the detail on our Perlin Noise landscape
  noiseDetail(24);

  //load skeleton gif
  for (int i=0; i<numFrames; i++) {
    images[i] = loadImage("data/giphy-" +(i+1)+ " (dragged).jpeg");
  }
}

void draw() {
  if (state == 1) {
    frameRate(30);
    doGamePlay();
  }
  else if (state == 0) {
    background(0);
    fill(255, 140, 0);

    frameRate(18);
    currentFrame = (currentFrame+1) % numFrames;
    for (int i = 1; i < 800; i+=180) {
      for (int j = 1; j < 550; j+=400) {
        image(images[(currentFrame) % numFrames], i+50, j+100, 240, 180);
      }
    }

    //show scared pumpkin at cursor
    image(scaredPumpkin, mouseX, mouseY, 150, 150);

    //display points
    textAlign(CENTER);
    textSize(50);
    text("You Got Mashed.", width/2, 220);
    textSize(30);
    text("SCORE: " + (numGrabs - witchGrabs), width/2, 270);

    textSize(20);
    text("Your Candy: " + numGrabs,  width/2, 320);
    text("Evil Spirits' Candy: " + witchGrabs, width/2, 350);

    textSize(30);
    text("Press the SPACEBAR to play again!", width/2, 400);

    if (keyPressed == true && key == ' ') {
      numGrabs = 0;
      witchGrabs = 0;
      state = 1;
      bertha.xPos = 800;
      casper.xPos = 0;
    }
  }
 }
 void doGamePlay() {

   imageMode(CORNER);
   image(backgroundImage, 0, 0, 800, 600);
   imageMode(CENTER);

    // visit all objects and tell them to display
    for (int i = 0; i < candies.length; i++)
    {
      // see if the user hit any candy
      boolean hitTest = candies[i].checkHit(mouseX, mouseY);
      if (hitTest) {
        // add a point!
        numGrabs++;
      }
      boolean witchHit  = candies[i].checkHit(bertha.xPos, bertha.yPos);
      boolean ghostHit = candies[i].checkHit(casper.xPos, casper.yPos);

      if (witchHit || ghostHit) {
        witchGrabs++;
      }

    candies[i].display();
    bertha.display();
    casper.display();
    }

    noCursor();

    float distance1 = dist(bertha.xPos, bertha.yPos, mouseX, mouseY);
    float distance2 = dist(casper.xPos, casper.yPos, mouseX, mouseY);

    if (distance1 < 75 || distance2 < 75) {
      state = 0;
    } else {
      image(pumpkinNormal, mouseX, mouseY, 150, 150);
    }

    //show points
    textAlign(LEFT);
    fill(255);
    textSize(30);
    text("Your Candy: " + numGrabs, 100, 40);
    text("Their Candy: " + witchGrabs, 500, 40);
 }

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


