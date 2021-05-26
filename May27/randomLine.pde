/*
Name: Abdul Samad Gomda
 Date: 26th May, 2021
 Version: 1.0
 Description: A random lines generator 
 */

// initalizing a random number of times the loop should run
int randomNumberLoop = 50 + round(random(90));

// function to draw two sets of random lines side by side
void drawRandomLines()
{
  // loop for lines on the left side of the canvas
  for (int i=0; i<= randomNumberLoop; i++)
  {
    int randomStartX = round(random(500)); // starting X position of the line
    int randomStartY = round(random(500)); // starting Y position of the line
    int randomEndX = round(random(500)); // ending X position of the line
    int randomEndY = round(random(500)); // ending Y position of the line
    int randomThickness = round(random(5)); // random number for the thickness of the line
    
    // drawing the lines
    strokeWeight(randomThickness);
    //stroke(random(255), random(255), random(255));
    line(randomStartX, randomStartY, randomEndX, randomEndY);
  }

  // loop for lines on the right side of the canvas
  for (int i=0; i<= randomNumberLoop; i++)
  {
    int randomStartX = round(random(500, 1000)); // starting X position of the line
    int randomStartY = round(random(500)); // starting Y position of the line
    int randomEndX = round(random(500, 1000)); // ending X position of the line
    int randomEndY = round(random(500)); // ending Y position of the line
    int randomThickness = round(random(5));
    strokeWeight(randomThickness);
    //stroke(random(255), random(255), random(255));
    line(randomStartX, randomStartY, randomEndX, randomEndY);
  }
}
void setup()
{// initializing the setup values
  background(200);
  size(1000, 500);
}

void draw()
{
  background(200);
  
  // slowing the time between the draw calls
  delay(1000);
  
  // drawing the partition line
  strokeWeight(8);
  line(500, 0, 500, 500);
  
  // calling the function to draw the lines
  drawRandomLines();
}
