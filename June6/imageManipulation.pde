/*
  Name: Abdul Samad Gomda
 Date: 6 June 2021
 Description: Recreation of the inverted and BW filter
 */

PImage img, blankImg; // image variables
void setup() {
  img = loadImage("cat1.png"); // loading the image
  size(700, 500);
}

void draw() {
  loadPixels();
  img.loadPixels();
  for (int i=0; i< width; i++) {
    for (int j=0; j<height; j++) {
      int pixelLocation = i + j*width; // getting the pixels at a particular location
      color col = img.pixels[pixelLocation]; // getting the color of the pixel at that location
      float red = red(col);
      float blue = blue(col);
      float green = green(col);
      color newCol = color(0.21 * red + 0.72*red+0.07*blue); // setting the initial to grey
      if (mousePressed) {
        newCol = color(255-red, 255-green, 255-blue); // changing to inverted
        ;
      }
      pixels[pixelLocation] = newCol; // setting the color of the pixel
    }
  }

  img.updatePixels(); // updating the pixels in the original image
  updatePixels(); // updating the pixels on the canvas
}
