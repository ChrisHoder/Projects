// FILE: Landscape.java
// AUTHOR: Chris Hoder
// DATE: 9/25/2011
// PROJECT 02

// Make sure to note that we did this so that there is a 0 column and a 0 row. This
// means that the total number of rows and cols is actually row+1 col+1

import java.util.ArrayList;
import java.io.IOException;

public class Landscape {

	//data declarations
	
	// The 2D array of cells on the landscape
	private Cell[][] grid;
	
	//This function creates the Landscape of size (rows,cols). Initializes all cells to have no 
	//life (calls reset())
	// INPUT: number of rows in the grid, number of columns in the grid
	public Landscape(int rows, int cols){
		this.grid = new Cell[rows][cols];
		reset();
	}






	// This constructor will create the landscape outlined in the text file that is given
	// given as the pathname (variable path). The text file should have on the first line
	// the rows and cols
	// and all of the next lines should have a picture of the grid desired with
	// a space for a dead cell and a 0 for a live cell
	// INPUT: path to text file with landscape
	/* Pseudocode
		1. Read data from the text file
		2. determine the number of rows and columns in the grid
		3. IF ( INCORRECT NUMBER OF COL or ROWS ) THEN
			- create a generic board
		4. FOR (each row of the grid) DO
			FOR ( each cell in the given row) DO
				 - determine whether the cell is alive or not (character is a ' ' or a '0')
			END	 
		   END
	*/
	public Landscape(String path) throws IOException{
		// load the text file into an array of strings
		ReadFile rf = new ReadFile(path);
		String[] fileData = rf.openFile();
		int rows = 0;
		int cols = 0;
		// the first line should hold the row and columns for the grid
		String[] gameInfo = fileData[0].split(" ");
		rows = Integer.parseInt(gameInfo[0]);
		cols = Integer.parseInt(gameInfo[1]);
		// if either the rows or columns is less than 0 this makes no sense and a generic
		// game will be started
		if( (rows < 0) || (cols<0)){
			System.out.println("Bad file format! Creating a normal game");
			this.grid = new Cell[20][80];
			reset();
		}
		// otherwise, create the grid
		else{
			this.grid = new Cell[rows][cols];
			char[] cellLife;
			// loop through every row/line
			for(int i = 1; i< (rows+1); i++){
				// convert the string that is the line to an array of characters
				cellLife = fileData[i].toCharArray();
				// for each character in the row (i.e. up until the number of columns indicated
				// on teh first line
				for( int j=0; j< cols; j++){
					// if the character is '0' it is alive, otherwise dead
					if( cellLife[j] == '0'){
						this.grid[i-1][j] = new Cell(i-1,j,true);
					}
					else{
						this.grid[i-1][j] = new Cell(i-1,j,false);
					}
				}
		
			}
		
		}
		}


	// This function initializes all cells on the landscape. life set to false (dead)
	// INPUT: nothing
	// OUTPUT: nothing
	/* pseudocode
		1. FOR ( every cell in the grid ) DO
				- create a new cell object with these coordinates and dead
			END
		2. return nothing
	*/
	public void reset(){
		//Loops through all cells in the grid. Assumes to be square when finding lengths
		for ( int i=0; i<this.grid.length ; i++){
			for (int j=0; j<this.grid[0].length; j++){
				grid[i][j] = new Cell(i,j,false);
			}
		}
	}


	// This function will return the number of rows on the Landscape
	// INPUT: nothing
	// OUTPUT: number of rows in the grid
	public int getRows(){
		return this.grid.length;
	}

	// This function will return the number of columns. The grid is assumed to be square
	// INPUT: nothing
	// OUTPUT: number of columns in the grid
	public int getCols(){
		return this.grid[0].length;
	}
	
	// This function will return a reference to the cell at the given location
	// INPUT: cell location
	// OUTPUT: Cell object
	public Cell getCell(int row, int col){
		return this.grid[row][col];
	}
	
	// This function will return a String representing the life state of all cells in the
	// landscape. each row is a new line
	// INPUT: nothing
	// OUTPUT: String -- the grid
	public String toString(){

		String result = "\n";
		for ( int i=0; i < this.grid.length; i++ ){
			for ( int j = 0; j< this.grid[0].length; j++){
				result += this.grid[i][j].toString();
			}	
			result += "\n";
		}
		return result;
	}
	
	// This function will return a list of references to the cells that are adjacent
	// or diagonal to the cell at position (row,col). This is a list of 8 cells except for
	// edge cases. 
	// INPUT: row, col of cell
	// OUTPUT: Arraylist of cells that are the cell's neighbors
	/*   Pseudocode
		1. For ( the neighbors of the given cell )
			- Check to make sure neighbor exists 
			- save neighbor cell to an List
		2. Return list of neighbor cells
	
	
	*/
	public ArrayList getNeighbors(int row, int col){

		ArrayList nhbs = new ArrayList();
		//go through each row
		for( int i=(row-1); i<=(row+1); i++){
			//test to see if it is higher than the top row (row index <0)
			// or if this is after the last row ( row index > row Length )
			if( (i < 0) || ( i >= getRows())){
				// skip this row
				continue;
			}

			//for each column
			for( int j=(col-1);j<=(col+1);j++){
				// test if this is before the first column (col index <0)
				// or if it is after the last column ( col index > col length )
				// Also if cell (i,j) is the cell we are talking about, skip it
				// i.e. (i,j) == (row,col)
				if ( ( j < 0 ) || ( j >= getCols() )){
					continue;
				}
				else if ( ((i==row) && (j==col)) ){
					continue;
				}
				else{
//					System.out.println("getting the row "  + i + " col " + j);
					Cell c;
					c = getCell(i,j);
//					System.out.println("status is " + c.isAlive());
					nhbs.add(c); 
					}
			}
		}
		return nhbs;	
	}	
	
	// This function will advance the landscape one round
	/* 	Pseudocode
		1. create new grid
		2. FOR ( each cell ) DO
			- find neighbors
			- determine if alive next round
		   END
		3. save new grid
	*/
	public void advance(){
		ArrayList nhbs;
		boolean status;
		
		Cell[][] grid2 = new Cell[getRows()][getCols()];
		//Loops through all cells in the grid. Assumes to be square when finding lengths
		for ( int i=0 ; i<grid2.length ; i++){
			for (int j=0 ; j<grid2[0].length ; j++){
				//nhbs = getNeighbors(i,j);
				status = grid[i][j].updateState(this);
				grid2[i][j] = new Cell(i,j,status);
			}
		}
		this.grid = grid2;
	}
	

	// This function will test the capabilities of the landscape function.
	// It will test all the functions and make sure that the methods return the appropriate values
	// and test a few edge cases that were tested in the writing of this program
	public static void main( String[] args ) throws IOException{
		// this will load the glider grid (20x80);
		Landscape L = new Landscape("./Patterns/Glider.txt");
		System.out.println(" The size of the grid is: rows: " + L.getRows() + " cols: " +
																				L.getCols());
																				
		String grid = L.toString();
		System.out.println(grid);
		System.out.println("bottom");
		ArrayList a = new ArrayList();
		// get all the neighbors of the cell at position 6,28
		a  = L.getNeighbors(6,28);
		// get the size of the Cell. should be 8
		System.out.println(a.size());
		// display all the neighbors
		for( int i=0;i<8;i++){
			System.out.println(" the cell in Col" +((Cell)a.get(i)).getCol() + " and the row " + 
									((Cell)a.get(i)).getRow() + " Alive status is " + 
									((Cell)a.get(i)).isAlive());
		
		}
		// print whether the cell we got is alive				
		System.out.println( ((Cell)L.getCell(6,28)).isAlive());
		L.advance();
		System.out.println("\n\n advanced one move \n\n" + L.toString() + "\n\n");
		
		// now going to test some edge cases of the getNeighbors method
		//also test the other landscape constructor
		Landscape LS = new Landscape(20,80);
		System.out.println(LS.toString());
		a = new ArrayList();
		// should have a size 3
		a = LS.getNeighbors(0,0);
		System.out.println(a.size());
		// should have a size 5
		a = LS.getNeighbors(5,0);
		System.out.println(a.size());
		// should have a size 8
		a = LS.getNeighbors(10,10);
		System.out.println(a.size());
 		
	}
	
	}