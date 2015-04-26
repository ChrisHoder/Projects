// FILE: Attacker.java
// AUTHOR: Chris Hoder
// DATE: 11/6/2011
// PROJECT 07

//imports
import java.awt.Color;
import java.awt.Graphics;

/* This class will make an attacker that will sit on the landscape and move toward the 
 *  castle and try to destroy it when it gets close
 */

public class Attacker extends SimObject {
	
	//data declarations
	// speed at which it is traveling
	private double speed;
	// health the attacker has
	private double health;
	// amount of damage the attacker can do in 1 iteration on the castle
	private double damageAbility;
	// max damage an attacker can be able to cause on the Castle
	public static final double MAX_DAMAGE = .1;
	// max health that the attacker can have
	public static final int MAX_HEALTH = 100;
	// this is the max speed that the attacker can move
	public static final double MAX_SPEED = 1.5;
	
	
	
	// This constructor takes in the starting position of the Attacker and the amount of damage
	// the Attacker can do on the castle
	// INPUT: (x,y) position and the amount of damage the attacker can do (doubles)
	// OUTPUT: nothing
	public Attacker(double x, double y, double damageAbility, double speed, double health){
		super(x,y);
		// check to make sure the input health is not above our MAX_HEALTH
		if( health < Attacker.MAX_HEALTH){
			this.health = health;
		}
		else{
			this.health = Attacker.MAX_HEALTH;
		}
		
		// check to make sure that our input speed is not above the MAX_SPEED
		if( speed < Attacker.MAX_SPEED){
			this.speed = speed;
		}
		else{
			this.speed = Attacker.MAX_SPEED;
		}
		
		// check to make sure that our input damage is not above the MAX_DAMAGE
		if( damageAbility < Attacker.MAX_DAMAGE){
			this.damageAbility = damageAbility;
		}
		else{
			this.damageAbility = Attacker.MAX_DAMAGE;
		}
	}
	
	
	// This method will reduce the health of the attacker by the input amount, damage
	// INPUT: double damage
	// OUTPUT: nothing
	public void hit(double damage){
		// if the damage is more than the health, just set the health to 0
		if ( (this.health - damage) < 0){
			this.health = 0;
		}
		// otherwise decrement the health by the damage
		else{
			this.health = this.health - damage;
		}
	}
	
	// This method will update the state of the Attacker. First it will check to see if this Attacker
	// has been killed by a bullet. Then it will check to see if it is within 2 units from the castle.
	// if it is it won't move but will instead attack the castle with its its given amount of damage.
	// If the attacker is alive and further than 2 units from the castle it will move with its given speed
	// toward the castle ( Attackers move linearly)
	// INPUT: Landscape upon which the attacker sits
	// OUTPUT: false if Attacker is dead, true if it is still alive
	/* PSEUDOCODE
	 *  1. IF ( health is less than 0 ) THEN
	 *  	- Attacker is dead, return false
	 *     END
	 *  2. IF ( Attacker is within 2 units from the castle ) THEN
	 *   	- attack the castle with given damageAbility
	 *     ELSE
	 *     	- move toward the castle with given speed
	 *     END
	 *  3. return true (alive)
	 */
	 public  boolean updateState(Landscape scape){
		 // check to see if this Attacker is still alive
		 if( this.health <= 0){
			 // if it is dead, increment the killed counter
			 scape.incrementKilled();
			 // return false because it needs to be removed from the list of attackers
			 return false;
		 }
		 
		 // get the castle's location and check to see how close we are
		 Castle castle = ( Castle )scape.getCastle();
		 // since they move linearly ony the x magnitude matters
		 double xCastle = castle.getX();
		 // attack the castle
		 if( (xCastle - this.x) < 2){
			 //attack the castle
			 castle.attack(this.damageAbility);
		 }
		 // further than 2 units from the castle, we need to move closer
		 else{
			 this.move(scape);
		 }
		 // always return true when still alive
		 return true; 
	 }

	 
	 
	 // This method will move the Attacker on the landscape. it will move it linearly in the x-direction
	 // with the given speed ( data field)
	 // INPUT: landscape upon which the Attacker sits
	 // OUTPUT: nothing
	 public void move(Landscape scape){
		 SimObject c = scape.getCastle();
		 // find out our location relative to the Castle, we need to know the castle's position
		 double xCastle = c.getX();
		 
		 // If moving a full speed amount puts us past the castle, move to 1 unit before the castle
		 // (in attacking zone )
		 if( ( this.x + this.speed ) > xCastle ) {
			 this.x = xCastle - 1;
		 }
		 // otherwise move at full speed toward the castle
		 else{
			 this.x = this.x + this.speed;
		 }
	 }
	 
	 
	 // This method will draw the Attacker on the display, additionally, the transparency
	 // of the Attacker depends on proporiton of this attackers health to the MAX_HEALTH
	 public void draw(Graphics g, int x, int y, int scale){
		 // set the transparency dependent on the percentage of health compared to the MAX_HEALTH
		 // an attacker could have
		 double saturate =  ( this.health / Attacker.MAX_HEALTH ) * (double)255;
		 // check to make sure that the saturate value isn't too low
		 saturate = saturate < 25 ? (double)25 : saturate;
		 g.setColor(new Color(255,0,0,(int)saturate));
		 g.fillRect(x, y, scale, scale);
		 
	}
}
