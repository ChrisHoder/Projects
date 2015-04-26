// FILE: Bullet.java
// AUTHOR: Chris Hoder
// DATE: 11/22/2011
// PROJECT 09

import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;

/**
 * This class will create the bullet that the Defender will shoot in the Millipede game
 * @author chris
 *
 */
public class Bullet extends SimObject {

	//data declarations
	/**
	 * travel speed of the bullet
	 */
	static final double B_SPEED  = 9;
	/**
	 * damage th bullet can cause
	 */
	static final double B_DAMAGE = 100;
	
	
	/**
	 * Boolean telling us whether the bullet is still
	 * active on the landscape
	 */
	boolean isAlive;
	
	/**
	 * Constructor that creates the bullet at the given (x,y) position
	 * @param x - x position of the bullet
	 * @param y - y position of the bullet
	 */
	public Bullet(double x, double y) {
		// bullets have a width of B_WIDTH and a height of B_HEIGHT
		super(x,y);
		//super(x, y,Bullet.B_WIDTH,Bullet.B_HEIGHT);
		// bullet is initially active on the field
		this.isAlive = true;
	}


	/**
	 * Updates the state of the bullet on the Landscape. It will check
	 * to see if the bullet hits any simObjects, if it does it will damage that simObject
	 * otherwise it will move one unit up toward the top.
	 * @param scape the Landscape being played on
	 */
	public boolean updateState(Landscape scape) {
		// if the Bullet is still alive
		if( this.isAlive ){
			// check to see if there is an obstacle(millipede or Obstacle in the path of the bullet
			SimObject obstacle = checkPath(scape);
			// returned null so there was nothing in it's path
			if( obstacle == null){
				// free to move
				this.isAlive = move();
			}
			// something was in the way of the bullet, it hit something
			else{
				// set to dead, bullets cannot travel through objects
				this.isAlive = false;
				
				// if we hit a Millipede
				if( obstacle instanceof Millipede){
					Millipede mp = (Millipede)obstacle;
					// kill the millipede
					mp.kill();
				}
				// otherwise we hit an Obstacle
				else{
					// hit the obstacle with the damage the bullet can cause
					Obstacle o = (Obstacle)obstacle;
					o.hit(Bullet.B_DAMAGE);
				}
			}
		}
		// this returns the state of the bullet
		return this.isAlive;
	}

	
	/**
	 * This method will check the path of the bullet and see if it hits any 
	 * SimObjects in the way. If it does it will Return the simObject that it hit.
	 * <p>
	 * It can hit two different types of SimObjects, the millipede or an obstacle on the landscape
	 * @return SimObject the bullet hit
	 */
	public SimObject checkPath(Landscape scape){
		// this will hold data as to the closest object the bullet is about to hit
		SimObject closestHit = null;
		
		// for each Obstacle, find out what is closest
		ArrayList<SimObject> obs = (ArrayList<SimObject>)scape.getAgents();
		for ( int i = 0 ; i < obs.size() ; i ++ ){
			// get the Obstacle
			SimObject temp = obs.get(i);
			// this method will compare it to the closestHit at this point
			closestHit = checkForHit(closestHit, temp);
		}
		
		// check the Millipede's and see if any of them are closer than the closestHit
		ArrayList<SimObjectList> obs2 = scape.getResources();
		// for each section of the millipede
		for ( int i = 0 ; i < obs2.size(); i ++ ){
			// for each element in each section of the millipede
			for ( int j = 0 ; j < obs2.get(i).size(); j ++ ){
				SimObject temp = obs2.get(i).get(j);
				// compare this Millipede element to the closestHit
				closestHit = checkForHit(closestHit,temp);
			}
		}
		// return the closestHit (null if it didn't hit anything, otherwise contains the closest
		// object the bullet is going to hit)
		return closestHit;	
	}
	
	

	/**
	 * This method will check the test SimObject to see if it is going to be hit by 
	 * the bullet and if it is closer than the closestHit SimObject, it will return whichever
	 * is closer.
	 * @param closestHit - SimObject that is currently the closest to the start of the bullet's path
	 * @param test - SimObject to test and see if it will be hit by the bullet and is closer than ClosesstHit
	 * @return simObject that is closer between the two of them
	 */
	private SimObject checkForHit(SimObject closestHit, SimObject test){
		// tests to see if it is within a given error bound of the x location of the bullet's location
		if( test.getX() <= this.x + .5 && test.getX() >= this.x-.5){
			// if it hits (i.e it's y location is in the path of the bullet), then check if it is the closest object the bullet would hit
			if ( test.getY() <= this.y && test.getY() >= (this.y -Bullet.B_SPEED ) ){
				// if this is the first element to be found that the bullet will hit
				if( closestHit == null){
					closestHit = test;
				}
				//look to see if it is a closer hit
				else{
					if( test.getY() >= closestHit.getY() ){
						// this test SimObject is closer than the closestHit object to reassign closestHit
						closestHit = test;
					}
				}
			}
		}
		
		// return the closer of the two simObjects (if both aren't null)
		return closestHit;
	}
	
	
	/**
	 * This method will move the bullet in the vertical direction up the landscape by
	 * a given B_SPEED amount
	 * @return  returns false if it goes off the board, true otherwise
	 */
	public boolean move(){
		// check to see if it goes off the board
		if( this.y - Bullet.B_SPEED < 0 ){
			this.y = 0;
			// off the board, now dead
			return false;
		}
		// otherwise moves
		else{
			this.y -= Bullet.B_SPEED;
		}
		// still on the board
		return true;
	}
	
	@Override
	/**
	 * This method will draw the Bullet on the display. it will be an upwards
	 * Arrow that is red.
	 */
	public void draw(Graphics g, int x, int y, int scale) {
		g.setColor(Color.red);
		//draws an upward arrow key
		String str = "\u2191";
		char[] strChr = str.toCharArray();
		g.drawChars(strChr,0,strChr.length,x,y);
		
	}
	
	/**
	 * Test class methods
	 * @param args - not used
	 */
	public static void main(String[] args){
		Bullet b = new Bullet(10,10);
		System.out.println("x position:" + b.getX() + " y position: " + b.getY());
		b.move();
		System.out.println("x position:" + b.getX() + " y position: " + b.getY());
		
		
		
	}

}
