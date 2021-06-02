/*
Name: Abdul Samad Gomda
 Date: 6/2/2021
 Description: Pac-man generator 
 */

final float headAngle = 0; // the initial angel
float angleChange = -0.5; // the degree of rotation
int ANGLE_LIMIT = -50; // the limit of rotation
int speed = -10; // the speed of the food since it starts at the end of the screen
int yCoordinate = round(random(height)); // the y coordinate of the food
int xCoordinate = width; // the x coordinate of the food
int score = 0; // keeping track of the score
PImage bg; // the background image

class PackMan {

  int mX;// X position of the mouse 
  int mY; // Y position of the mouse

  void display() {
    pushMatrix();
    //translate(100, 100);
    translate(100, mouseY); // translating the canvas to the initial position of the top half
    rotate(radians(headAngle));
    strokeWeight(3);
    fill(123, 67, 123);
    arc(0, 0, 150, 150, -PI, 0);
    popMatrix();
    pushMatrix();
    //translate(100, 100);
    translate(100, mouseY);// translating the canvas to the initial position of the top half
    rotate(radians(-headAngle)); // totating the bottom half of the pacman
    arc(0, 0, 150, 150, 0, PI); // the bottom half of the pacman
    popMatrix();
    strokeWeight(0);
    fill(255);
    ellipse(120, mouseY-40, 10, 10);// the eye of the pacman
  }
}

void food() { // the function to control the food
  speed -= 0.15; // linearly increasing the speed

  fill(255);
  noStroke();
  ellipse(xCoordinate, yCoordinate, 15, 15); // positioning the food

  xCoordinate+=speed;

  if ((xCoordinate-150 < 0 || xCoordinate > width+50)) { // moving the food to the beginning
    xCoordinate = width;
    yCoordinate = round(random(height));
  }
 
  if (dist(xCoordinate, yCoordinate, mouseX, mouseY)<= 150)
  {
    score +=1;// updating the score
  }
  
  // printing the score
  textAlign(RIGHT);
  fill(255);
  textSize(35);
  text("SCORE", width - 10, 35);
  textSize(28);
  text(score, width - 10, 65);
  
}


void setup() {
  size(500, 500);

  background(123, 23, 28);
}




void draw()
{
  background(123, 23, 28);

  pushMatrix();
  drawPacMan();
  headAngle += angleChange;

  if (headAngle < ANGLE_LIMIT || headAngle > 0)
  {
    headAngle = 0;
    headAngle += angleChange;
  }
  popMatrix();

  //if (frameCount % 10 == 0){
  food();
  // }
}
