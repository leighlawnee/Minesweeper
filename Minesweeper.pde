import de.bezier.guido.*;
public int NUM_ROWS = 25;
public int NUM_COLS = 25;
public int NUM_MINES =80;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    
    for(int r=0;r<NUM_ROWS;r++)
      for(int c=0;c<NUM_COLS;c++)
        buttons[r][c]= new MSButton(r, c);

    for(int i = 0; i<NUM_MINES; i++){
    setMines();
    }
    
    for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c ++) {
      buttons[r][c].setLabel(countMines(r, c));
    }
  }
    
    
}
public void setMines()
{

   int r = (int)(Math.random()*NUM_ROWS);
   int c = (int)(Math.random()*NUM_COLS);
   if(mines.contains(buttons[r][c]) == false){
     mines.add(buttons[r][c]);
  }
  
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon() {
  int untouchedMines = 0;
  int countMarkedButtons = 0;
  
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c ++) {
      if(buttons[r][c].clicked == false && mines.contains(buttons[r][c]) == true)
        untouchedMines++;
    
      if(buttons[r][c].clicked == true && mines.contains(buttons[r][c]) == false)
        countMarkedButtons ++;
    
  }
  }
  if(untouchedMines == mines.size() && countMarkedButtons == (NUM_ROWS*NUM_COLS - mines.size())){
    return true;
  }else{
    return false;
  }
  
}

public void displayLosingMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c ++) {
      buttons[r][c].clicked = true;
    }
  }
   buttons[width/2][height/2].setLabel("You Lose");
}
public void displayWinningMessage()
{
   buttons[width/2][height/2].setLabel("You Win");
}
public boolean isValid(int r, int c)
{
   if ((r>= 0 && r<NUM_ROWS && c<NUM_COLS && c>=0))
return true;
else
    return false;
}
public int countMines(int row, int col)
{
 int numMines = 0;
  if (isValid(row-1, col-1) && mines.contains(buttons[row-1][col-1])) 
    numMines++;
  if (isValid(row-1, col) && mines.contains(buttons[row-1][col]))
    numMines++;
  if (isValid(row-1, col+1) && mines.contains(buttons[row-1][col+1]))
    numMines++;
  if (isValid(row, col-1) && mines.contains(buttons[row][col-1]))
    numMines++;
  if (isValid(row, col+1) && mines.contains(buttons[row][col+1]))
    numMines++;
  if (isValid(row+1, col-1) && mines.contains(buttons[row+1][col-1]))
    numMines++;
  if (isValid(row+1, col) && mines.contains(buttons[row+1][col]))
    numMines++;
  if (isValid(row+1, col+1) && mines.contains(buttons[row+1][col+1]))
    numMines++;    
    
    return numMines;
}
  

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
         clicked = true;
    if (mouseButton == RIGHT) {
      if (flagged == true) {
        flagged = false;
      } else {
        flagged = true;
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else {
      if (isValid(myRow, myCol-1) && buttons[myRow][myCol-1].clicked == false && mines.contains(buttons[myRow][myCol-1]) == false && buttons[myRow][myCol].myLabel == "") { //left
        buttons[myRow][myCol-1].mousePressed();
      }
      if (isValid(myRow, myCol+1) && buttons[myRow][myCol+1].clicked== false&& mines.contains(buttons[myRow][myCol+1]) == false && buttons[myRow][myCol].myLabel == "") { //right
        buttons[myRow][myCol+1].mousePressed();
      }
      if (isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked== false&& mines.contains(buttons[myRow-1][myCol]) == false && buttons[myRow][myCol].myLabel == "") { // up
        buttons[myRow-1][myCol].mousePressed();
      }
      if (isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked== false&& mines.contains(buttons[myRow+1][myCol]) == false && buttons[myRow][myCol].myLabel == "") { //down
        buttons[myRow+1][myCol].mousePressed();
      }}
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        if(clicked == true)
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
         if(newLabel == 0){
      myLabel = "";
    }else{
    myLabel = ""+ newLabel;
  }
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
