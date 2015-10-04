/**
 * This is a soccer game that totals a user's goals and the number
 * of times they collide with a defender. If the user is "tackled" 5
 * times the game is over.
 *
 * @author Catherine McLoughlin
 */

/* @pjs preload="data/soccerField.png", "data/defenderRight.png", "data/defenderLeft.png";*/

// import minim library
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//initialize audio variable
Minim minim;

//initialize audio files
AudioPlayer soundPlayer;

//Create integer "state" to create opening and closing screens
// gameStart = 0;
// gamePlay = 1;
// gameOver = 3;
int state = 0;

//name Defenders & Player
Defender rio; //Rio Ferdinand, legendary Man Utd. defender
Defender silva; //Thiago Silva, joga bonito
Defender vidic; //Nemanja Vidic, The fierce Serbian
Player player;

PImage holderBackground;
PImage soccerBall;

//keep track of ball position
float xPos;
float yPos;

//keep track of defender y position
float def1YPos = 130;
float def2YPos = 285;
float def3YPos = 455;

//variable for points and giveaways
int goals = 0;
int tackles = 0;


void setup() {
  size(645, 700);
  holderBackground = loadImage("data/soccerField.png");

  // set up Minim
  minim = new Minim(this);

  //load audio file
  soundPlayer = minim.loadFile("data/man_utd_glory.mp3");

  //place background on canvas
  image(holderBackground, 0, 0, width, height);

  //construct defenders
  rio = new Defender(random(width-10), def1YPos);
  silva = new Defender(random(width-10), def2YPos);
  vidic = new Defender(random(width-10), def3YPos);

  //construct ball along bottom edge
  player = new Player(random(width - 10), 600);
}

//simple start screen
void displayStartScreen() {
  background(0);
  fill(255);
  text("welcome! press any key to begin.", 250, 300);
  if (keyPressed == true) {
    state = 1;
    // first rewind the sound
    soundPlayer.rewind();

    // play the file
    soundPlayer.play();
  }
}

//end screen with game info
void displayEndScreen() {
  background(0);
  fill(255);

  // pause the sound
    soundPlayer.pause();

  text("game over.", 250, 300);
  text("goals: " + goals, 250, 350);
  text("tackles: " + tackles, 250, 370);
  text("press any key to play again.", 250, 410);
  if (keyPressed == true) {
    tackles = 0;
    goals = 0;
    state = 1;
  }
}

void draw() {
  //choose between opening screen, gameplay, and end screen
  if (state == 0) {
    displayStartScreen();
  } else if (state == 1) {
    doGamePlay();
  } else if (state == 3) {
    displayEndScreen();
  }
}

//once user has pressed a key, the game begins
void doGamePlay() {
  imageMode(CORNER);
  image(holderBackground, 0, 0, width, height);

  //draw and move defenders
  rio.display();
  rio.move();

  silva.display();
  silva.move();

  vidic.display();
  vidic.move();

  //draw and move ball
  player.display();
  player.move();

  //goals, tackles, time
  displayMetrics();

  //check for point changes
  collisionDetector();
}

//tackles and goals
void collisionDetector() {

  //pull current defender & ball positions from functions in Defender and Player classes
  float def1XPos = rio.returnDefXPos();
  float def2XPos = silva.returnDefXPos();
  float def3XPos = vidic.returnDefXPos();
  float xPos = player.returnBallXPos();
  float yPos = player.returnBallYPos();

  //set threshold for collision detection
  int thresh = 70;

  //set distance variables for each defender
  float distance1 = dist(xPos, yPos, def1XPos, (def1YPos+25));
  float distance2 = dist(xPos, yPos, def2XPos, (def2YPos+25));
  float distance3 = dist(xPos, yPos, def3XPos, (def3YPos+25));

  //check for a collision
  if (distance1 < thresh || distance2 < thresh || distance3 < thresh) {
    player.resetBall();
    tackles++;
  }

  //check if the player has lost yet
  if (tackles >=5) {
    displayEndScreen();
  }

  // goal is a rectangle at (232, 3, 255, 39)
  if ((xPos >= 232 && xPos <= 487) && (yPos >= 3 && yPos <= 39)) {
    player.resetBall();
    goals++;
  }
}

void displayMetrics() {
  long currentTime = millis()/1000;
  fill(255);
  textSize(16);
  text("Goals: " + goals, 490, 650);
  text("Tackles: " + tackles, 490, 670);
  text("Time Played: " + currentTime, 490, 690);
}

class Defender {
  //position of defender
  float xPos, yPos;

  //where does the defender want to move?
  float xSpeed;

  //defender One graphics
  PImage defenderRight;
  PImage defenderLeft;

  //constrctor
  Defender(float x, float y) {
    //place defender
    xPos = x;
    yPos = y;

    //load images
    defenderRight = loadImage("data/defenderRight.png");
    defenderLeft = loadImage("data/defenderLeft.png");

    //chooses randomly whether defender will begin going right or left
    float direction = random(-1, 1);
    if (direction >= 0) {
      xSpeed = random(3, 7);
    } else {
      xSpeed = random(-3, -7);
    }
  }

  void display()
  {
    //switch between left-facing and right facing images of defenders
    imageMode(CENTER);
    if (xSpeed > 0) {
      image(defenderRight, xPos, yPos, 75, 125);
    } else {
      image(defenderLeft, xPos, yPos, 75, 125); //position and size of defender image
    }
  }

  //move defenders
  void move()
  {
    xPos += xSpeed;

    //make defender bounce off walls
    if (xPos >= width || xPos <= 0)
    {
      xSpeed *= -1;
    }
  }

  //allows collision detector to access position of defender in this class
  float returnDefXPos() {
    return xPos;
  }
}

class Player {
  //position of player
  float xPos, yPos;

  //Control ball movement with keys
  float ballXMovement = 0;
  float ballYMovement = 0;

  //ball graphic
  PImage player;

  //constrctor
  Player(float x, float y) {
    xPos = x;
    yPos = y;

    //load images
    imageMode(CENTER);
    player = loadImage("data/soccerBall.png");
  }

  void display() {
    imageMode(CENTER);
    image(player, xPos, yPos, 40, 40);
  }

  void move() {
    // move the ball in direction of key that was pressed
    if (keyPressed && key == CODED) {
      if (keyCode == LEFT) {
        ballXMovement = -5;
      } else if (keyCode == RIGHT) {
        ballXMovement = 5;
      } else if (keyCode == UP) {
        ballYMovement = -5;
      } else if (keyCode == DOWN) {
        ballYMovement = 5;
      }
    }

    // continually add the move amount values to the position of the ball
    xPos += ballXMovement;
    yPos += ballYMovement;

    //wraparound
    if (xPos > width) {
      xPos = xPos - width;
    }
    if (xPos < 0) {
      xPos = width + xPos;
    }
    //reset ball to starting position if it hits top
    if (yPos < 0) {
      resetBall();
    }
    //prevents ball from being able to score by wrapping around at bottom
    if (yPos > height) {
      yPos = 650;
    }
  }

  void resetBall() {
    xPos = random(width);
    yPos = 600;
    ballXMovement = 0;
    ballYMovement = 0;
  }

//return ball position so collision detector can use this data
  float returnBallXPos() {
    return xPos;
  }
  float returnBallYPos() {
    return yPos;
  }
}


