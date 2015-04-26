// FILE: Army.java
// AUTHOR: Chris Hoder
// DATE: 11/06/2011
// PROJECT 07

//imports
import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;

/* This class will simulate the defending army of the castle */

public class Army extends SimObject {
	
	// data declarations

	// this is the maximum health that an army soldier can have
	private static final int MAX_HEALTH = 100;
	// this is the health of a particular Army instance
	private int health;
	// this is the probability that the soldier will change posiitions behind the castle
	private static double changeProb = 0.03;
	
	
	// Constructor that sets the position of the army soldier
	public Army( double x, double y){
		super(x,y);
		this.health = Army.MAX_HEALTH;
		
	}
	
	// This method will set the changeProbability data field
	// INPUT: new changeProbability (double)
	// OUTPUT: nothing
	public static void setChangeProb(double newProb){
		Army.changeProb = newProb;
	}
	
	
	// This method will find the closest attacker in the list of attackers on the landscape (resources). It will do this by finding the magnitude of the vector
	// between them.
	// INPUT: Landscape upon which to play
	// OUTPUT: SimObject that is closest to this Army soldier
	/* PSEUDOCODE
	 *   1. get list of Attackers
	 *   2. IF ( no attackers) THEN
	 *       - return null
	 *      END
	 *   3. FOR ( each attacker ) DO
	 *   	 - compute the distance it is from this army object
	 *     	 - if it is closest attacker yet, save it
	 *       END
	 *   4. return closest attacker ( as a SimObject)  
	 */
	public SimObject getClosestAttacker(Landscape scape){
		// get the list of attackers from the landscape
		ArrayList<SimObject> attackers = (ArrayList<SimObject>) scape.getResources();
		// if there are no attackers currently, return null
		if( attackers.size() == 0){
			return null;
		}
		
		//get the first attacker and set it as the current closest attacker ( initialize, base case)
		SimObject soldier = attackers.get(0);
		double minDistance = this.distanceFromTarget(soldier);
		SimObject temp;
		// for each attacker, see if its distance to this army object is the new closest, if it is then save it.
		// index starts at 1 because we already initialized our stored object and distance
		for(int i = 1 ; i < attackers.size() ; i++){
			temp = attackers.get(i);
			double distance = this.distanceFromTarget(temp);
			// if this is the closest Attacker yet, save it
			if( distance < minDistance ){
				minDistance = distance;
				soldier = temp;
			}
			
		}
		// return the pointer to the closest SimObject of the Attackers
		return soldier;
	}
	
	
	// This method will fire a bullet at the given (xLoc,yLoc) on the landscape
	// INPUT: point upon which to aim toward (xLoc,yLoc) and landscape to simulate on
	public void fireBullet(double xLoc, double yLoc, Landscape scape){
		// create a new bullet being fired from this position (x,y) and aimed at (xLoc,yLoc)
		Bullet b = new Bullet(this.x, this.y, xLoc,yLoc);
		// add this bullet to the landscape
		scape.addBullet(b);
	}
	
	// This method will compute the distance from this object to the object o. The distance
	// will be returned as a double
	// INPUT: SimObject o
	// OUTPUT: distance from o (double)
	public double distanceFromTarget(SimObject o){
		double x = o.getX();
		double y = o.getY();
		// get the vector distance (xDistance, yDistance)
		double xDistance = this.x - x;
		double yDistance = this.y - y;
		// use r^2 = x^2 + y^2 to find the magnitude of this vector 
		double radius = xDistance*xDistance + yDistance*yDistance;
		return Math.sqrt(radius);
	}
	
	
	// This method will update the state of this Army object. It will first check to see if it is still alive. if it is not it will return false. Then if it is alive it will
	// increase its health, if the object is not already at MAX_HEALTH. The army will then find the closest attacker and fire a bullet in the direction of that.
	// INPUT: Landscape we are playing on
	// OUTPUT: boolean (true if still alive, false if dead)
	/* PSEUDOCODE
	 * 	1. IF ( health is less than 0 ) THEN
	 * 		- army is dead, return false
	 *     END
	 *  2. IF ( health not at MAX_HEALTH ) THEN
	 *  	- increment health
	 *     END
	 *  3. Find closest attacker
	 *  4. launch a bullet in the direction of this attacker
	 *  5. IF ( random number is less than the changeProb ) THEN
	 *  	- change position to a new random position behind the castle wall
	 *     END
	 *  6. return true
	 */
	 public  boolean updateState(Landscape scape){
		 // if this army soldier is dead
		 if( this.health <= 0){
			 return false;
		 }
		 //if the soldier isn't dead it will update the health if it isn't at max health. If it isn't it will
		 // increment it's health
		 if ( ( this.health + 1 ) < Army.MAX_HEALTH){
			 this.health++;
		 }
		 // set to max health
		 else {
			 this.health = Army.MAX_HEALTH;
		 }
		 
		 //get closestattacker to know where to aim the bullet it will fire
		 SimObject attacker = this.getClosestAttacker(scape);
		 // if there are no Attackers to fire at, don't fire a bullet and done updating state
		 if(attacker == null){
			 return true;
		 }
		 //get the location of this attacker
		 double xLoc = attacker.getX();
		 double yLoc = attacker.getY();
		 
		 //launch new bullet at this attacker
		 this.fireBullet(xLoc,yLoc, scape);

		 
		 //small probability of changing positions after firing a shot
		 if( Math.random() < Army.changeProb){
			 //move to a random position behind the castle
			 double maxX = Landscape.getWidth();
			 double minX = scape.getCastle().getX();
			 double yNew = Math.random()*Landscape.getHeight();
			 // new x position has to be between the castle and the far right of the landscape. So pick a random number that is betweeen 0 and the difference between (maxX-minX)
			 // and then add that to the xPosition of the Castle.
			 double xNew = (scape.getCastle().getX()) + Math.random()*(maxX - minX-3) + 3 ;
			 // set the new position
			 this.setPosition(xNew, yNew);
		 }
		 
		 // this method will always return true if the soldier isn't dead
		 return true; 
	 }

	 // This method will draw the Army object on the landscape as a basic blue oval.
	 public void draw(Graphics g, int x, int y, int scale){
		 g.setColor(Color.BLUE);
		 g.fillOval(x, y, scale*2, scale*2);
	
		 
	}
}
