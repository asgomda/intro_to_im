
/*
INTRODUCTION TO INTERACTIVE MEDIA
 MIDTERM PROJECT
 Name: Abdul Samad Gomda
 Description: Chicken Invaders Game in Processing
 */

import processing.sound.*;

Sound overallVolume;
float eggSpeed = 1.75;// the speed of falling eggs
class Background {
  private PImage bgImg;
  private PImage starImg;
  private float yShift;

  public Background() {

    // loading the two background images 
    bgImg = loadImage("images/background.jpg");

    starImg = loadImage("images/stars.png");
    yShift = 0;
  }
  public void display() {
    image(bgImg, width / 2, height / 2);

    // shifting all images to the left
    yShift += 2;
    // making the stars move at half the shift speed
    int y = (int) yShift / 2;
    // calculating correct positions for the different images
    int upWidth, downWidth;
    upWidth = y % height;
    downWidth = height - upWidth;

    imageMode(CORNER);
    image(starImg, 0, 0, upWidth, height, downWidth, 0, width, height);
    image(starImg, upWidth, 0, downWidth, height, 0, 0, downWidth, height);
    imageMode(CENTER);
  }
}

class Egg {
  private PImage egg;
  public PVector position;
  int radius = 12;

  public Egg(int xPos, int yPos) {
    egg = loadImage("images/Egg.png");
    position = new PVector(xPos, yPos+15); // getting the position of the chicken
  }
  public void display() {
    update();
    image(egg, position.x, position.y, radius*2, radius*2);
  }
  public void update() {
    position.y += eggSpeed;
    if (position.y <= height+13 && position.y >= height+11) { // increasing the score if the player avoids an egg
      game.score += 1;
    }
    if (position.y >= height+40)
    {
      game.eggs.remove(this); // removing eggs
    }

    if (dist(position.x, position.y, mouseX, game.spaceShip.yPosition) <= game.spaceShip.radius) { // checking the distance between the egg and th spaceship
      game.alive = false;
      game.screen = 4;
      game.backgroundSound.stop(); // stopping the background sound
      game.gameOverSound.play(); // playing the game over sound
    }
  }
}

// The powerup class
public class PowerUp {
  private PImage powerUp;
  public PVector position;
  int radius = 12;
  int powerUpImage = round(random(1, 2));
  boolean multiplied;

  float speed;

  public PowerUp() {
    // loading the power up image
    powerUp = loadImage("images/powerup" + Integer.toString(powerUpImage) + ".png");
    multiplied = false;
    speed = 1.75;

    position = new PVector(random(100, 600), 0);
  }

  public void display() {
    // displaying the powerUp image
    update();
    image(powerUp, position.x, position.y, 2*radius, 2*radius);
  }

  public void update() {
    position.y += speed;
    if (position.y >= height+30)
    { 
      game.powerUps.remove(this);
    }
    if (dist(position.x, position.y, mouseX, game.spaceShip.yPosition) <= game.spaceShip.radius && multiplied == false) // duplicating the score if the player gets a powerup
    {
      // getting a powerup either increases your score 
      if (powerUpImage == 2) {
        game.score *= 2;
      } else if (powerUpImage == 1) {
        game.spaceShip.spaceShipNum++;
      }
      game.powerUpSound.play(); // playing the powerup sound
      multiplied = true; // making sure the multiplication happens only once
      game.powerUps.remove(this); // removing the powerup if it has been used
    }
  }
}

// class for the space ship with the relevant controls
class SpaceShip {
  private PImage spaceShip1, spaceShip2, spaceShip3, spaceShip4;
  int xPosition;
  int yPosition = 700;
  int radius = 40;
  int spaceShipNum = 2; // there are 4 space ships in the game this controls which is displayed

  public SpaceShip() {
    // loading the spaceship images
    spaceShip2 = loadImage("images/spaceship2.png");
    spaceShip3 = loadImage("images/spaceship3.png");
    spaceShip4 = loadImage("images/spaceship4.png");
    spaceShip1 = loadImage("images/spaceship1.png");
  }
  public void display() {
    int xPosition = mouseX;

    if (spaceShipNum%3 == 0) {
      image(spaceShip2, xPosition, yPosition, 2*radius, 2*radius);
    } else if (spaceShipNum%4 == 0) {
      image(spaceShip3, xPosition, yPosition, 2*radius, 2*radius);
    } else if (spaceShipNum%5 == 0) {
      image(spaceShip4, xPosition, yPosition, 2*radius, 2*radius);
    } else {
      image(spaceShip1, xPosition, yPosition, 2*radius, 2*radius);
    }
  }
}

class Chicken {
  private PImage chicken;
  int xPosition, yPosition, radius, posXLimit, negXLimit, bulletCount;
  float speed;


  Chicken(int xPos, int yPos) {

    chicken = loadImage("images/Chicken" + Integer.toString(round(random(1, 3))) + ".png");
    xPosition = xPos;
    yPosition = yPos;
    posXLimit = xPosition + 120; // the limit the chickens can move right
    negXLimit = xPosition - 120; // the limit the chickens can move left
    speed = 2;
    radius = 30;
  }
  public void display() {
    update();
    imageMode(CENTER);
    image(chicken, xPosition, yPosition, 2*radius, 2*radius);
  }

  public void update() {
    // updating the positions of the chicken
    if (xPosition + radius >= posXLimit || xPosition - radius <= negXLimit) {
      speed = -speed;
    }
    xPosition += speed;
  }
}

/// create powerups arraylist and when frameCount % 5400 == 0 that is every 90s then add a new powerup

// the main game class

class Game {
  boolean alive, newHighScore, soundOn, isPlaying;
  int score, screen;
  private int highScore;
  private String highScoreFile = "highScoreFile.txt"; // highScore file

  public SoundFile backgroundSound, gameOverSound, highScoreSound, powerUpSound, eggLaidSound;


  ArrayList<ArrayList<Chicken>> chickens;
  ArrayList<Egg> eggs;
  ArrayList<PowerUp> powerUps;
  Background background;
  SpaceShip spaceShip;

  public Game() {
    background = new Background();
    spaceShip = new SpaceShip();
    soundOn = true;
    alive  = true;
    isPlaying = true;
    score = 0;
    highScore = readHighScore(); // reading the current highscore
    screen = 1;
    eggs = new ArrayList<Egg>();
    powerUps = new ArrayList<PowerUp>();
    chickens = new ArrayList<ArrayList<Chicken>>();
    createChickens();
    textFont(font); // changing the text font

    // loading the sound files
    backgroundSound = new SoundFile(midtermProject.this, "sounds/backgroundSound.mp3");
    backgroundSound.loop(); // playing the background sound
    gameOverSound = new SoundFile(midtermProject.this, "sounds/gameOver.mp3");
    highScoreSound = new SoundFile(midtermProject.this, "sounds/highScore.wav");
    powerUpSound = new SoundFile(midtermProject.this, "sounds/powerUp.mp3");
    eggLaidSound = new SoundFile(midtermProject.this, "sounds/eggLaid.mp3");
  }

  public void createEggs() { // method to release the eggs
    int randomRow = round(random(0, chickens.size()-1));

    ArrayList<Chicken> currentRow = chickens.get(randomRow);

    int randomCol = round(random(0, currentRow.size()-1));

    Chicken currentChicken = currentRow.get(randomCol);

    eggs.add(new Egg(currentChicken.xPosition, currentChicken.yPosition)); // adding a new egg
    eggLaidSound.play(); // playing the egglaid sound
    eggs.add(new Egg(chickens.get(0).get(0).xPosition, chickens.get(0).get(0).xPosition)); // making eggs at the extreme left so the user cant hide
    eggs.add(new Egg(chickens.get(0).get(chickens.get(0).size()-1).xPosition, chickens.get(0).get(chickens.get(0).size()-1).xPosition)); // making eggs at the extreme right so the user cant hide
  }

  public void releaseEggs() {
    if (frameCount%60 ==0) { // making sure the will always be an egg every second
      createEggs();
      eggSpeed+=0.02;
    }
    if (frameCount%120==0 || frameCount%660 ==0 || frameCount % 300 == 0 || frameCount % 420 == 0 || frameCount % 540 == 0) { // releasing eggs every 2nd, 11th, 5th, 7th and 9th second
      createEggs();
      eggSpeed+=0.02; // increasing the egg speed
    }
  }

  public void releasePowerUps() {

    if (frameCount%2700 ==0) { // releasing powerups every 45 seconds
      powerUps.add(new PowerUp());
    }
  }
  public void createChickens() {
    // adding the chickens to a 2D ArrayList
    for (int i=0; i<7; i++) {
      chickens.add(new ArrayList<Chicken>());
      ArrayList<Chicken> chickenRow = chickens.get(i);
      for (int j=0; j<4; j++) {
        chickenRow.add(new Chicken((i+1)*90, (j+1)*90));
      }
    }
  }
  public void displayChickens() {
    // looping througn the chickens array and displaying all the chickens
    for (int i=0; i<chickens.size(); i++) {
      ArrayList<Chicken> chickenRow = chickens.get(i);
      for (int j=0; j<4; j++) {
        chickenRow.get(j).display();
      }
    }
  }
  public void showScore() {
    // displaying the score
    textAlign(RIGHT);
    fill(255);
    textSize(35);
    text("SCORE", width - 10, 35);
    textSize(28);
    text(score, width - 10, 65);
  }


  public void display() {
    background.display(); // displaying the background
    if (screen == 1) {
      textAlign(RIGHT);
      fill(255);
      textSize(34);
      text("Welcome To Chicken Invaders: Remastered", 700, 100);
      textSize(40);
      // menu buttons
      textAlign(CENTER);
      text("Start!", 350, 400);
      text("Instructions", 350, 470);
      text("Exit", 350, 530);
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
      if ((mouseX>= 227 && mouseX<=468) && (mouseY>= 435 && mouseY<=478)) { // the instructions box
        stroke(255);
        rect(220, 435, 250, 50);
        if (mousePressed) {
          screen = 3; // changing the screen
        }
      }

      if ((mouseX>= 308 && mouseX<=392) && (mouseY>= 496 && mouseY<=534)) { // theexit box
        stroke(255);
        rect(230, 490, 250, 50);
        if (mousePressed) {
          exit(); // exiting the game
        }
      }
    } else if (screen == 2) { // the play screen
      if (alive) {
        showScore(); // showing score if player is alive
        checkHighScore(); // checking the highscore

        spaceShip.display();
        displayChickens();
        releaseEggs();
        releasePowerUps();

        for (int i=0; i<eggs.size(); i++) {
          eggs.get(i).display(); // displaying the eggs
        }

        for (int i=0; i<powerUps.size(); i++) {
          powerUps.get(i).display(); // displaying the eggs
        }
      }
    } else if (screen == 3) { // the instructions screen
      textAlign(CENTER);
      textSize(38);
      text("Instructions: " + "\n\n", 380, 150);
      textSize(25);
      text("1. Avoid the falling eggs for as long as you can"+ "\n"+" to increase your scores" + "\n" +"2. Use the mouse to control the spaceship, press m/M"+ "\n"+" to mute/unmute the audio" + "and press p/P to play/pause " + "\n"+ "3. Collect powerUps to double your score"+ "\n" +" and try to beat your highScore"  + "\n" + "4. The speed of  the falling eggs increases as "+ "\n" +" the game progresses" + "\n\n"+ "IT'S HARDER THAN YOU THINK!!", 400, 190);
      text("<< Back", 350, 700);  
      // going back to the home screen when the mouse is pressed
      if ((mouseX>= 308 && mouseX<=396) && (mouseY>= 679 && mouseY<=705)) {
        stroke(255);
        rect(280, 670, 150, 40);

        if (mousePressed) {
          screen = 1; // changing the screen to the home screen
        }
      }
    } else if (screen == 4) { // game over screen
      if (score > highScore) {
        newHighScore(); // writing a new high score
      }
      textAlign(CENTER);
      textSize(50);
      text("GAME OVER!!", 380, 150);
      text("Click Anywhere to restart", 350, 600);
    }
  }// end of display method


  private void checkHighScore() {
    // if high score is beaten
    if (score > highScore) {
      textAlign(CENTER);
      textSize(35);
      text("NEW HIGH SCORE!", width / 2, 45);

      if (!newHighScore) { // playing audio if highscore has been reached
        highScoreSound.play();
        newHighScore = true;
      }
    }
  }
  // method to read the high score file
  private int readHighScore() {
    int highscore;

    // high score file object
    File file = new File(dataPath(highScoreFile));

    // read file if exists, otherwise high score is obviously 0
    if (file.exists()) {
      BufferedReader reader = createReader(dataPath(highScoreFile));
      try {
        highscore = Integer.parseInt(reader.readLine());
      }
      catch(IOException ioe) {
        highscore = 0;
      }
    } else {
      highscore = 0;
    }

    return highscore;
  }

  // method to write new high score to file in the data folder
  private void newHighScore() {
    PrintWriter writer = createWriter(dataPath(highScoreFile));
    writer.print(score);
    writer.flush();
    writer.close();
  }
}// end of the game class

PFont font; // a new font object

Game game; // the Game object
boolean soundOn;
void setup() {
  size(720, 720);
  font = createFont("ComicSansMS", 32);
  game = new Game();
  overallVolume = new Sound(midtermProject.this);
}

void draw() {
  game.display();
}

void mouseClicked() {
  if (game.alive == false && game.screen == 4) {
    game = new Game(); // creating a new game if the mouse is pressed
  }
}

void keyTyped() {
  // controlling the audio
  if ((key == 'm' || key== 'M') && game.soundOn) {
    overallVolume.volume(0); // muting the audio
    game.soundOn = false;
  } else if ((key == 'm' || key== 'M') && !game.soundOn) {
    overallVolume.volume(0.7); // unmuting the audio
    game.soundOn = true;
  }

  if ((key == 'p' || key== 'P') && game.isPlaying) {
    noLoop();
    game.isPlaying = false;
  } else if ((key == 'p' || key== 'P') && !game.isPlaying) {
    loop();
    game.isPlaying = true;
  }
}
