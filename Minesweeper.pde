import de.bezier.guido.*;
public static final int NUM_ROWS = 20;
public static final int NUM_COLS = 20;
public final static int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int nRows = 0; nRows < NUM_ROWS; nRows++)
        for(int nCols = 0; nCols < NUM_COLS; nCols++)
            buttons[nRows][nCols] = new MSButton(nRows,nCols);
    setBombs();
}
public void setBombs()
{
    for(int b = 0; b < NUM_BOMBS; b++)
    {
        int bRow = (int)(Math.random()*NUM_ROWS);
        int bCol = (int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[bRow][bCol]))
            bombs.add(buttons[bRow][bCol]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() && gameOver == false)
    {
        gameOver = true;
        displayWinningMessage();
    }
}
public boolean isWon()
{
    for(int i = 0; i < bombs.size(); i++)
        if (!bombs.get(i).isMarked())
            return false;
    return true;
}
public void displayLosingMessage()
{
    for(int i = 0; i < bombs.size(); i++)
        if(bombs.get(i).isMarked() == false)
            bombs.get(i).clicked = true; //fix this
    buttons[200][200].setLabel("You Lose!");
    gameOver = true;
}
public void displayWinningMessage()
{
    buttons[200][200].setLabel("You Win!");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        if (gameOver == false)
        {
            if (mouseButton == LEFT && marked == false)
                clicked = true;
            if (mouseButton == RIGHT && clicked == false)
                marked = !marked;
            else if (bombs.contains( this ) && marked == false)
                displayLosingMessage();
            else
                for (int i = -1; i <= 1; i++)
                    for (int j = -1; j <= 1; j++)
                        if (isValid(r+i, c+j) && !buttons[r+i][c+j].isClicked())
                            buttons[r+i][c+j].mousePressed();
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
            return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for (int i = -1; i <= 1; i++)
            for (int j = -1; j <= 1; j++)
                if (isValid(row+i, col+j) && bombs.contains(buttons[row+i][col+j]))
                    numBombs++;
        return numBombs;
    }
}



