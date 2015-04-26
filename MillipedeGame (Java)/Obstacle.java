// FILE: Obstacle.java
// AUTHOR: Chris Hoder
// DATE: 11/22/2011
// PROJECT 09

import java.awt.Color;
import java.awt.Graphics;

/**
 * This class models the Obstacles in the Millipede game
 * @author chris
 *
 */
public class Obstacle extends SimObject{
	
	//data declarations
	/**
	 * Damage points
	 */
	public static final int DAMAGE_POINT = 1;

	/**
	 * Destroy points
	 */
	public static final int DESTROY_POINT = 2;
	/**
	 * Health of this obstacle instance
	 */
	double health;
	/**
	 * Max health an Obstacle can hold
	 */
	public static final double O_MAX_HEALTH = 500;

	public Obstacle(double x, double y) {
		super(x, y);
		// health is initially the max possible
		health = Obstacle.O_MAX_HEALTH;
	}

	/**
	 * The Obstacle has been hit! Decrement it's health by the input damage amount
	 * @param damage - amount to decrement the health
	 */
	public void hit( double damage ){
		// check to see that the health doesn't go below 0.
		this.health = (this.health - damage) < 0 ? 0 : (this.health - damage);
		// update point totals
		if( this.health > 0){
			MillipedeGame.score += Obstacle.DAMAGE_POINT;
		}
		else{
			MillipedeGame.score += Obstacle.DESTROY_POINT;
		}
	}
	
	/**
	 * returns 0 as the string representation of the Obstacle
	 * @return the string "0"
	 */
	public String toString(){
		return "0";
	}
	
	
	
	@Override
	/**
	 * This method updates the state of the Obstacle. It simply checks to see if it's health is greater than 0. if it isn't it will
	 * be removed from the game
	 * @param scape - Landscape being played on
	 * @return true if health is greater than 0, false otherwise
	 */
	public boolean updateState(Landscape scape) {
		if( this.health <= 0){
			return false;
		}
		return true;
	}

	@Override
	/**
	 * Draws the Obstacle on the given graphics. It will be a green square. The
	 * transparency of the obstacle depends on it's health
	 */
	public void draw(Graphics g, int x, int y, int scale) {
		// transparency is defendant on the amount of health.
		double saturate = ( this.health / Obstacle.O_MAX_HEALTH) * ( double)255;
		// make sure it doesn't get too transparent
		saturate = saturate < 25 ? (double)25 : saturate;
		g.setColor(new Color(0,255,0, (int)saturate));
		g.fillRect(x, y, scale, scale);	
	}
	
	/**
	 * Tests class
	 * @param args - not used
	 */
	public static void main(String[] args){
		Obstacle c = new Obstacle(10.0, 20.0);
		System.out.println(c.health);
		c.hit(100);
		System.out.println(c.health);
	}

}
