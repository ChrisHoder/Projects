// FILE: Bullet.java
// AUTHOR: Chris Hoder
// DATE: 11/06/2011

/* This class will simulate the bullets being fired by the defending army at the oncoming attackers */

import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;


public class Bullet extends SimObject {

	//data declarations
	// this is the max speed that a bullet can travel at
	public static double MAX_SPEED = 10;
	// this is the target point (x,y)
	private double targetX;
	private double targetY;
	// this vector stores the directional vector (normalized ) in the following form
	// unitVector[0] is the x direction
	// unitVector[1] is the y direction
	// and unitVector[2] holds the origional magnitude (not really needed)
	private double[] unitVector;
	// this is the damage that a bullet causes when it hits an Attacker
	public static final double damage = 100;
	
	
	// This construtor creates a new bullet starting at position (x,y) and headed toward the target position (targetX,targetY)
	// INPUT: (x,y) starting position; (targetX,targetY) targetPosition
	public Bullet(double x, double y, double targetX, double targetY){
		//set initial position
		super(x,y);
		// set targetPosition
		this.targetX = targetX;
		this.targetY = targetY;
		//set directional vector
		this.unitVector = this.targetUnitVector();
	}
	
	
	// This method will update the state of the bullet and move it forward (or kill an attacker!) 
	// INPUT: landscape upon which the bullet sits
	// OUTPUT: true if the bullet is still on the landscape, false if it has gone off the end or hit an attacker
	/* PSEUDOCODE
	 * 	1. check to see if there is an Attacker in the path of the bullet (with its next position)
	 *  2. IF( the bullet hits an Attacker ) THEN
	 *  	- add damage to the Attacker
	 *  	- return false ( remove itself from the landscape)
	 *     END
	 *  3. move forward 
	 *  4. IF( the bullet is now off of the landscape ) THEN
	 *  	- return false ( remove itself from the landscape ) 
	 *     END
	 */
	 public  boolean updateState(Landscape scape){
		
		 // check to see if the bullet hit any attackers
		 Attacker victim = (Attacker)this.checkPath(scape);
		 
		
			 
		 if( victim != null){
			//bullet kills the victim
			 victim.hit(Bullet.damage);
			 // bullet is no longer on the landscape
			 return false;
		 }
		 
		
		 //if it didn't hit anything it will move forward
		 boolean moveCheck = this.move();	 
		// if moveCheck returns false then we have moved off of the landscape
		 if( moveCheck == false){
			 return false;
		 }
		 // still on the landscape return true
		 else{
			 return true; 
		 }
	 }
	 
	 
	 // This method will check the path of the Bullet between its current position and the position it will be in when it 
	 // moves forward in the given unitVector direction at the given speed. If an attacker lies in the path of the bullet, it will be hit by the bullet
	 // this will reduce the health of the attacker as well as the bullet will be removed from the landscape.
	 /* PSEUDOCODE
	  *  1. determine the x and y travel distance vector call this Travel
	  *  2. get list of attackers on the landscape
	  *  3. IF ( there are no attackers ) THEN
	  *  		- return null ( no attackers in the bullet's path
	  *     END
	  *  4. FOR ( each attacker on the landscape ) DO
	  *  	  - get the vector between the bullet's starting position and the position of the Attacker ( call this vector A)
	  *  	  - compute the length of A
	  *       - IF( xComponent of A is greater than 0 ) THEN
	  *       		- continue to next Attacker because this means the bullet has already passed the Attacker
	  *         END
	  *       - find the magnitude of the projection of A onto Travel ( given by the dotproduct(A and Travel) divided by the magnitude of Travel
	  *       - IF( the magnitude of the projection of A onto Travel is greater than the magnitude of Travel ) THEN
	  *       		- the bullet is yet to reach the Attacker
	  *       		- continue to next Attacker on the list
	  *         END
	  *       - Use pathagorean's theorem to find the distance from the Attacker to the line the bullet will take ( we have the vector from the bullet's start position to the Attacker
	  *         	and the projection of A onto Travel ( this would be the amount of A that is parallel with Travel ), so the 3rd side of the triangle is the distance of the Attacker
	  *         	from the path of the bullet
	  *       - IF ( the Attacker's distance from the path of the bullet is less than 1 ) THEN
	  *       		- The bullet will hit the Attacker ( save this this victim if it is closer than any other Attackers it will hit ) 
	  *  		END
	  *      END
	  *   5. return closest Attacker it will hit ( null if no Attacker in the path of the bullet )
	  */
	 public SimObject checkPath(Landscape scape){
		 // calculate the vector from starting position to ending position
		// double[] unitVector = this.targetUnitVector();
		 //double magnitude = this.unitVector[2];
		 // This is the vector Travel above
		 double xTravel = this.unitVector[0]*Bullet.MAX_SPEED;
		 double yTravel = this.unitVector[1]*Bullet.MAX_SPEED;
		 
		 // get the list of attackers
		 ArrayList<SimObject> attackers = (ArrayList<SimObject>) scape.getResources();
		 
		 // if there are no attackers, there is nothing for the bullet to hit
		 if(attackers.size() == 0){
			 return null;
		 }
		 
		 SimObject victim = null;
		 // arbitrarily large
		 double distanceFromStart = 9999999;
		 
		 SimObject temp;
		 // for each attacker
		 for(int i = 0; i < attackers.size() ; i++){
			 temp = attackers.get(i);
			 double xLoc = temp.getX();
			 double yLoc = temp.getY();
			 // this is the vector from the bullet's start position to the Attacker's position, (vector A above)
			 double xVector = xLoc - this.x;
			 double yVector = yLoc - this.y;
			 double length = Math.sqrt( (xVector*xVector + yVector*yVector) );
			 // if the xVector is positive then the bullet has already passed this attacker
			 if( xVector > 0){
				 continue;
			 }
			 // Take the dot product between these two vectors (A and Travel above)
			 double dotProduct = xTravel*xVector  + yTravel*yVector;
			 
			 // This is the magnitude of the projection of A onto Travel
			 double parallelMagnitude = (dotProduct/Bullet.MAX_SPEED);
			 
			 // we haven't yet gotten to this attacker on the landscape if the magnitude of the projection is greater than the magnitude of the
			 // path of the bullet
			 if( parallelMagnitude > Bullet.MAX_SPEED){
				 // this will move the for loop to the next Attacker in the list
				 continue;
			 }
			 
			 
			 //can now find the distance from the line using pathagorean's theorem, reasoning described in the pseudocode above
			 double distance = Math.sqrt( (length*length) - (parallelMagnitude*parallelMagnitude) );
			
			 // if this attacker is online with the bullet ( within 1 unit perpendicularly from the path of the bullet)
			 if(distance < 1 ){
				 // if it is closer than any other attacker in the bullet's line ( we want the bullet to hit the closest attacker not just one on it's path )
				if ( parallelMagnitude < distanceFromStart ){
					victim = temp;
					distanceFromStart = parallelMagnitude;
				}
			 }
		 }
		 
		 // return the closest Attacker in the direction of the Bullet's path (null if there is none)
		 return victim;
	 }
	 
	 // This method will move the Bullet in the given direction of it's path (unitVector) a given units based on it's speed (Bullet.MAX_SPEED)
	 // it will also check to make sure that it hasn't gone off the edge of the landscape in any way
	 // INPUT: nothing
	 // OUTPUT: boolean (true if it is still on the landscape, false if it has gone off the edge)
	 public boolean move(){
		 // move Bullet.MAX_SPEED in the direction of the unitVector
		 double newPosX= this.x + this.unitVector[0]*Bullet.MAX_SPEED;
		 double newPosY = this.y + this.unitVector[1]*Bullet.MAX_SPEED;
		 this.setPosition(newPosX, newPosY);
		 
		 // this check's the new position with the boundary conditions of the landscape, if it fails then it is of the edge
		 // and will return false
		 if ( ( this.x < 0 ) || ( this.y < 0 ) || ( this.y > Landscape.getHeight() ) ){
			 return false;
		 }
		 //still on the landscape
		 else{
			 return true;
		 }
	 }
	 
	 
	// This method will compute the unitVector in the direction of the given target point and return the vector as a double array with the following values
	//  [0] x direction component
	//  [1] y direction component
	//  [2] origional magnitude
	// INPUT: nothing
	// OUTPUT: array of doubles with the unitVector direction
	public double[] targetUnitVector(){
		// calculate the vector toward the target
		 double xDirection = (this.targetX - this.x);
		 double yDirection = (this.targetY - this.y);
		 // normalize so that its magnitude is 1
		 double normCoef = Math.sqrt((xDirection*xDirection) + (yDirection*yDirection) );
		 // create a double array to store the data
		 double[] unitVector = new double[3];
		 // normalize the components and save them
		 unitVector[0] = xDirection/normCoef;
		 unitVector[1] = yDirection/normCoef;
		 unitVector[2] = normCoef;
		 // return this unit vector
		 return unitVector;
	}
	 
	 // this method will draw the bullets, they are black ovals. 
	 public void draw(Graphics g, int x, int y, int scale){
		 g.setColor(Color.BLACK);
		 g.fillOval(x, y, (int)(scale), (int)(scale));
		 
	}
}
