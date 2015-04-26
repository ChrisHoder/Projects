// FILE: Landscape.java
// AUTHOR: Chris Hoder
// DATE: 10/2/2011
// PROJECT 03



//inports
import java.util.ArrayList;
import java.io.IOException;
import java.util.Random;
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;
import java.io.IOException;

/*
	Landscape for the SocialSimulation or Game of Life.
	contains methods for manipulating the game and advancing it.
*/
public class Landscape {

	//data declarations
	
	// The 2D array of cells on the landscape
	private SimObject[][] grid;
	
	//Alliances data
	private ArrayList[] alliance;
	
	
	//This function creates the Landscape of size (rows,cols). Initializes all cells to have no 
	//life (calls reset())
	// INPUT: number of rows in the grid, number of columns in the grid
	public Landscape(int rows, int cols){
		this.grid = new SimObject[rows][cols];
	}






	// This constructor will create the landscape outlined in the text file that is given
	// given as the pathname (variable path). The text file should have on the first line
	// the rows and cols
	// and all of the next lines should have a picture of the grid desired with
	// null for a dead cell and a Social agent of type 0 for a live cell
	// INPUT: path to text file with landscape
	/* Pseudocode
		1. Read data from the text file
		2. determine the number of rows and columns in the grid
		3. IF ( INCORRECT NUMBER OF COL or ROWS ) THEN
			- create a generic board
		4. FOR (each row of the grid) DO
			FOR ( each cell in the given row) DO
				 - determine whether the cell is alive or not (character is a ' ' or a '0')
				 IF( alive) THEN
				 	- create a SocialAgent of type 0 in this spot
				 ELSE
				 	- make this space in the grid null
				 END
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
			this.grid = new SimObject[20][80];
		}
		// otherwise, create the grid
		else{
			this.grid = new SimObject[rows][cols];
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
						this.grid[i-1][j] = new SocialAgent(i-1,j,0);
					}
					else{
						this.grid[i-1][j] = null;
					}
				}
		
			}
		
		}
		}
		
		

	// This method will initialize the alliances data variable based on the number of
	// types of socialAgents there are going to be.
	public void initialzeAlliances(int types){
		this.alliance = new ArrayList[types];
		// for each element in the array(each element corresponds to a type of the 
		// same index (i.e alliances[0] are the allys for type 0
		for( int j = 0; j < types ; j++ ){
			this.alliance[j] = new ArrayList();
			this.alliance[j].add(new Integer(j));			
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
	

	
	// This function will return a String representing the life state of all cells in the
	// landscape. each row is a new line
	// INPUT: nothing
	// OUTPUT: String -- the grid
	public String toString(){

		String result = "\n";
		// for each element in the grid
		for ( int i=0; i < this.grid.length; i++ ){
			for ( int j = 0; j< this.grid[0].length; j++){
				// if there is a SimObject in the spot
				if (this.grid[i][j] != null){
					result += this.grid[i][j].toString();
				}
				// if their is no simObject, make it a space in the string
				else{
					result += " ";
				}
			}	
			result += "\n";
		}
		return result;
	}
	


	
	// This will set the alliances data
	public void setAlliances(ArrayList[] alliances){
		this.alliance = alliances;
		}
	
	
	// this will return the alliances data
	public ArrayList[] getAlliances(){
		return this.alliance;
	}

		
	// This function will return the object at position (row,col)
	// INPUT: row, col of object desired
	// OUTPUT: SimObject at (row,col)
	public SimObject getAgent(int row, int col){
		if( grid[row][col] == null ){
			return null;
		}
		return grid[row][col];
	}


	// This function will place a SimObject at position (row,col) and sets the
	// position on the SimObject
	// INPUT: row, col to place the given SimObject at
	// OUTPUT: void
	void setAgent(int row, int col, SimObject agent){
		agent.setPosition(row,col);
		this.grid[row][col] = agent;
		
	
	}
	
	// This funcion will move a SimObject from its current position to a new position
	// at (row,col). The position within the SimObject will also be updated
	// INPUT: row, col to move the SimObject agent to
	// OUTPUT: void
	public void moveAgent(int row, int col, SimObject agent){
		//get the position it was at
		int rowOld = agent.getRow(); 
		int colOld = agent.getCol();
		// dereference the pointer in the grid to this old position
		grid[rowOld][colOld] = null;
		// set the agent to be at the new position given as (row,col)
		setAgent(row,col,agent);
	}
	
	// This function will return a list of references to the cells that are adjacent
	// or diagonal to the cell at position (row,col). This is a list of 8 cells except for
	// edge cases. 
	// INPUT: row, col of cell
	// OUTPUT: Arraylist as a List object of cells that are the cell's neighbors
	/*   Pseudocode
		1. For ( the neighbors of the given cell )
			- Check to make sure neighbor exists 
			- save neighbor cell to an List
		2. Return list of neighbor cells
	
	
	*/
	public List getNeighbors(int row, int col){

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
				if ( ( j < 0 ) || ( j >= getCols() ) ){
					continue;
				}
				else if ( ((i==row) && (j==col)) ){
					continue;
				}
				else{
					SimObject sO;
					// if the space isn't null then add it to the List
					if ( (sO = getAgent(i,j)) != null ){
						nhbs.add(sO);
					}
					}
			}
		}
		//return the List
		return nhbs;	
	}	
	
	
	
	
	// This method will advance the landscape when it is the SocialSimulation mode
	// It does not do the advancement of each cell in parallel like in the Game of Life.
	// Instead, each element in the grid is updated in a random order, one by one
	/* PSEUDOCODE
		1. Get all the SimObjects in the grid as a LinkedList
		2. FOR( each element in the list of SimObjects) DO
			- randomly choose a SimObject in the List
			- advance its state
		   END
	*/
	public void advance(){
		// get a linked list of all the SimObjects	
		LinkedList gridList = (LinkedList)toLinkedList();
		Random rand = new Random();
		// How many simObjects there are
		int listSize = gridList.size();
		// This will be the index of the chosen SimObject
		int index;
		SimObject sO;
		// This for loop will always pick a random number between 1 and the index of the
		// last element in the list
		for( int i = listSize ; i > 0 ; i-- ){
			index = rand.nextInt(i);
			// get this simObject
			sO = (SimObject)gridList.remove(index);
			//update its state.
			sO.updateState(this);
		}
	}
	
	// This method will advance the Game of Life version of the game
	// Since every dead cell in this version is just a null spot on the grid, when we call
	// get neighbors the size of the list returned will be equal to the number of alive
	// neighbors that the cell has, therefore we do not need an updateState method for the SimObject
	/* PSEUDOCODE
		1. Create new grid of SimObjects of the same size
		2. FOR( every element in the landscape ) DO
			- get neighbors
			- IF( a dead cell ) THEN
				IF ( exactly 3 alive neighbors ) THEN
					- this element is alive next round - create a SocialAgent in this spot
					   on the new grid of type 0.
				ELSE
					- leave this grid element equal to null
				END
			  END
			- IF ( a live cell ) THEN
				IF ( either 2 or 3 alive neighbors ) THEN
					- this element is alive next round - create a Social Agent of type 0 in this
					  spot in the new grid
				ELSE
					- leave this grid element null
				END
			 END
		3. set the new grid as the data saved in the object
	*/
	public void advanceLifeSim(){
		ArrayList nhbs;
		SimObject[][] grid2 = new SimObject[getRows()][getCols()];
		// loop through all the cells in the grid. assumes to be square, null cell = dead
		for( int i = 0; i< grid2.length; i++){
			for( int j=0; j<grid2[0].length; j++){
				// since a dead cell is simply null, the size of the nhbs arrayList will be the
				// same as the number of alive neighbors. we don't need to call updatestate.
				nhbs = (ArrayList)getNeighbors(i,j);
				if( grid[i][j] == null ){
					if( nhbs.size() == 3 ){
						grid2[i][j] = new SocialAgent(i,j,0);
					}
				}
				else{
					if( (nhbs.size() == 2) || ( nhbs.size() == 3 ) ){
						grid2[i][j] = new SocialAgent(i,j,0);
					}
				
				}
			
			}
		
		}
		
		this.grid = grid2;
		
	}
	
	
	
	// This method will create a linked list of all the SimObjects in the grid. 
	// OUTPUT: List (linked list) containing all of the SimObjects on the grid
	/* PSEUDOCODE
		1. FOR ( every element in the grid ) DO
			- IF (there is a SimObject in the element) THEN
				- add this SimObject to the LinkedList
			  END
		   END
		2. Return the LinkedList
	*/
	public List toLinkedList(){
		//create a linkedList to hold all of the simObjects
		LinkedList gridList = new LinkedList();
		// for every cell in the grid
		for( int i = 0; i < getRows(); i++ ){
			for( int j = 0; j < getCols(); j++){
				SimObject sO;
				// if the SimObject is not null, then add this simObject to the 
				// linked list
				if( (sO = getAgent(i,j)) != null){
					gridList.add(sO);
				}
			
			}
		
		}
		return gridList;
	}
	
	

	// This function will test the capabilities of the landscape function.
	// It will test all the functions and make sure that the methods return the appropriate values
	// and test a few edge cases that were tested in the writing of this program
	public static void main( String[] args ) throws IOException{
		Landscape L = new Landscape(20,80);
		System.out.println("rows " + L.getRows() + "  cols " + L.getCols());
		
		
		// 	this will initialize the board with a density of 0.25 and 4 different types
		double density = 1;
		int types = 4;
		Random rand = new Random();
			for( int i = 0; i < L.getRows() ; i++ ){
				for( int j = 0; j< L.getCols(); j++){
					if( Math.random() <= density){
						//determine which type of cell to create (randomly)
						int type = rand.nextInt(types);
						SocialAgent sA = new SocialAgent(i,j,type);
						L.setAgent(i,j,sA);
					}
					
				}
			
			}
		// this will initialize the Alliances with everything an ally with itself
		L.initialzeAlliances(types);
		// print out the grid
		System.out.println(L.toString());
	
		//add a new agent
		SocialAgent sA = new SocialAgent(1,2,3);
		L.setAgent(1,2,sA);
		// get the same agent
		SocialAgent sA2 = (SocialAgent)L.getAgent(1,2);
		// print out the type
		System.out.println("the value of this agent is " + sA2.getType());
		//move the agent
		L.moveAgent(15,50,sA2);
		// check to make sure it was moved and the old spot is null
		if ( L.getAgent(1,2) == null ){
			System.out.println("the old spot is now null! worked correctly");
		}
		// run for 10 iterations and print each one out
		for( int i =0 ; i<10; i++){
			L.advance();
			System.out.println(L.toString());
		}
		
		//test the  Game of Life simulation (not a lot of testing on this because it
		// involves mainly reused code from Project 02
		L = new Landscape("./Patterns/Pulsar.txt");
		// print out the board (should be the pulsar) and then advance and print again
		System.out.println(L.toString());
		L.advanceLifeSim();
		System.out.println(L.toString());
	}
	
	}