// FILE: Wumpus.java
// AUTHOR: Chris Hoder
// DATE: 12/09/2011
// PROJECT 10

//imports
import java.awt.Color;
import java.awt.Graphics;


/**
 * This class holds all of the information for the Wumpus for the game Hunt the Wumpus.
 * @author chris
 *
 */
public class Wumpus extends SimObject {

	//data declarations
	/**
	 * holds whether the Wumpus is alive (true)
	 */
	boolean isAlive;
	/**
	 * The current Vertex (room) that the Wumpus is sitting in
	 */
	Vertex currentRoom;
	
	/**
	 * Constructor. Takes in the location of the Wumpus on the landscape (x,y) and the starting Vertex that the
	 * Wumpus is in.
	 * @param x - x position on the landscape
	 * @param y - y position on the landscape
	 * @param startRoom - Vertex in which the Wumpus is sitting
	 */
	public Wumpus(double x, double y, Vertex startRoom) {
		super(x, y);
		
		//initially alive
		this.isAlive = true;
		// current room
		this.currentRoom = startRoom;
		
	}

	/**
	 * This method returns the life status of the Wumpus (isAlive data field)
	 * @return - True if the Wumpus is alive, false otherwise
	 */
	public boolean isAlive(){
		return this.isAlive;
	}
	
	/**
	 * This method returns the current room that the Wumpus is in (Vertex)
	 * @return - Vertex that the Wumpus is in
	 */
	public Vertex getRoom(){
		return this.currentRoom;
	}
	
	/**
	 * This method "kills" the wumpus, i.e. sets the isAlive boolean to false
	 */
	public void kill(){
		this.isAlive = false;
	}

	/**
	 * This method sets the room that the Wumpus is in to a new Vertex v
	 * @param v - room to move the Wumpus to
	 */
	public void setRoom(Vertex v){
		this.currentRoom = v;
	}
	
	@Override
	/**
	 * This method updates the State of the Wumpus. it will simply check to see if the 
	 * hunter is in the same room as the Wumpus. If it is it will eat the hunter and the game is over
	 * @param scape - Landscape we are playing on
	 * @return always true (wumpus is never removed from the board during the game)
	 */
	public boolean updateState(Landscape scape) {
		// get a pointer to the hunter
		// this is an error check to make sure that we arent in the process of restarting the game
		if( scape.getAgents().size() < 2){ return true;}
		Hunter h = (Hunter)scape.getAgents().get(1);
		
		// the Wumpus is in the same room as the Hunter
		if( h.currentRoom() == this.currentRoom ){
			if( h.isAlive() ){
				WumpusHunt.losses++;
			}
			//EAT!
			h.setAlive(false);
			WumpusHunt.state = WumpusHunt.State.DEAD;
		}
		
		
		// always return true. this should never be removed from the Landscape
		return true;
	}

	@Override
	/**
	 * This method draws the Wumpus on the Landscape Display. It only draw the Wumpus after the game as ended in some way. The 
	 * drawing of the Wumpus will be different depending on whether or not the Wumpus was killed or not. It will have a smiling face
	 * for alive and a frown for dead
	 */
	public void draw(Graphics g, int x, int y, int scale) {
		int eights = (scale)/8;
		// if the Wumpus is dead or the Hunter has fired
		if( !this.isAlive){

			// body is rectanular
			g.setColor(Color.RED);
			g.fillRect(x+eights, y+eights, (3*scale)/4, (3*scale)/4);
			//eyes
			g.setColor(Color.YELLOW);
			g.fillOval(x + scale/4, y + scale/4, scale/6, scale/8);
			g.fillOval(x + (7*scale)/12, y + (scale)/4, scale/6, scale/8);
			//smiling face
			g.fillArc(x + scale/4, y + (scale)/2, scale/2, scale/2, 0, 180);
			
		}
		// the wumpus eats the Hunter and/or the Hunter fired it's arrow and missed
		else if( ( WumpusHunt.state == WumpusHunt.State.FIRED ) || WumpusHunt.state == WumpusHunt.State.DEAD ){
			g.setColor(Color.GREEN);
			// body is rectangular
			g.fillRect(x+eights, y+eights, (3*scale)/4, (3*scale)/4);
			g.setColor(Color.YELLOW);
			//eyes
			g.fillOval(x + scale/4, y + scale/4, scale/6, scale/8);
			g.fillOval(x + (7*scale)/12, y + (scale)/4, scale/6, scale/8);
			// frown (it's dead)
			g.fillArc(x + scale/4, y + scale/4, scale/2, scale/2, 0, -180);
			
			
			
		}
		
	}
	
	/**
	 * This method tests the uses of the class
	 * @param args - not used
	 */
	public static void main(String args[]){
		Wumpus w = new Wumpus(1,1, new Vertex(1,1));
		System.out.println("The wumpus is alive? : " + w.isAlive());
		w.kill();
		System.out.println("Killed the wumpus, the wumpus is alive?:" + w.isAlive());
		System.out.println("The wumpus's room: " + w.getRoom().toString());
		w.setRoom(new Vertex(2,2));
		System.out.println("Room changed: The wumpus's room: " + w.getRoom().toString());
	}

}
