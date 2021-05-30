// initializing the dimesions of the game
int HEIGHT = 700;
int WIDTH = 500;

// class for the evil sprite in the game
public class CovidSprite {
  float row; 
  int col;
  float speed;
  int radius;
  boolean forward;
  public PImage img;

  // constructor for the 
  public CovidSprite() {
    row = random(0, 500);
    speed = random(0.1, 1.5); // generating a random speed for the sprites
    col = round(random(0, 650)); // generating a random starting point
    radius = 20; // radius of the evil sprites
    img = loadImage("covid.png"); 
  }

  public void update() {
    if (row + 2*radius > width-50) { // changing the direction if the sprite touches the edge of the screen
      speed = -1 * speed; // making the negative of its previous value
    } else if (row - 2*radius < 50) {
      speed = -1 * speed; // negating the speed with its previous
    }
    row+=speed; // updating the row position
  }

  public void display() {
    update(); // calling the update to change the position
    image(img, row, col, 2*radius, 2*radius);// displaying the covid image
  }
}

// main game class 
public class Game {
  public PImage scopeImage; // image for target

  int score; // keeping track of the score
  int totalSprites = round(random(50, 100)); // generating a random number of total sprites

  public ArrayList<CovidSprite> evilSprite; // creating a list of all the covid sprites
  public Game() {
    score =0;
    evilSprite = new ArrayList<CovidSprite>(); // instantiating a list of all the sprites
    for (int i=0; i<totalSprites; i++) {
      evilSprite.add(new CovidSprite());
    }
  }

  public void display() {
    if (!win()) { // show sprites only if the player has not won yet

      score();
      for (int i=0; i<totalSprites; i++) {
        evilSprite.get(i).display(); // displaying all 50 sprites
      }
      scopeImage = loadImage("scope.png"); // displaying the target image

      image(scopeImage, mouseX-45, mouseY-45, 80, 80);// displaying the scope image with and offset of 45
   
    } else { 
      // displaying the win text
      textAlign(CENTER);
      fill(60, 150, 60);
      textSize(35);
      text("YOU WIN!!,\n BUT CONTINUE\n TO WEAR YOUR MASK\n AND PRACTICE SOCIAL \nDISTANCING", width/2, height/2);
    }
  }

  public void score() { // this method prints the score 
    textAlign(RIGHT);
    fill(255);
    textSize(35);
    text("SCORE", width - 10, 35);
    textSize(28);
    text(score, width - 10, 65);
  }

  public boolean win() { // this method checks to see if all the sprites have been killed
    if (totalSprites == 0)
    {
      return true;
    }
    return false;
  }
}


PImage bgImage;// backgroud image

Game game; // calling the game 
void setup() {
  game = new Game();
  bgImage = loadImage("bg.png");
  size(500, 800);
}

void draw() {
  image(bgImage, 0, 0, width, height);
  game.display(); // displaying all the parts of the game
}

void mouseClicked() {
  for (int i=0; i< game.totalSprites; i++) {
    // checking if the mouse if clicked within the covid image
    if (dist(game.evilSprite.get(i).row, game.evilSprite.get(i).col, mouseX, mouseY)<= 2*game.evilSprite.get(i).radius) {
      game.evilSprite.remove(i);
      game.totalSprites-=1;
      game.score+=1;
    }
  }
}
