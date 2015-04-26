// FILE: Hunter.java
// AUTHOR: Chris Hoder
// DATE: 12/09/2011
// PROJECT 10

import java.awt.Color;
import java.awt.Graphics;

/**
 * This class will hold all of the infomration and method for the hunter to be used in the game
 * Hunt the Wumpus
 * @author chris
 *
 */

public class Hunter extends SimObject {

	//data declarations
	/**
	 * The number of arrows that the Hunter has left
	 */
	private int arrows;
	/**
	 * The current room that the Hunter is in
	 */
	private Vertex currentRoom;
	
	/**
	 * The life status of the hunter. Alive == true
	 */
	private boolean isAlive;
	
	/**
	 * Number of arrows that the Hunter starts with
	 */
	private static final int ARROWS_START = 1;
	
	
	/**
	 * This constructor will initialize a new hunter at the given position (x,y) and in the given
	 * Vertex
	 * @param x - starting x position
	 * @param y - starting y position
	 * @param startRoom - Vertex that the Hunter sits in
	 */
	public Hunter(double x, double y, Vertex startRoom) {
		super(x, y);
		// initially alive
		this.isAlive = true;
		this.arrows = Hunter.ARROWS_START;
		this.currentRoom = startRoom;
		
	}

	/**
	 * This method returns the current room that the Hunter is in
	 * @return - Vertex corresponding to where the Hunter is
	 */
	public Vertex currentRoom(){
		return this.currentRoom;
	}
	
	/**
	 * This method sets the isAlive data field for the Hunter
	 * @param alive - boolean for the isAlive data field
	 */
	public void setAlive(boolean alive){
		this.isAlive = alive;
	}
	
	
	/**
	 * returns the isAlive data field (life status of the Hunter)
	 * @return - true if the hunter is alive, false otherwise
	 */
	public boolean isAlive(){
		return this.isAlive;
	}
	
	
	/**
	 * This method moves the Hunter to the vertex in the given direction. This method is recursive and will 
	 * move the Hunter from the room that it is in to the room that is connected to it in the given direction dir. If the directly adjacent
	 * Vertex is not a cave opening (vertex of type 0 ) then it will move in the appropriate way to the next Vertex and so on until the Hunter
	 * reaches the Vertex that it is connected to.
	 * @param dir - direction in which to move
	 */
	public void move(Vertex.Direction dir){
		// if no direction input, do nothing
		if( dir == null ){ return;}

		// if there is an edge in the given direction dir then move to that room.
		if( this.currentRoom.getNeighbor(dir) != null){
			this.currentRoom = this.currentRoom.getNeighbor(dir);
			
			// we are in a pathway we need to move on. need to find the direction to move in based on
			// the type of Vertex tunnel that we are in ( see Vertex for what types are which).
			
			// These types may seem to contradict those defined in the Vertex class but remember
			// that dir is the direction from which you left the Vertex you were in, so it is the opposite of the direction that the type
			// is with.
			
			if( this.currentRoom.getType() != 0 ){ 
				// set this tunnel as visited (so it draws)
				this.currentRoom.setMarked(true);
				// if we came from the north 
				if( dir == Vertex.Direction.NORTH ){
					// type 1 has a north/west connection
					if( this.currentRoom.getType() == 1){
						dir = Vertex.Direction.WEST;
					}
					// type 2 has a north/east connection
					else if( this.currentRoom.getType() == 2){
						dir = Vertex.Direction.EAST;
					}
					// type 3 has a north/south connection
					else if( this.currentRoom.getType() == 3){
						dir = Vertex.Direction.NORTH;
					}
					// no type 4 Vertexes that you can access from the NORTH or SOUTH
					else{
						System.out.println("Incorrect game board!");
						System.exit(-1);
					}
				}
				// If we came from the east
				else if ( dir == Vertex.Direction.EAST){
					// type 1 has a east/south connection
					if( this.currentRoom.getType() == 1){
						dir = Vertex.Direction.SOUTH;
					}
					// type 2 has a east north connectino
					else if ( this.currentRoom.getType() == 2){
						dir = Vertex.Direction.NORTH;
					}
					// type 4 has a east west connection
					else if( this.currentRoom().getType() == 4){
						dir = Vertex.Direction.EAST;
					}
					// not type 4 connections that you can access from the EAST
					else{
						System.out.println("Incorrect game Board!");
						System.exit(-1);
					}
				}
				// we came from the south
				else if ( dir == Vertex.Direction.SOUTH){
					// type 1 has a south-east connection
					if( this.currentRoom.getType() == 1){
						dir = Vertex.Direction.EAST;
					}
					// type 2 has a south/west connection
					else if ( this.currentRoom.getType() ==2 ){
						dir = Vertex.Direction.WEST;
					}
					// type 3 has a north/south connection
					else if ( this.currentRoom.getType() == 3 ){
						dir = Vertex.Direction.SOUTH;
					}
				}
				// came from the west
				else if ( dir == Vertex.Direction.WEST){
					// type 1 has a west/north connection
					if( this.currentRoom.getType() == 1){
						dir = Vertex.Direction.NORTH;
					}
					// type 2 has a south, west connection
					else if ( this.currentRoom.getType() == 2){
						dir = Vertex.Direction.SOUTH;
					}
					// type 3 has a east/west connection
					else if ( this.currentRoom.getType() == 4){
						dir = Vertex.Direction.WEST;
					}
				}
				// since we are not in a type 0 Vertex, we need to recursively move to the next room until
				// we get to a Vertex with type 0
				this.move(dir);
			}
			
		}
		// adjust the position each time.
		this.setPosition(this.currentRoom.getX(), this.currentRoom.getY());
		// set the place as visited
		this.currentRoom().setMarked(true);
	}
	
	
	/**
	 * This method returns the number of arrows that the Hunter has
	 * left to shoot
	 * @return - number of arrows ( arrows data field)
	 */
	public int getArrows(){
		return this.arrows;
	}
	
	/**
	 * This "shoots" an arrow, i.e. decrements the arrow count by 1.
	 * If the hunter has 0 arrows it will not decrement it further
	 */
	public void shoot(){
		// if we have arrows left
		if( this.arrows > 0){
			this.arrows--;
		}
	}
	
	
	@Override
	/**
	 * This is the updateState method, it does nothing for this game. 
	 * it will always return true because the Hunter is never going to be removed from
	 * the Landscape
	 * @return true, always
	 */
	public boolean updateState(Landscape scape) {		
		// This will always return true, we never want to remove the 
		// hunter from the landscape
		return true;
	}

	@Override
	/**
	 * This method will draw the Hunter on the Landscape Display. It will draw a different hunter for when
	 *  the hunter is alive and when it is dead. When the hunter is alive it will draw a circle with yellow eyes and 
	 *  smiley face. When the Hunter is dead it will be a circle, yellow eyes a frown and a cross over the Hunter
	 *  
	 */
	public void draw(Graphics g, int x, int y, int scale) {
		int eights = (scale)/8;
		// draw an dead hunter
		if( WumpusHunt.state == WumpusHunt.State.FIRED || this.isAlive == false){
			//oval body
			g.setColor(Color.RED);
			g.fillOval(x+eights, y+eights, (3*scale)/4, (3*scale)/4);
			//eyes
			g.setColor(Color.YELLOW);
			g.fillOval(x + scale/4, y + scale/4, scale/6, scale/8);
			g.fillOval(x + (7*scale)/12, y + (scale)/4, scale/6, scale/8);
			//frown
			g.fillArc(x + scale/4, y + (scale)/2, scale/2, scale/2, 0, 180);
			
			//cross to show that it is dead
			g.setColor(Color.BLACK);
			g.drawLine(x, y, x+scale, y+scale);
			g.drawLine(x+scale, y, x, y+scale);
			
			
		}
		
		// draw something different if the hunter is alive
		else{
			// oval body
			g.setColor(Color.BLUE);
			g.fillOval(x+eights, y+eights, (3*scale)/4, (3*scale)/4);
			// yellow eyes
			g.setColor(Color.YELLOW);
			g.fillOval(x + scale/4, y + scale/4, scale/6, scale/8);
			g.fillOval(x + (7*scale)/12, y + (scale)/4, scale/6, scale/8);
			//smile
			g.fillArc(x + scale/4, y + scale/4, scale/2, scale/2, 0, -180);
		
			

		}
		
	}
	
	/**
	 * This method tests the Hunter classs and it's methods
	 * @param args -- not used
	 */
	public static void main(String args[]){
		Hunter h = new Hunter(0,0, new Vertex(0,0));
		System.out.println("is the hunter alive: " + h.isAlive());
		h.setAlive(false);
		System.out.println("killed the huner, is it alive?: " + h.isAlive());
		System.out.println("hunter has this many arrows: " + h.getArrows());
		h.shoot();
		System.out.println("Hunter shoots an arrow. hunter has this many arrows: " + h.getArrows());
		System.out.println("The hunter's room: " + h.currentRoom().toString());
	}

}
