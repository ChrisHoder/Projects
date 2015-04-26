// FILE: Cell.java
// AUTHOR: Chris Hoder
// DATE: 10/16/2011
// PROJECT 04

// imports
import java.util.ArrayList;
import java.util.Random;
import java.util.List;
import java.awt.Color;
import java.awt.Graphics;


/* This class is used for the Game of Life Simulation on the HarvestSimulation landscape baord
 * it will extend the SimObject class
 */

public class Cell extends SimObject{
	
	//data declarations
	private boolean alive;
	
	// Constructor that will set its position and whether or not it is alive or not
	public Cell(double x, double y, boolean alive){
		super(x,y);
		this.alive = alive;
	}
	
	
	// This method will set whether the cell is alive or dead, true == alive
	// INPUT: boolean alive status
	public void setAlive( boolean state){
		this.alive = state;;
	}
	
	
	// This method will return whether the cell is alive. True == alive
	public boolean isAlive(){
		return this.alive;
	}
	
	// This method will return a character representation of the cell. a 1 means alive, 0 means dead
	public String toString(){
		if( this.alive){
			return "1";
		}
		else{
			return "0";
		}
	}
	
	// This method will return a copy of the cell as another SimObject
	public SimObject copyObject(){
		Cell temp = new Cell(this.x,this.y,this.alive);
		return temp;
	}
	

	// This method will update the state of the Cell. The way that this works is that when it goes to get
	// neighbors it will get them from a second stored array list of the Cells in the landscape and not
	// from the active linked list stored in the landscape. This way the updates are all happnening simultaneously
	// This method is very slow compared to previous project versions, making it not the best simulation
	public boolean updateState(Landscape scape){
			// get a list containing the Cells that neighbor this cell
			ArrayList nhbs = new ArrayList();
			nhbs = ( ArrayList ) scape.getCellsNear(this.x, this.y);
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
					this.alive = true;
					return true;
				}
				// otherwise it dies
				else{
					this.alive = false;
					return true;
				}
			 
			}
			// if the cell is dead this time, it needs exactly 3 alive neighbors to be
			// alive in the next round
			else {
				if( aliveNhbs == 3 ){
					this.alive = true;
					return true;
				}
				// otherwise it remains dead
				else{
					this.alive = false;
					return true;
				}
			
			}
			
		}
	
	
		// this method will draw itself on the landscape
		public void draw(Graphics g, int x, int y, int scale){
			
			// if it is alive it should be black and visible
			if( this.alive){
				g.setColor( new Color(0,0,0,254) );
			}
			else{
				// a dead cell will not be visible on the landscape (alpha value = 0 which means transparent)
				g.setColor( new Color(0,0,0,0) );
			}
			g.fillOval(x, y, scale, scale);
		}
	
		// This function will test the capabilities of the Cell class.
		public static void main( String[] args ){
			Cell c = new Cell(2,3,true);
			System.out.println("A new cell was created with x:" + c.getX() + " and y " + 
				c.getY() + " and the cell alive? " + c.isAlive());
			System.out.println("The string value is " + c.toString());
		
			System.out.println("The x is changed to 9, the y to 10 and the alive is set to false");
			c.setPosition(9,10);
			c.setAlive(false);
			
			System.out.println("the cell now has x:" + c.getX() + " and y " + 
				c.getY() + " and the cell alive? " + c.isAlive());
			System.out.println("The string value is " + c.toString());
		}

	
}