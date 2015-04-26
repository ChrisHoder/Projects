// FILE: SocialAgent.java
// AUTHOR: Chris Hoder
// DATE: 10/2/11
// PROJECT 03

// imports
import java.util.ArrayList;
import java.util.Random;

/*
	This class will be the socialAgents to populate the landscape in either the
	SocialSimulation or the Game of Life
*/

public class SocialAgent extends SimObject{

	//data declarations
	
	//
	private int type;
	
	
	//Methods
	
	// Constructor that creates a SocialAgent of a particular type.
	// INPUT: row,col of the location of the SocialAgent. Type of SocialAgent
	public SocialAgent( int row, int col, int type){
		// invokes the SimObject constructor
		super(row,col);
		this.type = type;
	
	}
	
	
	// this returns the type of the SocialAgent
	public int getType(){
		return this.type;
	}
	

	
	// Returns a single character representation of the type of the agent
	// returns 0-9 depending on the type
	public String toString(){
		int value = type % 10;
		return Integer.toString(value);
	}
	
	// This method will update the state of the Agent at this row,col.
	// it will get the neighbors and if the number of similar types is greater than the 
	// number of different types then the socialAgent is happy and will try to remain in place
	// but there will stll be a probability that it will change position (this probability is input
	// by the user). If a agent is an ally with another agent this only counts as 0.5 of being next
	// to a agent of the same type.
	/* PSEUDOCODE
		1. get neighbors
		2. FOR (each neighbor ) DO
			- IF ( the type is the same ) THEN
				- increment the count of like neighbors by 1
			  END
		    - IF ( the type is different ) THEN
		    	- determine if it is of ally type
		    	- IF( it is of ally type ) THEN
		    		increment count of like neighbors by 0.5
		    	   END
		      END
		    ELSE
		    	- increment the different neighbor list by 1
		    END
		 3. IF ( similar neighbors > dissimilar neighbors ) THEN
		 		- try to move to a new cell in the 9-grid neighborhood
		 		- return false
		 	ELSE
		 		- stay where you are
		 			- return true
		 		- with a probability changeProb (stored in SimObject) this element will try to move
		 			- return false
		 	END
	*/
	public boolean updateState( Landscape scape ){
		//get neighbor
		ArrayList nhbs = (ArrayList)scape.getNeighbors(this.row,this.col);
		double sameNhbs = 0;
		double diffNhbs = 0;
		//number of neighbors
		int sizeList = nhbs.size();
		// for each neighbor
		double likeNess;
		for( int i=0; i<sizeList; i++){
			int agentType = ((SocialAgent)nhbs.get(i)).getType();
			// if the agent is of the same type of this social agent
			if( (likeNess = isAlliance(scape, agentType)) > 0 ){
				sameNhbs += likeNess;
			}
			//different type than this social agent
			else{
				diffNhbs += 1;
			}
		}
		// if there are no neighbors
		if ( sizeList == 0 ) {
			moveSpot( scape );
			return false;
		}
		// more dissimilar neighbors than similar
		else if ( sameNhbs < diffNhbs ){
			moveSpot( scape );  
			return false;
		}
		// sameNhbs >= diffNhbs -- more similar
		else{
			// 5% chance of moving in this case
			if( Math.random() < changeProb ){
				moveSpot( scape );
				return false;
			}
			return true;
		}
	}
	
	// This mehtod will determine whether the given agentType is a type that is in alliance with
	// the type of this SocialAgent. the data about alliances is stored in the Landscape.
	// INPUT: Landscape of the current grid, agentType that we are comparing
	// OUTPUT: +1 if the agent is of the same type, 0.5 if it is an ally, -1 if neither
	/* PSEUDOCODE
		1. get alliance data
		2. IF( agentType is the same as this agent's type) THEN
			- return 1
		   END
		3. FOR (every alliance this type has ) DO
			- IF( agentType is one of alliance types ) THEN
				- return 0.5
			   END
		   END
		4. return -1
		
	*/
	public double isAlliance( Landscape scape, int agentType ){
		ArrayList[] alliances = scape.getAlliances();
		// if the types are the same (same neighbor)
		if(agentType == this.type){
			return 1.0;
		}
		// for every alliance this type has check to see if this agentType is one of them
		for(int i=0; i < alliances[this.type].size() ; i++ ){
			// if it is return 0.5
			if( agentType == (Integer)alliances[this.type].get(i) ){
				return 0.5;
			}
		}
		// The two types are not allies so return -1
		return -1;
	}
	
	

	// this method will try to move the SimObject to another spot in the 9 neighborhood of 
	// the simObject. it will check to see that the area around it actually exists on the grid
	//INPUT: landscape that is being played
	public void moveSpot( Landscape scape ){
		Random rand = new Random();
		Random rand2 = new Random();
		// get a random position in the 9-grid neighborhood of the cell
		// this is done the same way for both. First a random integer between 0-3 is 
		// picked then 1 is subtracted to generate a random integer betwee -1 - 1. This is
		// then added to the row or column
		int row = this.row + rand.nextInt(3) - 1;
		int col = this.col + rand2.nextInt(3) - 1;
		
		// if the row/col index is less than 0 or greater than the number of rows/cols.
		// this is out of bounds so it will not move
		if ( (row < 0) || ( row >= scape.getRows() ) || (col < 0) || ( col >= scape.getCols() ) ){
			return;
		}
		// There is a socialAgent within the grid space chosen. It cann't move then
		else if ( scape.getAgent(row, col) != null ){
			return;
		}
		// We now must have a space that is within the grid and not occupied. The socialAgent
		// will now move there and remove itself from its current location
		else{
			scape.moveAgent(row,col,this);
		}
	}


	// This method will test the methods within the socialAgent class and make sure that they work
	// appropriately.
	public static void main( String[] args ){
		SocialAgent sA = new SocialAgent(5,10,2);
		System.out.println("The type is " + sA.getType() );
		System.out.println("The row is " + sA.getRow() );
		System.out.println(" The Col is " + sA.getCol() );
		System.out.println(" the character value is " + sA.toString() );
		
		SocialAgent sA2 = new SocialAgent(2,10,1);
		SimObject.changeProb = 0.75;
		System.out.println("the Change probability is " + sA2.getChangeProb());
	
	}

}