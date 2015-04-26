// FILE: Millipede.java
// AUTHOR: Chris Hoder
// DATE: 11/22/2011
// PROJECT 09


import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;

/**
 * This class holds the data for each individual millipede segment. 
 * @author chris
 *
 */
public class Millipede extends SimObject {
	//data declarations
	
	/**
	 * points for killing a millipede
	 */
	public static final int M_KILL_POINTS = 10;
	
	/**
	 * Max speed that the Millipede can travel at. 
	 * <p> 
	 * Caution if you reset this to more than 1. there
	 * may be issues at the edges of the landscape
	 */
	private static double M_MAX_SPEED = 1;
	
	/**
	 * Max vertical speed when switching direction.
	 */
	private static double M_VERTICAL_STEP = 1;
	
	/**
	 * Enum of the direction that the Millipede is traveling in. LEFT or RIGHT
	 * @author chris
	 *
	 */
	private enum DIRECTION { RIGHT, LEFT };
	
	/**
	 * This is the direction that a given Millipede is travelling in
	 */
	private  DIRECTION direction;
	
	/**
	 * enum of the Vertical motion the Millipede is travelling in. UP or DOWN
	 * @author chris
	 *
	 */
	private enum MOTION { UP, DOWN };
	
	/**
	 * This holds the direction that each particular Millipede is heading in.
	 * UP means that it is moving up the board. DOWN means moving down the board.
	 */
	private MOTION motion;
	
	/**
	 * Boolean of whether the Millipede is alive or not
	 * True means that it is, false it is dead.
	 */
	private boolean isAlive;
	
	/**
	 * This constructor method creates a Millipede at the given position (x,y).
	 * The direction will initially be right and down and it will be alive.
	 * @param x - x location of the Millipede
	 * @param y - y location of the Millipede
	 */
	public Millipede( double x , double y){
		// set position
		super(x,y);
		// set direction,motion and isAlive to defaults
		this.direction = DIRECTION.RIGHT;
		this.motion = MOTION.DOWN;
		this.isAlive = true;
		
	}
	
	/**
	 * This kills the Millipede segment, i.e. sets isAlive field
	 * to false
	 */
	public void kill(){
		this.isAlive = false;
		MillipedeGame.score += Millipede.M_KILL_POINTS;
	}
	
	/**
	 * This returns a string representation of the 
	 * Millipede object. This just returns the string
	 * value of it's x position
	 * @return x position as a string
	 */
	public String toString(){
		return "" + this.x;
	}
	
	/**
	 * This returns whether the Millipede is alive
	 * @return true if alive, false otherwise
	 */
	public boolean isAlive(){
		return this.isAlive;
	}
	

	@Override
	/**
	 * This method updates the state of the Millipede object. It will first check to see if it is alive. If it is not it
	 * will return false. otherwise it does the following:
	 * <p>
	 * It will check to see if there are any obstacles in the way or if it is about to hit either side of the 
	 * landscapes edges. If it is free to move it will keep moving in the direction it was headed (given by the direction
	 * data field).
	 * <p>
	 * If there is a obstacle or the landscape edge in the way it will move vertically and reverse directions. For simplicity
	 * in the code it can overlap an Obstacle element here on the landscape. (this is similar to the game in some
	 * implementations, see: http://www.atari.com/play/atari/millipede). Different Millipede's can overlap, although this
	 * should never happen. If the millipede has moved to the top
	 * of the landscape it will reverse directions and head down. Likewise if the millipede has reached the bottom it will
	 * start to climb back up the landscape/
	 * @param scape - Landscape upon which the game is being played
	 * @return false if dead, true otherwise
	 */
	public boolean updateState( Landscape scape ) {
		// if the Millipede is dead, return false immediately
		if(!isAlive ){
			return false;
		}
		// check to see if there are any obstacles in the way
		boolean check = checkMove(scape);
		// check to see if there is an edge of the landscape in the way
		boolean boundary = checkBoundary(scape);
		// if there is nothing in the way, continue in the same direction
		if( check == true && boundary == true ){
			double move = 0;
			// move in the direction we were headed
			move = this.direction == DIRECTION.LEFT ? -Millipede.M_MAX_SPEED : Millipede.M_MAX_SPEED;
			this.x += move;
		}
		// Something is in the way, move vertically
		else {
			// move in the vertical by given by the field motion.
			double move = this.motion == MOTION.DOWN ? Millipede.M_VERTICAL_STEP : -Millipede.M_VERTICAL_STEP;
			this.y = this.y + move;
			// if we are at the bottom, we will now start to move up
			if( this.y == scape.getHeight()-1 ){
				this.motion = MOTION.UP;
			}
			// if we are at the top we will now start to move down
			else if( this.y == 1 ){
				this.motion = MOTION.DOWN;
			}
			// now that we have moved down/up we need to change directions, change the direction field
			this.direction = this.direction == DIRECTION.LEFT ? DIRECTION.RIGHT : DIRECTION.LEFT;
		}
		
		// return true if we are still alive
		return true;
	}

	/**
	 * This method checks to see if the Millipede element has reached the edge of the landscape going in either direction
	 * it will return false if the Millipede is trying to move off of the landscape
	 * @param scape Landscape the game is being played on
	 * @return true if the Millipede is free to move, false if it is at an edge of the Landscape
	 */
	private boolean checkBoundary(Landscape scape){
		// moving left
		if( this.direction == DIRECTION.LEFT){
			// would move off the left end
			if( this.x-Millipede.M_MAX_SPEED < 0 ){
				return false;
			}
		}
		if( this.direction == DIRECTION.RIGHT){
			// would move off the right end
			if( (this.x+Millipede.M_MAX_SPEED) >= scape.getWidth()){
				return false;
			}
		}
		// free to move with respect to the Landscape edges
		return true;
	}

	/**
	 * This method will check to see if there are any obstacles in the path of the 
	 * millipede. If there are obstacles in the way it will return false
	 * @param scape - landscape we are playing on
	 * @return false if there is an obstacle in the way, true otherwise
	 */
	private boolean checkMove(Landscape scape){
		ArrayList<SimObject> obstacles = (ArrayList<SimObject>)scape.getAgents();
		// for each obstacle
		for ( int i = 0 ; i < obstacles.size() ; i++ ){
			SimObject temp = obstacles.get(i);
			// if going left see if it will hit an obstacle
			if( this.direction == DIRECTION.LEFT){
				// if this obstacle sits in the direction of motion
				if( ( temp.getX() <= this.x ) && temp.getX() >= (x-Millipede.M_MAX_SPEED) 
						&& temp.getY() == this.y){
					// it is in the way , so return false
					return false;
				}
			}
			// if we are going right, see if it will hit an obstacle
			else{
				if( (temp.getX() >= this.x && temp.getX() <= (x + Millipede.M_MAX_SPEED )) && 
						temp.getY() == this.y){
					return false;
				}
			
			}
		}
		// doesn't hit any of the obstacles, continue in it's way, return true
		return true;
	}
	
	@Override
	/**
	 * This method will draw the Millipede object as a yellow oval.
	 */
	public void draw(Graphics g, int x, int y, int scale) {
		g.setColor(Color.YELLOW);
		g.fillOval(x, y, scale, scale);
		
	}
	
	/**
	 * Checks the class
	 * @param args - not used
	 */
	public static void main( String[] args){
		Millipede m = new Millipede(50,10);
		// should be true
		System.out.println(m.isAlive());
		m.kill();
		//should now be dead
		System.out.println(m.isAlive());
		
	}
	
}
