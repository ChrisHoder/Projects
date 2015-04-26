// FILE: Cell.java
// AUTHOR: Chris Hoder
// DATE: 9/25/2011
// Project 02


import java.util.ArrayList;



public class Cell {

	//data declarations
	
	//row that this cell occupies
	private int row;
	//column that this cell occupies
	private int col;
	//indicates whether a cell contains life or not (true == life)
	private boolean alive;
	
	
	// This constructor creates a cell with position (row,col) and live state alive
	// INPUT: Cell position: row, col as integers and a boolean alive status (true == alive)	
	public Cell(int row, int col, boolean alive){
		this.row = row;
		this. col = col;
		this.alive = alive;
	}
	
	//This function will set the cells position to the input (row,col). no output
	public void setPosition(int rows, int cols){
		this.row = rows;
		this.col = cols;
	}
	
	//This function will return the cell's row. takes no input
	public int getRow(){
		return this.row;
	}
	
	//This function will return the cell's column. takes no input
	public int getCol(){
		return this.col;
	}
	
	//This function will set whether the cell contains life depending on the input
	// input true == alive. input false == dead
	public  void setAlive( boolean state ){
		this.alive = state;
	}
	
	//This function will return whether the cell contains life or not.
	// a return of true == alive. a return of false == dead
	public boolean isAlive() {
		return this.alive;
	}
	
	//This funciton returns a one-character string that indicates the life state of the Cell
	// '0' if it contains life, ' ' if it does not.
	public String toString(){
		if (this.alive){
			return "0";
		}
		else{
			return " ";
		}
	}
	
	
	// This function will determine whether the Cell lcoation will be alive or not during the 
	// next generation. The cell will find its neighbors on the landscape
	// A return value of true means that it will be alive in the next state
	// false means dead
	public boolean updateState(Landscape scape){
		// get a list containing the Cells that neighbor this cell
		ArrayList nhbs = new ArrayList();
		nhbs = scape.getNeighbors(this.row, this.col);
		// FOR each neighbor
		// 	- if it is alive, update a count of alive neighbors
		int aliveNhbs = 0;
		for( int i = 0; i < nhbs.size(); i++){
		 	if( (( Cell )nhbs.get(i)).isAlive() ){
		 		aliveNhbs = aliveNhbs + 1;
		 	}
		}
		// If the cell is alive
		if ( alive ) {
			// if there are exactly 2 or 3 alive neighbors, the cell will be alive
			// in the next round
			if( ( aliveNhbs == 2 ) || ( aliveNhbs == 3 ) ){
				return true;
			}
			// otherwise it dies
			else{
				return false;
			}
		 
		}
		// if the cell is dead this time, it needs exactly 3 alive neighbors to be
		// alive in the next round
		else {
			if( aliveNhbs == 3 ){
				return true;
			}
			// otherwise it remains dead
			else{
				return false;
			}
		
		}
		
	}
	
	// This function will test the capabilities of the Cell class.
	public static void main( String[] args ){
		Cell c = new Cell(2,3,true);
		System.out.println("A new cell was created with row:" + c.getRow() + " and column " + 
			c.getCol() + " and the cell alive? " + c.isAlive());
		System.out.println("The string value is " + c.toString());
	
		System.out.println("The row is changed to 9, the col to 10 and the alive is set to false");
		c.setPosition(9,10);
		c.setAlive(false);
		
		System.out.println("the cell now has row:" + c.getRow() + " and column " + 
			c.getCol() + " and the cell alive? " + c.isAlive());
		System.out.println("The string value is " + c.toString());
	}


}