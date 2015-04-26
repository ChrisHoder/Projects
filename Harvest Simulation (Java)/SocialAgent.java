// FILE: SocialAgent.java
// AUTHOR: Chris Hoder
// DATE: 10/16/11
// PROJECT 04

// imports
import java.util.ArrayList;
import java.util.Random;
import java.util.List;
import java.awt.Color;
import java.awt.Graphics;

/*
	This class will be the socialAgents to populate the landscape in either the
	SocialSimulation
*/

public class SocialAgent extends SimObject{

	//data declarations
	
	private int type;
	public static double changeProb = 0.05;
	// this will store all the alliances between the different types
	public static ArrayList[] alliance;
	// this stores the different colors for the different types
	private static final Color[] colors  = {
			//Black RGB
			new Color(0, 0, 0),
			//medium Blue RGB
			new Color(0, 0, 205),
			// Yellow RGB
			new Color(255,255,0),
			//Green RGB
			new Color(0,100,0),
			//Orange
			new Color(255,165,0),
			//RED
			new Color(255,0,0)
			
			};


	
	//Methods
	
	// Constructor that creates a SocialAgent of a particular type.
	// INPUT: row,col of the location of the SocialAgent. Type of SocialAgent
	public SocialAgent( double x, double y, int type){
		// invokes the SimObject constructor
		super(x,y);
		this.type = type;
	
	}
	
	// This method will set the alliances for all the types
	public static void setAlliance( ArrayList[] alliances){
		SocialAgent.alliance = alliances;
	}
	
	// this returns the type of the SocialAgent
	public int getType(){
		return this.type;
	}
	

	// this method will get the changeProbab double
	 public static double getChangeProb(){
		 return SocialAgent.changeProb;
	 }
	 
	 // this method will set the changeProb double
	 public void setChangeProb(double prob){
		 SocialAgent.changeProb = prob;
	 }
	
	// Returns a single character representation of the type of the agent
	// returns 0-9 depending on the type
	public String toString(){
		int value = type % 10;
		return Integer.toString(value);
	}
	
	// This method returns a copy of the SocialAgent as a SimObject
	public SimObject copyObject(){
		SocialAgent temp = new SocialAgent(this.x,this.y,this.type);
		return temp;
	}
	
	
	// This method creaates an initial alliances array so that every SocialAgent type is 
	// allied with itself.
	// INPUT: number of types in the simulation
	// OUTPUT: nothing
	/* PSEUDOCODE
	 * 	1. FOR (each type) DO
	 * 		- add its own type to its alliance list
	 *  END
	 */
	public static void initializeAlliances(int types){
		SocialAgent.alliance = new ArrayList[types];
		//for each element in the array (each element corresponds to a type of the 
		// same index (i.e. alliance[0] are the  allys for type 0
		for( int j = 0; j < types ; j++){
			SocialAgent.alliance[j] = new ArrayList();
			SocialAgent.alliance[j].add(new Integer(j));
		}
	}
	
	// This method will update the state of the Agent at this x,y.
	// it will get the neighbors and if the number of similar types is greater than the 
	// number of different types then the socialAgent is happy and will try to remain in place
	// but there will stll be a probability that it will change position (this probability is input
	// by the user). If a agent is an ally with another agent this only counts as 0.5 of being next
	// to a agent of the same type. It will always return true ( they do not die )
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
		//get neighbors
		ArrayList nhbs = ( ArrayList )scape.getSocialAgentsNear(this.x,this.x);
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
			moveSpot( scape , nhbs );
			return true;
		}
		// more dissimilar neighbors than similar
		else if ( sameNhbs < diffNhbs ){
			moveSpot( scape , nhbs );  
			return true;
		}
		// sameNhbs >= diffNhbs -- more similar
		else{
			// 5% chance of moving in this case
			if( Math.random() < SocialAgent.changeProb ){
				moveSpot( scape , nhbs );
				return true;
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
		// if the types are the same (same neighbor)
		if(agentType == this.type){
			return 1.0;
		}
		// for every alliance this type has check to see if this agentType is one of them
		for(int i=0; i < SocialAgent.alliance[this.type].size() ; i++ ){
			// if it is return 0.5
			if( agentType == (Integer)SocialAgent.alliance[this.type].get(i) ){
				return 0.5;
			}
		}
		// The two types are not allies so return -1
		return -1;
	}
	
	

	// this method will try to move the SimObject to another spot in the 9 neighborhood of 
	// the simObject. it will check to see that the area around it actually exists on the grid
	//INPUT: landscape that is being played, list of the nhbs
	public void moveSpot( Landscape scape , List nhbs ){
		Random rand = new Random();
		Random rand2 = new Random();
		// get a random position in the 9-grid neighborhood of the cell
		// this is done the same way for both. First a random integer between 0-3 is 
		// picked then 1 is subtracted to generate a random integer betwee -1 - 1. This is
		// then added to the row or column
		int xNew = (int) (this.x + rand.nextInt(3) - 1);
		int yNew = (int) (this.y + rand2.nextInt(3) - 1);
		
		// if the row/col index is less than 0 or greater than the number of rows/cols.
		// this is out of bounds so it will not move
		if ( (xNew < 0) || ( xNew >= scape.getWidth() ) || (yNew < 0) || ( yNew >= scape.getHeight()) ) {
			return;
		}
		// There is a socialAgent within the grid space chosen. It cann't move then
		else if ( checkNhbs(nhbs, (double) xNew,(double) yNew) == false ){
			return;
		}
		// We now must have a space that is within the grid and not occupied. The socialAgent
		// will now move there and remove itself from its current location
		else{
			this.x =(double) xNew;
			this.y =(double) yNew;
			
		}
	}

	// This function checks all the neighbors of the SimObject and returns false if
	// a SimObject in the nhbs list is occupying the given x,y location that is given
	// returns true if the location is empty
	// INPUT: list of nhbs,  position (x,y) as doubles
	// OUTPUT: true if the move location is empty, false if it is occupied
	/* PSEUDOCODE
	 * 	1. FOR ( each neighbor ) DO
	 * 		- check to see if it is in the given x,y position
	 * 		IF ( it is in the position x,y) THEN
	 * 			- return false
	 * 		END
	 * 	  END
	 *  2. return ture
	 */
	private boolean checkNhbs(List nhbs, double x, double y){
		ArrayList nhb = ( ArrayList )nhbs;
		for ( int i=0; i < nhb.size(); i++){
			SimObject temp = ( SimObject )nhb.get(i);
			if ( (temp.getX() == x ) && ( temp.getY() == y ) ){
				return false;
			}
		}
		return true;
		
	}
	

	// This method will draw itself on the graphics g
	public void draw(Graphics g, int x, int y, int scale){
		// Determine the color this object is based on the colors saved in the class
		g.setColor(SocialAgent.colors[this.type % (colors.length)]);
		g.fillOval(x, y, scale, scale);
	}

	// This method will test the methods within the socialAgent class and make sure that they work
	// appropriately.
	public static void main( String[] args ){
		SocialAgent sA = new SocialAgent(5,10,2);
		System.out.println("The type is " + sA.getType() );
		System.out.println("The x is " + sA.getX() );
		System.out.println(" The y is " + sA.getY() );
		System.out.println(" the character value is " + sA.toString() );
		
		SocialAgent sA2 = new SocialAgent(2,10,1);
		SocialAgent.changeProb = 0.75;
		System.out.println("the Change probability is " + SocialAgent.changeProb);
	
	}

}