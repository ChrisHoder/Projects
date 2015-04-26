// FILE: AttackSpawner.java
// AUTHOR: Chris Hoder
// DATE: 11/6/2011
// PROJECT 07

/* this class will spawn new attacker on the landscape that will try to take over the castle */

//imports
import java.awt.Graphics;
import java.util.Random;


public class AttackSpawner extends SimObject {

	//data declarations
	private static int ATTACKERS_CREATED = 5;
	// this will be the iterations left in the troop surge
	public static int surgeIterations;
	// this will be the iteration at which when the current iteration is an even multiple of this
	// number we will have a troop surge on the landscape
	public static int surgeStart;
	
	
	// constructor, takes in a position that is unimportant as this class is not drawn
	public AttackSpawner( double x, double y ){
		super(x,y);
		// initially sets the first surge for the 100th iteration
		AttackSpawner.surgeIterations = 0;
		AttackSpawner.surgeStart = 100;
	}
	
	
	// This method will return the max number of attackers that can be created
	// with each iteration
	// INPUT: nothing
	// OUTPUT: max attackers created in an iteration
	public static int getAttackersCreated(){
		return AttackSpawner.ATTACKERS_CREATED;
	}
	
	// This method will set a new max number that the spawner can create with each iteration
	// INPUT: (integer) value of the number of the max number of Attackers to be created
	// OUTPUT: nothing
	public static void setAttackersCreated(int newValue){
		AttackSpawner.ATTACKERS_CREATED = newValue;
	}
	
	
	// This method will update the state of the class, and this will spawn new attackers on the landscape
	// the number of attackers spawned will be randomly between 0 and ATTACKERS_CREATED for non surge
	// iterations. During a surge, this class will spawn between 0 and 5*ATTACKERS_CREATED. Surges last for
	// 10 iterations.
	/* PSEUDOCODE
	 * 	1. IF ( first iteration of a surge ) THEN
	 * 		 - pick the next surge iteration, between now and 300 iterations later
	 * 	 	 - start this surge ( goes for 10 iterations )
	 *     END
	 *  2. IF ( in an attack surge ) THEN
	 *  	 - decrement the number of surgeIterations left
	 *  	 - set the spawn number to between 0 and 5*ATTACKERS_CREATED
	 *     ELSE
	 *     	 - set the spawn number to between 0 and ATTACKERS_CREATED
	 *     END
	 *  3. FOR( each Attacker to create) THEN
	 *       - create a new attacker, and place it randomly along the y axis on the far left
	 *         of the landscape
	 *      END
	 *  4. Return true (always)
	 *      
	 * @see SimObject#updateState(Landscape)
	 */
	public boolean updateState(Landscape scape) {
		// checks to see if we are at the start of a attack surge (even number of surgeStart in iterations)
		if( ( Landscape.iteration % AttackSpawner.surgeStart ) == 0 ){
			// find the next surgeStart iteration number (in the next 300 iterations)
			AttackSpawner.surgeStart = (int) (Math.random()*300+1);
			// start this surge for 10 iterations
			AttackSpawner.surgeIterations = 10;
		}
		//initialize the #of spawns
		int spawn = 0;
		Random rand = new Random();
		// if we are in a surge
		if( AttackSpawner.surgeIterations > 0 ){
			//decrement the number of surge iterations left
			AttackSpawner.surgeIterations--;
			// pick a random number between 0 and 5*ATTACKERS_CREATED
			spawn = rand.nextInt(AttackSpawner.ATTACKERS_CREATED) * 5;
		}
		// not in a surge
		else{
			// pick a random number between 0 and ATTACKERS_CREATED
			spawn = rand.nextInt((int)(AttackSpawner.ATTACKERS_CREATED ));
		}
		
		// this will create the spawn number of new attackers
		double x,y;
		x = 1; 
		for( int i = 0 ; i < spawn; i++){
			// they will start at the x position of 1 and the y position will randomly be chosen between
			// 0 and the height of the landscape
			y = Math.random()*Landscape.getHeight();
			// adds attacker with the following additional properties. It will be able to inflict a random amount of damage between
			// 0 and Attacker.MAX_DAMAGE. it will have a speed between 0 and Attacker_MAX_SPEED and it will have a health between 0 and Attacker_MAX_HEALTH
			double speed = Math.random()*Attacker.MAX_SPEED;
			speed = speed < .2 ? 0.2 : speed;
			scape.addResource(new Attacker(x,y,Math.random()*Attacker.MAX_DAMAGE, Math.random()*Attacker.MAX_SPEED, Math.random()*Attacker.MAX_HEALTH));
		}
		
		//always returns true
		return true;
	}

	@Override // does nothing
	public void draw(Graphics g, int x, int y, int scale) {
		return;
	}
	
	
	
}
