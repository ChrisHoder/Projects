// FILE: Landscape.java
// AUTHOR: Chris Hoder
// DATE: 10/31/2011
// PROJECT 06

/* this class stores all the data for a landscape for the Battle ( it is essentially all reused code
 * from last week's simulation
 */

// imports
import java.awt.Color;
import java.awt.Graphics;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class Landscape {
	
	//data declarations
	
	//size of the grid
	private static int width;
	private static int height;
	
	// iteration number
	public static int iteration;
	// attackers that have been killed in this simulation
	private int killedAttackers;

	
	//list of all the agents in the Landscape
	private SimObjectList agents;
	//List of all the resources in the Landscape
	private SimObjectList resources;
	//List of all of the bullets in the landscape
	private SimObjectList bullets;
	// holds the Castle SimObject
	private SimObject castle;


	
	
	// METHODS

	// Constructor initializes all the data stored in the class
	// INPUT: width, height as integers
	// OUTPUT nothing
	public Landscape(int width, int height){
		Landscape.width = width;
		Landscape.height = height;
		// initialize all the lists
		this.agents = new SimObjectList();
		this.resources = new SimObjectList();
		this.bullets = new SimObjectList();
		this.castle  = null;
		
		// iteration starts at 1 and not 0 to avoid a divide by 0 error in the spawner with the surge calculator
		Landscape.iteration = 1;
		this.killedAttackers = 0;
		
		
	}
	
	// This method will add the given SimObject to the castle data field
	// INPUT: SimObject o
	// OUTPUT: nothing
	public void addCastle(SimObject o){
		this.castle = o;
	}
	
	
	// This method will return the SimObject stored in the castle data field
	// INPUT: nothing
	// OUTPUT: SimObject
	public SimObject getCastle(){
		return this.castle;
	}
	
	// This method will increment the number of attackers killed in total in this simulation
	// INPUT: nothing
	// OUTPUT: nothing
	public void incrementKilled(){
		this.killedAttackers++;
	}
	

	
	// This function will return the width of the Landscape grid
	// INPUT: nothing
	// OUTPUT: width of the grid (integer)
	public static int getWidth(){
		return Landscape.width;
	}
	
	
	// This function will return the height of the Landscape grid
	// INPUT: nothing
	// OUTPUT: height of the grid (integer)
	public static int getHeight(){
		return Landscape.height;
	}
	
	
	
	// This method will return a java.util.List of all the agents in the Landscape
	// generic cast to SimObject
	public List<SimObject> getAgents(){
		return agents.toList();
	}
	
	
	// This method will return a java.util.List of all the resources in the Landscape
	// generic cast to SimObject
	public List<SimObject> getResources(){
		return this.resources.toList();	
	}
	
	// This method will return a java.util.List of all the bullets in the Landscape
		// generic cast to SimObject
	public List<SimObject> getBullets(){
		return this.bullets.toList();
	}
	
	// This method will return the size of the Agent SimObjectList
	public int getAgentSize(){
		return this.agents.size();
	}
	
	// This method will return the size of the resource SimObjectList
	public int getResourceSize(){
		return this.resources.size();
	}

	// This method will get the agent in the SimObjectList agents that is at the index'th 
	// location
	// INPUT: location of agent desired
	// OUTPUT: SimObject at index location
	public SimObject getAgent(int index){
		return this.agents.get(index);
	}
	
	// This method will get the resource in the SimObjectList resources that is at the index'th
	// location
	// INPUT: location of the resource desired
	// OUTPUT: SimObject at index location
	public SimObject getResource(int index){
		return this.resources.get(index);
	}
	
	// This method will add a new agent to the landscape
	// INPUT: SimObject agent
	// OUTPUT: nothing
	public void addAgent(SimObject agent){
		this.agents.addAtFront(agent);
	}
	
	// this method will add a new resource to the landscape
	// INPUT: SimObject resource
	// OUTPUT: nothing
	public void addResource( SimObject resource){
		this.resources.addAtFront(resource);
	}
	
	// this method will add a new bullet object to the landscape
	// INPUT: SimObject b
	// OUTPUT: nothing
	public void addBullet( SimObject b){
		this.bullets.addAtEnd(b);
	}
	
	

	// This method will advance the Landscape 1 iteration. It will update all of the Lists and fields stored in the data. will return false when the castle
	// has been destroyed
	// INPUT: nothing
	// OUTPUT: boolean (
	public boolean advance() {
		// update iteration
		Landscape.iteration++;
		
		// update the castle and if it returns false, the castle has fallen and the simulation is over
		if( this.castle.updateState(this) ){
			// update agents (random order)
			if( this.agents.size() != 0){
				this.agents.shuffle();
				this.agents.updateAll(this);
			}
			//update bullets
			if( this.bullets.size() != 0){
				this.bullets.updateAll(this);
			}
			
			
			// update resources (random order)
			if( this.resources.size() != 0){
				this.resources.shuffle();
				this.resources.updateAll(this);
			}
			// return true ( simulation not over )
			return true;
		}
		// simulation done, castle has fallen
		else{
			return false;
		}
		
	
	}
	
	
	public void saveData(String path){
		// try to see if we can open/create this file
		try{
			FileWriter fw;
			// 1st iteration need to create the file/ overwrite
			if( BattleSimulation.simulation == 0){
				// will overwrite any file when a new simualtion starts
				fw = new FileWriter(path);
			}
			// add to the existing file
			else{
				fw = new FileWriter(path,true);
			}
			PrintWriter text = new PrintWriter( fw );
			
			text.println(BattleSimulation.simulation + ";" + Landscape.iteration + ";" + this.killedAttackers);
			// flush and close file connection
			text.flush();
			fw.close();
	
		}
		// if we can't then print out an error message
		catch (IOException ie){
			System.out.println(ie);
		}
	}
		
	
	// This method will reset the landscape, back to the condition it was in immediately after the constructor was called
	// INPUT: nothing
	// OUTPUT: nothing
	public void reset(){
		// clear SimObjectLists
		this.agents.clear();
		this.resources.clear();
		this.bullets.clear();
		// clear the castle simObject
		this.castle = null;
		// reset the primitives stored
		Landscape.iteration = 1;
		this.killedAttackers = 0;
	}
	

	
	// This method will draw in some of the statistics present on the right of the Display. They include the iteration number, number killed and the attackers on the Landscape
	// This method will also provide the number of iterations until the next troop surge or if during a troop surge it will tell us that it is a surge
	public void draw(Graphics g, int scale){

		// landscape width
		int boardWidth = Landscape.getWidth();
		
		
		g.setColor(Color.BLACK);
		// this draws a line at the right edge of the simulation landscape
		 g.drawLine(Landscape.getWidth()*scale, 0, Landscape.getWidth()*scale, Landscape.getHeight()*scale);
		 
		 
		 String str;
		 char[] strChr;
		 
		 // this draws the iteration number
		 g.setColor(Color.BLACK);
		 str = "Iteration: " + Integer.toString(Landscape.iteration);
		 strChr = str.toCharArray();
		 g.drawChars(strChr, 0, strChr.length, (int)(boardWidth+1)*scale, 8*scale);
		 
		 
		 // this draws the number of attackers killed by the army
		 str = "Number killed: " + Integer.toString(this.killedAttackers);
		 strChr = str.toCharArray();
		 g.drawChars(strChr, 0, strChr.length, (int)(boardWidth+1)*scale, 10*scale);
	
		 // this draws the number of Attackers on the Landscape at the given moment
		 str = "Attackers: " + Integer.toString(this.getResourceSize());
		 strChr = str.toCharArray();
		 g.drawChars(strChr, 0, strChr.length, (int)(boardWidth+1)*scale, 12*scale);
		 
		 // This determines whether we are in a troop surge or not. if we are then it will display "Army Surge!", other wise it will
		 // give the iterations until the next troop surge
		if( AttackSpawner.surgeIterations > 0 ){
			// Army Surge!
			g.setColor(Color.RED);
			str = "Army Surge!";
			strChr = str.toCharArray();
			g.drawChars(strChr, 0, strChr.length, (int)(boardWidth+1)*scale, 14*scale);
			
		}
		// get iterations until the next Attacker Surge
		else{
			g.setColor(Color.BLACK);
			int surgeTime = AttackSpawner.surgeStart -  ( Landscape.iteration % AttackSpawner.surgeStart );
			str = Integer.toString(surgeTime) + " till next surge";
			strChr = str.toCharArray();
			g.drawChars(strChr, 0, strChr.length, (int)(boardWidth+1)*scale, 14*scale);
		}
			
		 
	}
}