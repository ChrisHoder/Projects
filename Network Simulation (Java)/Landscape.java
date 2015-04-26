// FILE: Landscape.java
// AUTHOR: Chris Hoder
// DATE: 10/31/2011
// PROJECT 06

/* this clas stores all the data for a landscape for the shopperSimulation ( it is essentially all reused code
 * from last week's simulation
 */

// imports
import java.util.ArrayList;
import java.io.IOException;
import java.util.Random;
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import java.io.FileWriter;

public class Landscape {
	
	//data declarations
	
	//size of the grid
	private int width;
	private int height;
	
	// number iteration that we are in during the simulation
	// this is used for saving the data to a text file
	private int iteration;
	// this will decide whether the averaging is on or off. default off
	private static boolean save = false;
	private static int iterationNum = 10;
	// this will randomize which users are updated when
	private static boolean randomizeUpdate = false;
	
	
	
	//list of all the agents in the Landscape
	private SimObjectList agents;
	//List of all the resources in the Landscape
	private SimObjectList resources;

	private static String path = "data.txt";
	
	
	// METHODS

	// Constructor initializes all the data stored in the class
	// INPUT: width, height as integers
	// OUTPUT nothing
	public Landscape(int width, int height){
		this.width = width;
		this.height = height;
		// initialize all the lists
		this.agents = new SimObjectList();
		this.resources = new SimObjectList();
		// 0 iterations at start
		this.iteration = 0;
		
		
	}
	
	
	// This method will set the static boolean randomizeUpdate that will determine how the Users are updated, if it is true, the agents will update in a random order
	public static void setRandomUpdate(boolean update){
		Landscape.randomizeUpdate = update;
	}
	
	// This static method will set the path that the average number of friends data will be saved to
	// INPUT: string of full pathname to save data
	// OUTPUT: nothing
	public static void setPath( String path ) {
		Landscape.path = path;
	}
	
	// This static method will set the integer that determines the gap between saving the average friend data
	// INPUT: number (integer)
	// OUTPUT: nothing
	public static void setIterationNum(int num){
		Landscape.iterationNum = num;
	}
	
	// This method will set the boolean that determines whether or not the statistics will be saved to a file. true means
	// that the average number of friends for each user will be saved with each iteration
	// INPUT: boolean
	// OUTPUT: nothing
	public static void setSave(boolean save){
		Landscape.save = save;
	}
	
	// This function will return the width of the Landscape grid
	// INPUT: nothing
	// OUTPUT: width of the grid (integer)
	public int getWidth(){
		return this.width;
	}
	
	
	// This function will return the height of the Landscape grid
	// INPUT: nothing
	// OUTPUT: height of the grid (integer)
	public int getHeight(){
		return this.height;
	}
	
	
	
	// This method will return a java.util.List of all the agents in the Landscape
	public List getAgents(){
		return agents.toList();
	}
	
	
	// This method will return a java.util.List of all the resources in the Landscape
	public List getResources(){
		return this.resources.toList();	
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
	
	
	// This method will compute the average number of friends in the current iteration
	// INPUT: nothing
	// OUTPUT: average number of friends (double)
	/* PSEUDOCODE
	 *  1. for ( each user) DO
	 *  	- add this users number of friends to the total number of friends
	 *     END
	 *  2. divide the total number of friends by the number of users to get the average number of friends
	 *  3. return the average number of friends
	 */
	public double computeAverageFriends(){
		ArrayList users = ( ArrayList )this.agents.toList();
		int friends = 0;
		// for each user
		for( int i = 0 ; i < users.size() ; i++ ){
			// get the user
			User u = ( User )users.get(i);
			// get number of friends and add it to the total count
			friends += u.getFriendSize();
		}
		// compute the average by dividing the total number of friends by the number of users (users.size())
		double average = (double)friends / (double)users.size();
		// return the average
		return average;
	}
	
	// for info on writing files go to 
	// 
	// This method will save the average number of friends for each user at this iteration. it will save all the data to this.path. The first iteration
	// will overwrite whatever file exists in the current directory with the given path. All the other iterations will simply add a line to this file.
	// Some guidence was recieved from this website http://www.daniweb.com/software-development/java/threads/115931.
	// INPUT: String pathname
	// OUTPUT: nothing (saves line to file)
	/* PSEUDOCODE
	 * 	1. Try
	 * 		a. IF ( first iteration ) THEN
	 * 			- overwrite given pathname file
	 * 		   ELSE
	 * 			- open existing file for addition
	 *         END
	 *      b. compute average
	 *      c. save this to the end of the file
	 *      d. close file
	 *    Catch
	 *    	- print out error
	 *    END
	 */
	public void saveData(String path) {
		// try to see if we can open/create this file
		try{
			FileWriter fw;
			// 1st iteration need to create the file/ overwrite
			if( iteration == 0){
				// will overwrite any file when a new simualtion starts
				fw = new FileWriter(path);
			}
			// add to the existing file
			else{
				fw = new FileWriter(path,true);
			}
			PrintWriter text = new PrintWriter( fw );
			//compute average
			double average = computeAverageFriends();
			text.println(this.iteration + "," + average);
			// flush and close file connection
			text.flush();
			fw.close();
	
		}
		// if we can't then print out an error message
		catch (IOException ie){
			System.out.println(ie);
		}
	}
	
	// This method will advance the simulation by one iteration. It will also update the iteration number
	// INPUT: nothing
	// OUTPUT: nothing
	/* PSEUDOCODE
	 * 
	 * 	1. update all of the Users
	 * 	2. Save the average number of iterations to a file
	 * 	3. update the iteration counter
	 * 
	 */
	public void advance() {
		if( this.randomizeUpdate == true){
			this.agents.shuffle();
		}
		this.agents.updateAll(this);
		// if we are saving
		if( this.save){
			// saves only every iterationNum iterations
			if( (this.iteration % this.iterationNum) == 0){
				this.saveData(Landscape.path);
			}
		}
		// increment the iteration
		this.iteration++;
	}
}