void setup()
{
//the bartman
size(700, 500);
background(0);
smooth();
}

void draw()
{
  //hair
  strokeWeight(4);
  stroke(255);
  line(100, 100, 95, 75);
  line(95, 75, 125, 95);
  line(125, 95, 135, 65);
  line(135, 65, 160, 93);
  line(160, 93, 180, 63);
  line(180, 63, 197, 93);
  line(197, 93, 215, 61);
  line(215, 61, 235, 90);
  line(235, 90, 257, 55);
  line(257, 55, 274, 88);
  line(274, 88, 285, 55);
  line(285, 55, 297, 84);
  line(297, 84, 300, 55);

  //bottom of head
  line(100, 100, 135, 380);
  line(135, 380, 275, 367);
  line(328, 315, 300, 55);

  //chin
  line(277, 340, 275, 367);

  //eyes
  fill(0);
  ellipse(297, 230, 70, 70);
  ellipse(227, 235, 79, 79);

  //pupils
  strokeWeight(13);
  point(294, 228);
  point(224, 232);

  //nose
  strokeWeight(4);
  ellipse(270, 275, 50, 30);

  //neck
  rect(115, 360, 85, 50);

  //smiletop
  curve(328, 315, 328, 315, 208, 315, 208, 330);
  //smilemiddle
  curve(330, 315, 208, 315, 208, 340, 277, 340) ;
  //smilebottom
  curve(208, 315, 208, 340, 277, 340, 277, 340);

  //teeth
  line(210, 315, 207, 340);
  line(230, 315, 227, 340);
  line(250, 315, 247, 340);
  line(270, 315, 267, 340);

  //ear
  fill(0);
  ellipse(120, 285, 30, 30);
  noStroke();
  ellipse(135, 282, 19, 19);

}

//words appear with click
void mousePressed() {
   textSize(20);
   fill(255);
   textSize(20);
   text("hello, world. don't have a cow.", 350, 325);
 }
