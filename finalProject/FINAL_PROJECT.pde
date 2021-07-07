/* 
 Name: Abdul Samad Gomda
 Date: 07/08/2021
 Description: Final project involving communication between arduino and processing
 */

// importing and initializing variables
import processing.serial.*;
import processing.sound.*;
Sound overallVolume;

Serial Port;

// background class to control the background
class Background {
  PImage bgImg1; // the main background image
  PImage bgImg2; // the drive screen background image\
  PImage bgImg3; // the map background
  int screen = 1; // temporary variable

  public Background() {
    // loading the images
    bgImg1 = loadImage("images/background1.png");
    bgImg2 = loadImage("images/drive.jpg");
    bgImg3 = loadImage("images/mapBackground.jpg");
  }

  public void display() {
    // screen one and two for the 
    if (game.screen == 1) {
      image(bgImg1, 0, 0);
    } else if (game.screen == 3){
      image(bgImg3, 0, 0);
    }
    else {
      image(bgImg2, 0, 0);
    }
  }
} // end of the background class

// class to draw rectangles for map
class Rectangle {

  float xPosition;
  float yPosition;

  public Rectangle(int angle, int hypotenus) {
    // getting the x and y positions from the angle
    xPosition = abs(round(hypotenus * cos(angle)));
    yPosition = abs(round(hypotenus * sin(angle)));
    
    xPosition = round(map(xPosition, 0, 110, 0, width));
    yPosition = round(map(yPosition, 0, 110, 0, height));
    
  }
  public void display() {
    fill(0, 255, 0);
    rect(xPosition, yPosition, 20, 20); // displaying the rectangle
  }
}
// the main game class

class Game {
  int screen;
  boolean mapping, alive, soundOn, isPlaying;
  Background background;
  PImage upArrow, downArrow, leftArrow, rightArrow;
  ArrayList<Rectangle> rectangles;

  public SoundFile backgroundSound; // the background sound

  public Game() {
    // initializing the game variables
    screen = 1;
    alive = true;
    mapping = false;
    isPlaying = true;
    soundOn = true;
    background = new Background();
    textFont(font);

    // initializing the arraylis

    rectangles = new ArrayList<Rectangle>();

    // loading the arrow images
    upArrow = loadImage("images/upArrow.png");
    downArrow = loadImage("images/downArrow.png");
    leftArrow = loadImage("images/leftArrow.png");
    rightArrow = loadImage("images/rightArrow.png");


    // loading the sound file
    backgroundSound = new SoundFile(FINAL_PROJECT.this, "sound/backgroundSound.mp3");
    backgroundSound.loop(); // looping the background sound
  }
  //Command to move orward
  public void Forward() {
    if (key == CODED) {
      if (keyCode == UP) {
        Port.write('F');
      }
    }
  }

  //Command to move backwards
  public void Backwards() {
    if (key == CODED) {
      if (keyCode == DOWN) {
        Port.write('B');
      }
    }
  }

  //Command to turn left
  public void turnLeft() {
    if (key == CODED) {
      if (keyCode == LEFT) {
        Port.write('L');
      }
    }
  }
  //Command to turn right
  public void turnRight() {
    if (key == CODED) {
      if (keyCode == RIGHT) {
        Port.write('R');
      }
    }
  }

  //Command to stop rover
  public void brakes() {
    if (keyPressed) {
      if (key == 's' || key == 'S') {
        Port.write('S');
      }
    }
  }

  //Command to to map
  public void mapping() {
    if (keyPressed) {
      if (key == 'm' || key == 'M') {
        Port.write('M');
      }
    }
  }
  public void drive() {
    // driving the rover
    
    turnLeft();
    turnRight();
    Forward();
    Backwards();
    brakes();
  }
  public void hightligthArrows() {

    // highlighting the key

    if (keyCode == UP) {
      noFill();
      stroke(0, 255, 0);
      rect(320, 400, 80, 100);
    } else if (keyCode == DOWN) {
      noFill();
      stroke(0, 255, 0);
      rect(320, 630, 80, 100);
    } else if (keyCode == RIGHT) {
      noFill();
      stroke(0, 255, 0);
      rect(430, 550, 100, 80);
    } else if (keyCode == LEFT) {
      noFill();
      stroke(0, 255, 0);
      rect(200, 550, 100, 80);
    }
  }

  public void display() {
    background.display();

    // state determination
    if (screen == 1) {
      textAlign(RIGHT);
      fill(255);
      textSize(35);
      text("Welcome To Space Rover: Remastered", 700, 100);
      textSize(40);

      // menu buttons
      textAlign(CENTER);
      text("Drive!", 350, 400);
      text("Map", 350, 470);
      text("Instructions", 350, 530);
      text("Exit", 350, 600);
      textSize(40);
      noFill();
      // making a rectangle on the options
      if ((mouseX>= 287 && mouseX<=411) && (mouseY>= 367 && mouseY<=408)) {
        stroke(255);
        rect(230, 367, 250, 50);
        if (mousePressed) {
          screen = 2; // changing the screen
        }
      }
      if ((mouseX>= 308 && mouseX<=392) && (mouseY>= 435 && mouseY<=478)) { // the instructions box
        stroke(255);
        rect(220, 435, 250, 50);
        if (mousePressed) {
          screen = 3; // changing the screen
        }
      }

      if ((mouseX>= 227 && mouseX<=468) && (mouseY>= 496 && mouseY<=534)) { // theexit box
        stroke(255);
        rect(230, 490, 250, 50);
        if (mousePressed) {
          screen = 4; // exiting the game
        }
      }

      if ((mouseX>= 308 && mouseX<=402) && (mouseY>= 565 && mouseY<=606)) { // theexit box
        stroke(255);
        rect(230, 555, 250, 50);
        if (mousePressed) {
          exit(); // exiting the game
        }
      }
    } else if (screen == 2) { // the drive screen
      // displating the arrow images
      textAlign(RIGHT);
      fill(255);
      textSize(35);
      text("Drive Ahead, My Dear Space Ranger !!!", 700, 100);
      text("But Remember,\n DO NOT GO GENTLE INTO \n THAT GOOD NIGHT!", 700, 200);
      textSize(40);

      stroke(0, 255, 0);
      image(upArrow, 320, 400, 80, 100);
      image(leftArrow, 200, 550, 100, 80);
      image(rightArrow, 430, 550, 100, 80);
      image(downArrow, 320, 630, 80, 100);

      // highlighting the key
      hightligthArrows();
      drive(); // calling the drive method to drive the rover
      // back button
      text("<< Back", 150, 400);
      // going back to the home screen when the mouse is pressed
      if ((mouseX>= 28 && mouseX<=156) && (mouseY>= 369 && mouseY<=407)) {
        noFill();
        stroke(255);
        rect(4, 363, 150, 40);

        if (mousePressed) {
          screen = 1; // changing the screen to the home screen
        }
      }
    } else if (screen == 4) {// isntructions screen
      textAlign(CENTER);
      textSize(38);
      text("Instructions: " + "\n\n", 380, 150);
      textSize(25);
      text("1. In the drive window, use the arrow keys to control"+ "\n"+" the rover" + "\n" +"2. You can in any window of the game, press x/X"+ "\n"+" to mute/unmute the audio" + "and press p/P to play/pause " + "\n"+ "3. In the map window, the rover"+ "\n" +" stops to enable the distance measuring"  + "\n" + " sensor map the surroundings"+ "\n\n"+ "IT'S HARDER THAN YOU THINK!!", 400, 190);
      text("<< Back", 350, 700);  
      // going back to the home screen when the mouse is pressed
      if ((mouseX>= 308 && mouseX<=396) && (mouseY>= 679 && mouseY<=705)) {
        stroke(255);
        rect(280, 670, 150, 40);

        if (mousePressed) {
          screen = 1; // changing the screen to the home screen
        }
      }
    } else if (screen == 3) {
      // displaying the rectangles
      for (int i=0; i< rectangles.size(); i++) {
        rectangles.get(i).display();
      }
      fill(255);
      text("Press M to map", 380, 150);
      mapping = true;
      mapping();
      // the back button
      text("<< Back", 350, 700);  
      // going back to the home screen when the mouse is pressed
      if ((mouseX>= 308 && mouseX<=396) && (mouseY>= 679 && mouseY<=705)) {
        noFill();
        stroke(255);
        rect(280, 670, 150, 40);

        if (mousePressed) {
          alive = false; // creating a new game
          Port.write('M'); // writing a differernt value to the serial port
        }
      }
    }
  }
}// end of the game class




PFont font;
Game game;

void setup() {
  size(720, 720);
  String portname = Serial.list()[1];
  // Opening the serial port
  Port = new Serial(FINAL_PROJECT.this, portname, 9600);
  Port.clear();
  Port.bufferUntil('\n');
  font = createFont("ComicSansMS", 32);
  game = new Game();
  overallVolume = new Sound(FINAL_PROJECT.this);
}

void draw() {
  game.display();
  if (game.alive == false) {
    game = new Game();
  }
}

// reading the serial event
void serialEvent(Serial myPort) {
  int xPos, yPos;
  String s=myPort.readStringUntil('\n');
  s=trim(s);
  if (s!=null) {
   // println(s);
    int values[]=int(split(s, ','));
    if (values.length==2) {
      game.rectangles.add(new Rectangle(values[0], values[1]));
    }
  }
}


void keyTyped() {
  // controlling the audio
  if ((key == 'x' || key== 'X') && game.soundOn) {
    overallVolume.volume(0); // muting the audio
    game.soundOn = false;
  } else if ((key == 'x' || key== 'X') && !game.soundOn) {
    overallVolume.volume(1); // unmuting the audio
    game.soundOn = true;
  }

  if ((key == 'p' || key== 'P') && game.isPlaying) {
    noLoop();
    overallVolume.volume(0); // muting the audio
    game.isPlaying = false;
  } else if ((key == 'p' || key== 'P') && !game.isPlaying) {
    loop();
    overallVolume.volume(1); // unmuting the audio
    game.isPlaying = true;
  }
}
