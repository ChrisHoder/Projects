// FILE: WumpusHunt.java
// AUTHOR: Chris Hoder
// DATE: 12/9/2011
// Project 10

// imports
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.util.List;
import java.util.Random;

import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

/**
 * This class will implement the Hunt the Wumpus game. Another version of the game can be played here:
 * http://www.dreamcodex.com/playwumpus.php
 * 
 * @author chris
 *
 */


public class WumpusHunt {
	
	/**
	 * This controls the gamePlay of the game.
	 * @author chris
	 *
	 */
	public static enum PlayState { PLAY, PAUSE, STOP, START }
	/**
	 * This is the current game state.
	 */
	public static PlayState pState;
	/**
	 * This controls the state of the hunter
	 * given game
	 * @author chris
	 *
	 */
	public static enum State { READY, AIMED, FIRED, DEAD, WUMPUS_DEAD };
	/**
	 * This is the current state of the hunter
	 */
	public static State state;
	
	/**
	 *  controls whether or not the to save the images every 50 iterations or not
	 * @author chris
	 *
	 */
	private enum saveState {SAVE, NO_SAVE}
	/**
	 * Current save state of the game
	 */
	private saveState saveStatus;
	
	private static int SAVE_ITERATIONS = 50;
	private int iterations;
	
	/**
	 * This is the probability that a given vertex will be converted from a cave spot
	 * to a path between cave spots.
	 */
	private static double CONNECTION_PROB = 1;
	
	/**
	 * This is the level of difficulty that the game is
	 * @author chris
	 *
	 */
	private enum level { EASY, MEDIUM, HARD;
		
		/** 
		 * This method will get the corresponding
		 * Connection Probability for each level
		 * @return double that corresponds to the connection probability
		 * for each level
		 */
		public double getProb(){
			if(this == level.EASY){
				return 0.9;
			}
			else if( this == level.MEDIUM){
				return 0.5;
			}
			else{
				return 0.0;
			}
		}
	}
	
	
	/**
	 * Holds wins information
	 */
	public static int wins;
	/**
	 * holds losses information
	 */
	public static int losses;
	
	private JLabel score;
	
	/**
	 * Current level
	 */
	private level currentLevel = level.EASY;
	
	/**
	 * This will be used to display the current level
	 */
	private JLabel textMessage;
	/**
	 * This will hold options to change the level type
	 */
	private JComboBox combo;
	
	/**
	 * This is the length of time the advance method pauses
	 * between iterations
	 */
	private static int pause = 100;
	
	/**
	 * This holds the landscape upon which the game is played
	 */
	private Landscape scape;
	/**
	 * This controls the display
	 */
	private LandscapeDisplay display;
	/** 
	 * This is the graph that holds the all of the information about every cave vertex
	 */
	private Graph g;
	

	/**
	 * This is the constructor to create a new game board and display.
	 * width * height is the max number of cave vertexes that can be created in the
	 * landscape
	 * 
	 * @param width - width of the cave system
	 * @param height - height of the cave system
	 */
	public WumpusHunt(int width, int height){
		this.scape = new Landscape(width, height);
		this.display = new LandscapeDisplay(this.scape, 64,"Wumpus Hunt");
		this.g = new Graph();
		
		//state initialy paused and the hunter is ready to move
		WumpusHunt.state = WumpusHunt.State.READY;
		WumpusHunt.pState = WumpusHunt.PlayState.PAUSE;
		this.saveStatus = WumpusHunt.saveState.NO_SAVE;
		this.iterations = 0;
		
		// start new stats gathering
		WumpusHunt.wins = 0;
		WumpusHunt.losses = 0;
		
		// initialize grid
		// switch this commented with the dynamic one to simply create one static cave system
		// that is a 4x4
		//createStaticCave();
		this.createDynamicCave();
		this.createConnections();
		// this initializes the hunter and wumpus
		this.initializeGame();
		
		// this sets up the control and keyboard listeners
		this.setupUI();
	}
	
	/**
	 * This method will set the CONNECTIO_PROB static
	 * double
	 * @param prob -  new connection Probability for the cave system
	 */
	public static void setConnectionProb(double prob){
		WumpusHunt.CONNECTION_PROB = prob; 
	}
	
	/**
	 * This method will return the CONNECTION_PROB static
	 * variable, the connection probability for the dynamic cave
	 * @return connection probability for the dynamic cave
	 */
	public static double getConnectionProb(){
		return WumpusHunt.CONNECTION_PROB;
	}
	
	/**
	 *  This method sets up the listeners for the keyboard controls in the game
	 */
	private void setupUI(){
		// listen for keystrokes
		Control control = new Control();
		// add listener
		this.display.addKeyListener(control);
		
		level levels[] = {level.EASY,level.MEDIUM,level.HARD};
		this.combo = new JComboBox();
		for( int  i = 0 ; i < levels.length ; i ++ ){
			this.combo.addItem(levels[i]);
		}
		this.combo.setEditable(false);
		this.combo.setSelectedIndex(0);
		this.combo.addActionListener(control);
		
		
		this.score = new JLabel("Wins: " + WumpusHunt.wins + " Losses: " + WumpusHunt.losses);
		
		this.textMessage = new JLabel("Level: " + this.currentLevel.toString());
		JPanel panel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
		
		
		//adds a title
		JLabel help = new JLabel("press h for Help");
		JPanel panel2 = new JPanel(new FlowLayout(FlowLayout.CENTER));
		panel2.add(help);
		
		panel.add(this.score);
		panel.add(this.textMessage);
		panel.add(this.combo);
		
		panel.setVisible(true);
		
		this.display.add(panel,BorderLayout.SOUTH);
		this.display.add(panel2,BorderLayout.NORTH);
		this.display.pack();
		this.display.setFocusable(true);
		this.display.requestFocus();
		
	}
	
	
	/**
	 * This method will change the game settings so that the wumpus is 
	 * drawn. It kills the wumpus however
	 */
	@SuppressWarnings("unused")
	private void drawWumpus(){
		WumpusHunt.state = State.FIRED;
		((Wumpus)this.scape.getAgents().get(0)).kill();
	}
	
	/**
	 * This method resets the game to the initial settings. 
	 */
	public void reset(){
		//display what level we are using
		this.textMessage.setText("Level: " + this.currentLevel.toString());
		// set our connection probability to the current level
		WumpusHunt.setConnectionProb(this.currentLevel.getProb());
		
		
		
		//update the score information
		this.score.setText("Wins: " + WumpusHunt.wins + " Losses: " + WumpusHunt.losses);
		
		//this erases the current wumpus and hunter on the grid
		this.scape.clearAgents();
		// this clears the cave
		this.g.clear();
		this.scape.clearResources();
		// this resets the labelling system for the cave elements
		Vertex.resetTotalNum();
		// this creates a new dynamic cave map for the new game
		this.createDynamicCave();
		this.createConnections();
		
		// this places the wumpus and the hunter
		this.initializeGame();
		// this sets the play enums to the initial values
		WumpusHunt.state  = WumpusHunt.State.READY;
		WumpusHunt.pState = WumpusHunt.PlayState.PAUSE;
		// reset save information
		this.iterations = 0;
		this.saveStatus = WumpusHunt.saveState.NO_SAVE;
	
		// this makes the cave invisible
		this.setInvisible();
		// set the new hunter room visible
		((Hunter)this.scape.getAgents().get(1)).currentRoom().setMarked(true);
		
		
		//uncomment below to make the entire cave system visible at game start
		//this.setVisible();
		
		
	}
	
	/**
	 * This method will create a static grid of unconnected 
	 * vertexes on the landscape. A Vertex will be placed
	 * at all integer spots in the landscape.
	 */
	private void createGrid(){
		int width = this.scape.getWidth();
		int height = this.scape.getHeight();
		// adds each elements at each integer location
		for( int i = 0 ; i < height ; i++){
			for( int j = 0 ; j < width ; j++ ) {
				Vertex temp = new Vertex(j,i);
				// add it to the graph
				this.g.addVertex(temp);
				// add it to the landscape
				this.scape.addResource(temp);
			}
		}	
	}
	
	
	/**
	 * This makes the a dynamic Cave that will be different each time.
	 * This method will only create a cave where connections between the Verticies are 
	 * north/south and east/west. The connections will also be between neighboring Verticies on the landscape
	 */
	public void createDynamicCave(){
		// create initial static grid
		createGrid();
		
		
		List<Vertex> verticies = this.g.getVertices();
		int size = verticies.size();
		// while the cave is not connected
		while(!this.g.isConnected()){
			// while it is not connected it will continue to add one additional connection randomly to the board
			Random randIndx = new Random();
			//get temp node
			Vertex temp = verticies.get(randIndx.nextInt(size));
			// don't try to add to a full Vertex
			while( temp.getNeighbors().size() == 4){
				temp = verticies.get(randIndx.nextInt(size));
			}
			// this makes a new neighbor for this temp Vertex
			makeNeighbor(temp);
		}
	}
	
	
	/**
	 * This method creates more complex connections within the cave system. It will pick a random number of the vertexes in the list of
	 * Vertices based on the CONNECTION_PROB data field. if a chosen vertex has either 2 or 4 edges, it will turn this from a cave opening
	 * to a path between different openings. It will connect its neighbors based in one of 4 types of arrangements. The cave will remain
	 * connected but paths will connect different openings.
	 * <p>
	 * Type 1: North and East neighbors are now connected. As well as West and South neighbors
	 * <p>
	 * Type 2: North and West neighbors are now connected. As well as East and South neighbors
	 * <p>
	 * Type 3: North and South neighbors connected only
	 * <p>
	 * Type 4: East and West neighbors connected only
	 */
	public void createConnections(){
		List<Vertex> verticies = this.g.getVertices();
		// for each vertex
		for( Vertex w : verticies ){
			// if a random number is greater than the CONNECTION_PROB and the given vertex only has 2 or 4 edges
			if( Math.random() > WumpusHunt.CONNECTION_PROB && w.getNeighbors().size() != 3 && w.getNeighbors().size() != 1 && w.getNeighbors().size() != 0 ){
				//if there is only 2  edges from this vertex
				if ( w.getNeighbors().size() == 2){
					// if one of the edges is in the north direction
					if( w.getNeighbor(Vertex.Direction.NORTH) != null ){
						// if the edges are north and south (type 3)
						if(w.getNeighbor(Vertex.Direction.SOUTH) != null){
							// north south connection
							w.setType(3);
						}
						// if the edges are north and east (type 1)
						else if( w.getNeighbor(Vertex.Direction.EAST) != null){
							//north east connection (part of type 1)
							w.setType(1);
						}
						// if the edges are north and west (type 2)
						else if ( w.getNeighbor(Vertex.Direction.WEST) != null){
							//north west connection (part of type 2)
							w.setType(2);
						}
					}// end NORTH connections
					// if one of the edges is the south direction
					else if ( w.getNeighbor(Vertex.Direction.SOUTH) != null){
						// edges are south and east (type 2)
						if( w.getNeighbor(Vertex.Direction.EAST) != null){
							//south- east connection( part of type 2 connection)
							w.setType(2);
						}
						//edges are south and west (type 1)
						else if( w.getNeighbor(Vertex.Direction.WEST) != null){
							//south-west connection (part of type 1)
							w.setType(1);
						}
					}// end SOUTH connections
					// the 2 edges are east and west
					else{
						// east-west connection
						w.setType(4);
					}
						
					
				} // end just size 2
				// the size is 4 and half the time choose type 1 and half the time choose type 2
				else{
					// half the time type 1
					if( Math.random() > 0.5){
						w.setType(1);
					}
					// other half type 2
					else{
						w.setType(2);
						
					}
					if(!this.g.isConnected()){
						w.setType(0);
					}
				}
				
			}
		}
	}
	
	
	
	/**
	 * This method can be used to create complete cave where every integer point in the landscape
	 * will contain a cave opening with a path to the neighboring cave in all 4 directions: north, south, east, west.
	 * All connections will be straight (north/south ; east/west)
	 * <p>
	 * This method is unused in the current implementation
	 */
	@SuppressWarnings("unused")
	private void createCompleteCave(){
		// initialize a grid with a cave vertex at every integer point in the landscape
		this.createGrid();
		// for each vertex in the cave
		for ( Vertex v : this.g.getVertices() ){
			// get a list of all of the caves that neighbor it in the vertical/horizontal directions
			List<Vertex> nhbs = this.g.getClose(v, scape);
			// for each neighbor, we need to figure out which side it neighbors on to know
			// which direction to add an edge in
			for ( Vertex w : nhbs){
				//initialize directin
				Vertex.Direction dir = null;
				// The nhb and Vertex v lie on the same x direction, they are vertically neighbors
				if( w.getX() == v.getX()){
					// neighbor to the south
					if( w.getY() == (v.getY()+1)){
						dir = Vertex.Direction.SOUTH;
					}
					// neighbor to the north
					else if ( w.getY() == (v.getY() - 1)){
						dir = Vertex.Direction.NORTH;
					}
					// neighbor to the north, but Vertex v sits at the top of the landscape, wraps around
					else if( v.getY() == 0 ) {
						dir = Vertex.Direction.NORTH;
					}
					// neighbor to the south, but Vertex v sits at the bottom of the landscape, wraps around
					else {
						dir = Vertex.Direction.SOUTH;
					}
				}
				// the nhb and Vertex v lie on the same y position, they are neighbors horizontally
				else{
					// they are neighbors to the east
					if( w.getX() == (v.getX()+1)){
						dir = Vertex.Direction.EAST;
					}
					// neighbors  to the west
					else if ( w.getX() == (v.getX() - 1)){
						dir = Vertex.Direction.WEST;
					}
					// neighbors to the west but Vertex v sits on the left side of the landscape, wrap around
					else if( v.getX() == 0 ) {
						dir = Vertex.Direction.WEST;
					}
					// neighobrs to the east but Vertex v sits on the right of the landscape, wraps around
					else {
						dir = Vertex.Direction.EAST;
					}
				}
				// add this edge, with the given direction determined above
				this.g.addEdge(v, dir, w);
			}
		}
	}
	
	
	/**
	 * This method will make a random connection between the Vertex v and one of its neighbors. The connection will
	 * be in the straight direction (north/south ; east/west).
	 * @param v - Vertex with which to create a new neighbor for
	 */
	public void makeNeighbor(Vertex v){
		//gets a list of all of the Vertex's within 1 unit horizontal or 1 vertical unit away from this
		// Vertex. This includes wrap around
		List<Vertex> nhbs = this.g.getClose(v, scape);
		
		//get random nhbs
		Random randIndx = new Random();
		// get a random one from this list
		Vertex w = nhbs.get(randIndx.nextInt(nhbs.size()));
		
		Vertex.Direction dir = null;
		// Figure out which direction the random chosen Vertex is in so that we Add the edge on the right direction
		// If they are in the same x position (this must be a vertical neighbor)
		if( w.getX() == v.getX()){
			// the southern neighbor
			if( w.getY() == (v.getY()+1)){
				dir = Vertex.Direction.SOUTH;
			}
			// northern neighbor
			else if ( w.getY() == (v.getY() - 1)){
				dir = Vertex.Direction.NORTH;
			}
			// northern wrap around neighbor
			else if( v.getY() == 0 ) {
				dir = Vertex.Direction.NORTH;
			}
			// southern wrap around neighbor
			else {
				dir = Vertex.Direction.SOUTH;
			}
		}
		// y values are the same so it is a horizaontal neighbor
		else{
			// east neighbor
			if( w.getX() == (v.getX()+1)){
				dir = Vertex.Direction.EAST;
			}
			// west neighbor
			else if ( w.getX() == (v.getX() - 1)){
				dir = Vertex.Direction.WEST;
			}
			// west wrap around neighbor (on board edge)
			else if( v.getX() == 0 ) {
				dir = Vertex.Direction.WEST;
			}
			// east wrap around neighbor ( on the board edge)
			else {
				dir = Vertex.Direction.EAST;
			}
		}
		// add this edge to the graph
		this.g.addEdge(v, dir, w);
	}
	
	
	
	
	/**
	 * This method will create a static cave
	 * that is on a 4x4 grid. it will create the connections between all the edges and place them 
	 * on the landscape and everything.
	 * 
	 * <p>
	 * This method is not in use in the current implementation, but can be used by changing the initialization code.
	 */
	public void createStaticCave(){
		//initialize each vertex
		Vertex vA = new Vertex(0,0); // 
		Vertex vB = new Vertex(1,0); // 
		Vertex vC = new Vertex(3,0); // 
		Vertex vD = new Vertex(0,1); //
		Vertex vE = new Vertex(2,1); // 
		Vertex vF = new Vertex(3,1); // 
		Vertex vG = new Vertex(0,2); // 
		Vertex vH = new Vertex(1,2);
		Vertex vI = new Vertex(2,2); //  vh
		Vertex vJ = new Vertex(3,2); // vi
		Vertex vK = new Vertex(0,3); // vj
		Vertex vL = new Vertex(1,3); // vk
		
		//create the connections
		this.g.addEdge(vA, Vertex.Direction.EAST, vB);
		this.g.addEdge(vA, Vertex.Direction.NORTH, vK);
		this.g.addEdge(vA, Vertex.Direction.SOUTH, vD);
		this.g.addEdge(vA, Vertex.Direction.WEST, vC);
		
		this.g.addEdge(vB, Vertex.Direction.EAST, vE, Vertex.Direction.NORTH);
		
		this.g.addEdge(vC, Vertex.Direction.WEST, vL, Vertex.Direction.SOUTH);
		this.g.addEdge(vC, Vertex.Direction.SOUTH, vF);
		
		this.g.addEdge(vD, Vertex.Direction.EAST, vI);
		this.g.addEdge(vD, Vertex.Direction.SOUTH, vG);
		
		this.g.addEdge(vE, Vertex.Direction.EAST, vF);
		//this.g.addEdge(vE, Vertex.Direction.WE);
		this.g.addEdge(vG, Vertex.Direction.WEST,vJ);
		this.g.addEdge(vG, Vertex.Direction.EAST, vH);
		
		this.g.addEdge(vE, Vertex.Direction.SOUTH, vI);
		this.g.addEdge(vI,Vertex.Direction.EAST,vJ);
		this.g.addEdge(vJ, Vertex.Direction.SOUTH, vL, Vertex.Direction.EAST);
		
		this.g.addEdge(vK, Vertex.Direction.EAST, vL);
		
		// add them all to the landscape (for updatingStates)
		List<Vertex> verticies = this.g.getVertices();
		for( int i = 0 ; i < verticies.size() ; i++){
			Vertex temp = verticies.get(i);
			this.scape.addResource(temp);
		}
		
	}
	
	
	
	
	/**
	 * This method will have the hunter fire an arrow in the given direction dir. This method handles all of the information
	 * dealing with if it hits the wumpus or misses. It will still fire the arrow even if its is fired in a direction that does
	 * not have a path to another cave.
	 * @param dir - direction upon which to fire the arrow
	 */
	public void fire(Vertex.Direction dir){
		// get the hunter
		Hunter h = (Hunter)this.scape.getAgents().get(1);
		// get the number of arrows
		int arrows = h.getArrows();

		
		//check to make sure we still have arrows, if not the game would be over
		if( arrows > 0){
			
			// need to get actual room we are fireing into, the neighboring vertex may just be a
			// path between open spaces in the cave
			Vertex hunterRoom = h.currentRoom();
			// this method finds the actual neighbor
			Vertex roomFired = this.g.findActualNeighbor(dir, hunterRoom);
			
			
			// if you can fire that direction, we need to check and see if we killed the wumpus or missed
			if( roomFired != null){
				// get the wumpus's vertex
				Wumpus w = (Wumpus)this.scape.getAgents().get(0);
				// you killed the Wumpus!
				if( roomFired == w.currentRoom){
					System.out.println(" Wumpus Killed!!!!!!");
					// set our state to be dead
					WumpusHunt.state = WumpusHunt.State.WUMPUS_DEAD;
					// kill the wumpus (will draw);
					w.kill();
					WumpusHunt.wins++;
				}
				// we missed the wumpus, it will come kill us
				else{
					WumpusHunt.state = WumpusHunt.State.FIRED;
					WumpusHunt.losses++;
				}
			}
			// missed the wumpus, it will come kill us
			else{
				WumpusHunt.state = WumpusHunt.State.FIRED;
				WumpusHunt.losses++;
			}
			
			// shot that arrow
			h.shoot();
			// set the map visible
			this.setVisible();
			
		}
		
	}
	
	
	/**
	 * This will make the cave system not visible on the display.
	 * It will set the marked boolean on all of the verticies to false
	 */
	public void setInvisible(){
		this.g.setInvisible();
	}
	
	/**
	 * This will make the cave system visible on the display. It will set the marked boolean of all
	 * the verticies to true.
	 */
	public void setVisible(){
		this.g.setVisible();
	}
	
	
	/**
	 * This method will initialize the game of Hunt the Wumpus. It assumes a cave system has already
	 * been initialized. It will place the Wumpus and the hunter randomly in the cave, as well as compute
	 * which cave openings are within 2 cave openings of the Wumpus. It will make sure to not place the hunter in the same room
	 * as the wumpus.
	 */
	public void initializeGame(){
		// pick a room for the wumpus
		Random rand = new Random();
		int graphNumber = g.vertexCount();
		int roomNumber = rand.nextInt(graphNumber);
		// we have to make sure that it is placed in a cave opening (vertex type == 0) and not a path
		// between cave openings
		while( this.g.getVertex(roomNumber).getType() != 0){
			roomNumber = rand.nextInt(graphNumber);
		}
		// place the wumpus
		Vertex wumpusRoom = g.getVertex(roomNumber);
		Wumpus w = new Wumpus(wumpusRoom.getX(), wumpusRoom.getY(), wumpusRoom);
		
		// set the cost on each vertex, so we know how far each Vertex is from the Wumpus
		this.g.shortestPath(wumpusRoom);
		
		// This sets all of the vertexes so that they have not been visited and will not be drawn
		this.setInvisible();
		
		
		
		// pick a room for the hunter
		Random rand2 = new Random();
		int hunterRoom;
		// this will run until the random generator picks a number that isn't the 
		// same as the one the wumpus is in and is also a vertex of type 0 (i.e cave opnening and not a path
		// between two cave openings)
		while((hunterRoom = rand2.nextInt(graphNumber)) == roomNumber || this.g.getVertex(hunterRoom).getType() != 0){}
		Vertex hunterStartRoom = g.getVertex(hunterRoom);
		Hunter h = new Hunter(hunterStartRoom.getX(),hunterStartRoom.getY(),hunterStartRoom);
		// make this room visited, Hunter is in it.
		hunterStartRoom.setMarked(true);
		
		// This adds the Hunter and the wumpus to the landscape as agents.
		// The wumpus will always be the agent 0 and the hunter agent 1
		this.scape.addAgent(w);
		this.scape.addAgent(h);
	
	}
	
	
	/**
	 * This method is a checker method to make sure that the Wumpus is agent 0 and the Hunter
	 * is agent 1. It will print out to the screen whether this is true or not
	 */
	public void checkAgents(){
		SimObject s = (SimObject)this.scape.getAgents().get(0);
		SimObject h = (SimObject)this.scape.getAgents().get(1);
		System.out.println("check wumpus " + (s instanceof Wumpus));
		System.out.println("check hunter " + (h instanceof Hunter));
	}
	
	/**
	 * This method will repaint the display
	 */
	public void rePaint(){
		this.display.repaint();
	}
	
	
	/**
	 * This method handles the iteration of the game. If the game is not paused it will update the State of all of the 
	 * elements in the landcape (calls landscape advance). If the wumpus is dead it will display all of the parts of the 
	 * cave. 
	 */
	public void advance(){
		// this is not the best way of going about this but it is the most clear. it will repeat itself
		// with every iteration after the Hunter dies, which is bad and takes memory, but since
		// the board is small i am not going to implement a more confusing method
		if( WumpusHunt.state == WumpusHunt.State.DEAD){
			this.setVisible();
		}
		if( WumpusHunt.pState != WumpusHunt.PlayState.PAUSE && WumpusHunt.pState != WumpusHunt.PlayState.STOP){
			this.scape.advance();
			this.iterations++;
		}
		
		// if we want to save images of the game and we are on the right iteration multiple
		if(this.saveStatus == saveState.SAVE &&  ( this.iterations % WumpusHunt.SAVE_ITERATIONS == 0 ) ){
			// create appropriate filename
			String filename = String.format("image-%04d.png",this.iterations);
			// save the image
			this.display.saveImage(filename);
			
		}

		
		// pause for refresh, this minimizes threading issues
		try
		{
			Thread.sleep(WumpusHunt.pause);
		}
		catch (InterruptedException ie)
		{
			// do threads get insomnia?
			ie.printStackTrace();
		}
	}
	
	/**
	 * This method will print out the usage of the WumpusHunt game to the 
	 * terminal:
	 * <p>
	 * Usage: WumpusHunt [-w,--width] [-h, --height]
	 */
	public static void printUsage(){
		System.err.println(
				"Usage: WumpusHunt [-w,--width] [-h, --height]");
	}
	
	/**
	 * This method will run the Hunt the Wumpus game. 
	 * @param args - optional inputs of the width(-w) and the height (-h)
	 */
	public static void main(String[] args){
		CmdLineParser parser = new CmdLineParser();
		
		CmdLineParser.Option widthSize      = parser.addIntegerOption('w',"width");
		CmdLineParser.Option heightSize     = parser.addIntegerOption('h',"height");
		
		try{
			parser.parse(args);
		}
		catch( CmdLineParser.OptionException e){
			System.err.println(e.getMessage());
			WumpusHunt.printUsage();
			System.exit(-1);
		}
		
		// get the input options, if they are not input, a reasonable default has been chosen
		int width       = (Integer)parser.getOptionValue( widthSize ,    new Integer(10));
		int height      = (Integer)parser.getOptionValue( heightSize,    new Integer(10));
		
		
		WumpusHunt wh = new WumpusHunt(width,height);
		
		// runs until the user hits 'q' to quit the game
		while(WumpusHunt.pState != WumpusHunt.PlayState.STOP){
			wh.advance();
			wh.rePaint();
		}
		
		//close/exit
		wh.display.dispose();
		System.exit(1);
	}
	
	
	/**
	 * This class is the control class for all of the user input via the keyboard
	 * @author chris
	 *
	 */
	private class Control extends KeyAdapter implements ActionListener{
		
		/**
		 * This method handles the keypressed events (namely the arrow keys and the space bar).
		 * Also known as the motion and fireing
		 */
		public void keyPressed(KeyEvent e){
			if( pState == PlayState.PLAY){
				// direction to move
				Vertex.Direction dir = null;
				// hit the up key, move to through north connection
				if( e.getKeyCode() == KeyEvent.VK_UP || e.getKeyCode() == KeyEvent.VK_KP_UP){
					// arrow not armed
					if( WumpusHunt.state == WumpusHunt.State.READY){
						dir = Vertex.Direction.NORTH;
					}
					//else fire the arrow
					else if (WumpusHunt.state == WumpusHunt.State.AIMED){
						fire(Vertex.Direction.NORTH);
					}
					
				}
				// hit the down key, move through south connection
				else if( e.getKeyCode() == KeyEvent.VK_DOWN ||  e.getKeyCode() == KeyEvent.VK_KP_DOWN){
					// arrow not armed
					if( WumpusHunt.state == WumpusHunt.State.READY){
						dir = Vertex.Direction.SOUTH;
					}
					//else fire the arrow
					else if (WumpusHunt.state == WumpusHunt.State.AIMED){
						fire(Vertex.Direction.SOUTH);
					}
					
				}
				// hit the right key, move through east connection
				else if( e.getKeyCode() == KeyEvent.VK_RIGHT || e.getKeyCode() == KeyEvent.VK_KP_RIGHT){
					// arrow not armed
					if( WumpusHunt.state == WumpusHunt.State.READY){
						dir = Vertex.Direction.EAST;
					}
					//else fire the arrow
					else if (WumpusHunt.state == WumpusHunt.State.AIMED){
						fire(Vertex.Direction.EAST);
					}
				}
				// hit the left key, move through west connection
				else if( e.getKeyCode() == KeyEvent.VK_LEFT || e.getKeyCode() == KeyEvent.VK_KP_LEFT){
					// arrow not armed
					if( WumpusHunt.state == WumpusHunt.State.READY){
						dir = Vertex.Direction.WEST;
					}
					//else fire the arrow
					else if (WumpusHunt.state == WumpusHunt.State.AIMED){
						fire(Vertex.Direction.WEST);
					}
				}
				// arm the weapon
				else if( e.getKeyCode() == KeyEvent.VK_A && WumpusHunt.state == WumpusHunt.State.READY){
					WumpusHunt.state = WumpusHunt.State.AIMED;
					System.out.println("WEAPON AIMED! CHOOSE A DIRECTION!");
				}
				// if we are armed
				else if( e.getKeyCode() == KeyEvent.VK_A && WumpusHunt.state != WumpusHunt.State.AIMED){
					WumpusHunt.state = WumpusHunt.State.READY;
					System.out.println("WEAPON DISARMED!");
				}	
				Hunter h = (Hunter)scape.getAgents().get(1);
				h.move(dir);
			
			}
			
			// p button is pressed and we are playing the game
			if ( e.getKeyCode() == KeyEvent.VK_P && WumpusHunt.pState == WumpusHunt.PlayState.PLAY){
				WumpusHunt.pState = WumpusHunt.PlayState.PAUSE;
			}
			// p button is pressed and the game is paused
			else if ( e.getKeyCode() == KeyEvent.VK_P && WumpusHunt.pState == WumpusHunt.PlayState.PAUSE){
				WumpusHunt.pState = WumpusHunt.PlayState.PLAY;
			}
			// q button is pressed -- exit the game
			else if ( e.getKeyCode() == KeyEvent.VK_Q ){
				WumpusHunt.pState = WumpusHunt.PlayState.STOP;
			}
			// r button is pressed -- this will reset the game
			else if ( e.getKeyCode() == KeyEvent.VK_R){
				reset();
			}
			// s button is pressed, this will start/stop saving images of our game
			else if ( e.getKeyCode() == KeyEvent.VK_S ){
				//end saving of images
				 if( saveStatus == saveState.SAVE){
				 	System.out.println("Saving of Simulation images terminated!");
					saveStatus = saveState.NO_SAVE;
				 }
				 // begin saving images
				else{
					System.out.println("Saving of Simulation has begun!");
					saveStatus = saveState.SAVE;
				}
			
			}
			// display help message
			else if( e.getKeyCode() == KeyEvent.VK_H){
				String str = "Game Controls: \n" +
						"p -- pause/play \n" +
						"a -- arm/disarm weapon \n" +
						"arrow keys -- movement and fire direction \n" + 
						"s -- save images \n" +
						"h -- help ";
				JOptionPane.showMessageDialog(display, str);
				display.requestFocus();
			}
			
			}

		@Override
		/**
		 * This method will handle the changing of levels. The levels will be changed using a 
		 * drop down menu, but the game will not change difficulty until a new level is started.
		 */
		public void actionPerformed(ActionEvent arg0) {
			// get the current level chosen
			int index = combo.getSelectedIndex();
			level difficulty = (level)combo.getItemAt(index);
			// if the user changed the level desired, change the current level
			// and display to the user that the game needs to be reset
			if(! difficulty.equals(currentLevel)){
				textMessage.setText("Restart game to change Level");
				currentLevel = difficulty;
			}
			
			
			// put focus back on the display and not the button
			display.requestFocus();
		}
			
		}
	
	
		
	
}
