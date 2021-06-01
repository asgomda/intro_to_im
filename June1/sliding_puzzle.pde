/*
Name: Abdul Samad Gomda
 Date: 1 June 2021
 Version: 1.0
 Description: A sliding puzzle game. To play click on the desired tile to move it
 */

// an array of all the neighboring tile distance units

int[][] neighbors = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};

final int NUM_ROWS = 4;
final int NUM_COLS = 4;
final int RESOLUTION = 800; // the screen size
final int squareSize = RESOLUTION / 4; // the length of a tile

// class that creates tiles
class Tile {
  // attributes for the row, column and value of a tile
  int row, col, val;
  PImage img;

  // constructor for the tile class
  Tile(int _row, int _col) {
    row = _row;
    col = _col;
    val = row * NUM_ROWS + col; // the value ranges from 1-16 depending on the row and column since it is displayed as a grid
    img = loadImage("images/" + Integer.toString(val) + ".png");
  }

  void display() { // method to display the tiles, the sixteeneth tile is left blank to enable swapping of tiles
    if (val != 15)
    {
      image(img, col * squareSize, row * squareSize, squareSize, squareSize); // displaying the image

      // giving each image a black boarder 
      noFill();
      strokeWeight(5);
      stroke(0);
      rect(col * squareSize, row * squareSize, squareSize, squareSize);
    }
  }

  void swap(Tile swapTile) { // swapping the image and the value while maintaining the row and column
    int swapVal; // temporary variable for the value
    PImage swapImg; // temporary variable for the 

    swapVal = val;
    swapImg = img;
    val = swapTile.val;
    img = swapTile.img;
    swapTile.val = swapVal;
    swapTile.img = swapImg;
  }
} // end of the tile class definition


// class to control the puzzle
class Puzzle {

  ArrayList<Tile> allTiles = new ArrayList<Tile>(); // array to store all the tiles

  Puzzle() { // constructor for the puzzle class
    // loading the puzzle images 
 
    for (int r=0; r<NUM_ROWS; r++) {
      for (int c =0; c<NUM_COLS; c++) {
        allTiles.add(new Tile(r, c));
      }
    }
    shuffle(); // calling the shuffle method to shuffle the tiles
  }

  void showTiles() {

    if (!win()) {
      for (int i = 0; i< allTiles.size(); i++) {
        allTiles.get(i).display();

        // making the mouse highlight the boarder
        int mouseR = mouseY/(squareSize); // getting the particular row the mouse is at
        int mouseC = mouseX/(squareSize); // getting the particular column the mouse is at

        strokeWeight(5);
        stroke(0, 200, 0);
        noFill();
        rect(mouseC *  squareSize, mouseR * squareSize, squareSize, squareSize); // drawing the rectangle relative to the row and column
      }
    } else {

      // displaying the win text
      textAlign(CENTER);
      fill(60, 150, 60);
      textSize(35);
      text("YOU WIN!!", width/2, height/2);
    }
  }
  Tile getTile(int _row, int _col) { // a method to return a tile if found
    for (int i=0; i< allTiles.size(); i++) {
      if (allTiles.get(i).row == _row && allTiles.get(i).col == _col)
      {
        return allTiles.get(i);
      }
    }
    return null;// returning null if the tile is not found
  }

  void shuffle() {
    // getting the empty tile

    Tile emptyTile = getTile(NUM_ROWS-1, NUM_COLS-1);

    int degreeOfShuffle = round(random(2, 15)); // setting the number of times to shuffle to a random number

    for (int i = 0; i<=degreeOfShuffle; i++)
    {
      Tile nextTile = null; // initializing the next tile
      while (nextTile == null) { // iterating as long as the nextTile does not exist
        int randIndex = round(random(3));
        int[] next = neighbors[randIndex]; // getting a random neighbor to swap with
        nextTile = getTile(emptyTile.row + next[0], emptyTile.col + next[1]);
      }

      // swapping the next tile and the empty tile
      emptyTile.swap(nextTile);
      emptyTile = nextTile;// setting the empty tile to the new position
    }
  }

  void mouseClickAction() {

    int mouseR = mouseY/(squareSize); // getting the particular row the mouse is at
    int mouseC = mouseX/(squareSize); // getting the particular column the mouse is at
   
    Tile currentTile = getTile(mouseR, mouseC);

    // iterating through the neighbors and swapping with the valid positions that are next to the empty tile
    for (int i =0; i< NUM_ROWS; i++)
    {
      int[] next = neighbors[i];
      Tile neighborTile = getTile(mouseR + next[0], mouseC + next[1]);
      if (neighborTile != null && neighborTile.val == 15) {
        currentTile.swap(neighborTile); // swapping the positions of the current and empty tile
      }
    }
  }
  boolean win() {
    // checking if all the tiles are in the right places
    for (int i = 0; i< allTiles.size(); i++) {
      if (allTiles.get(i).row * NUM_ROWS + allTiles.get(i).col != allTiles.get(i).val) {
        return false;
      }
    }
    return true;
  }
}



Puzzle puzzle; 

void setup() {
  size(800, 800);
  puzzle = new  Puzzle();

  background(0, 0, 0);
}

void draw() {
  background(0, 0, 0);
  puzzle.showTiles();
}

void mouseClicked() {
  puzzle.mouseClickAction();
}
