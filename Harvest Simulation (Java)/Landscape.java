// FILE: Landscape.java
// AUTHOR: Chris Hoder
// DATE: 10/16/2011
// PROJECT 04

/* this clas stores all the data for a landscape needed for the 3 types of simulations
 * harvest, social simulation, game of life
 */

// imports
import java.util.ArrayList;
import java.io.IOException;
import java.util.Random;
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;
import java.io.IOException;


public class Landscape {
	
	//data declarations
	
	//size of the grid
	private int width;
	private int height;
	
	// how the season will computed
	private int day;
	
	//list of all the agents in the Landscape
	private SimObjectList agents;
	//List of all the resources in the Landscape
	private SimObjectList resources;
	
	//List of all the SocialAgents in the landscape
	private SimObjectList socialAgents;
	
	//List of all the cells for the game of life
	private SimObjectList cells;
	// copy of the list of cells, to be used for updating.
	private List cellsList;
	
	// METHODS

	// Constructor initializes all the data stored in the class
	// INPUT: width, height as integers
	// OUTPUT nothing
	public Landscape(int width, int height){
		this.width = width;
		this.height = height;
		// initialize all the lists
		agents = new SimObjectList();
		resources = new SimObjectList();
		socialAgents = new SimObjectList();
		cells = new SimObjectList();
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
	
	// This function will return the day of the year in the simulation
	// INPUT: nothing
	// OUTPUT: day of the year
	public int getDay(){
		return this.day;
	}
	
	// This function will return a java.util.List of all the agents in the Landscape
	public List getAgents(){
		return agents.toList();
	}
	
	
	// This function will return a java.util.List of all the resources in the Landscape
	public List getResources(){
		return this.resources.toList();	
	}
	
	// This method will get the list of SocialAgents stored in the Landscape 
	// OUTPUT: List (ArrayList)
	public List getSocialAgents(){
		return this.socialAgents.toList();
	}
	
	// This method will return the list of cells stored in the landscape objectlist
	// OUTPUT: List (arrayList)
	public List getCellList(){
		return this.cells.toList();
	}
	
	// this method will return a copy of all of the cells stored in teh landscape
	// OUTPUT: copy of the cells List (arrayList)
	public List getCellListCopy(){
		return this.cells.copy();
	}
	
	// This function will add a new agent to the landscape
	public void addAgent(SimObject agent){
		this.agents.addAtFront(agent);
	}
	
	// this function will add a new resource to the landscape
	public void addResource( SimObject resource){
		this.resources.addAtFront(resource);
	}
	
	// This method will add the given SimObject to the front of the social agent simobject list
	// INPUT: SimObject to be added
	// OUTPUT: nothing
	public void addSocialAgent(SimObject agent){
		this.socialAgents.addAtFront(agent);
	}
	
	
	// This method will add the given SimObject to the front of the cell simObjectList
	// INPUT: SimObject to be added
	// OUTPUT: nothing
	public void addCell(SimObject agent){
		this.cells.addAtFront(agent);
	}
	

	
	// This function returns all the agents on the landscape that are within a radius of
	// the position (x,y). 
	public List getAgentsNear(double x, double y, double radius){
		return getNear(x,y,radius,agents);
	}
	
	// This function returns all the resources on the landscape that are within a radius of
	// position (x,y);
	public List getResourcesNear(double x, double y, double radius){
		return getNear(x,y,radius,resources);
	}
	
	// This function will return all the cells on the landscape that are within a 3x3 block
	// of the given cell position. This is designed to use the landscape as a grid with 
	// integer positions instead of the double (x,y) position it is initialized as'
	// INPUT: position x,y
	// OUTPUT: List of neighbors within (x+/-1, y+-1) of the given position
	public List getCellsNear(double x, double y){
		ArrayList nhbs = new ArrayList();
		Cell temp;
		// uses this saved ArrayList so that all updates will be on the old game baord not
		// the one being edited
		ArrayList cellsList = (ArrayList) this.cellsList;
		// FOR each element in the list of cells, check to see if the cell's position is
		// within the 3x3 grid of the given location
		for( int i=0; i < cellsList.size() ; i++){
			temp = ( Cell ) cellsList.get(i);
			double xPos = temp.getX();
			double yPos = temp.getY();
			// if it is within the locaiton add it to the list
			if( (xPos >= (x-1) ) && (xPos <= (x+1) ) ) {
				if( (yPos >= (y-1) ) && (yPos <= (y+1) ) ){
					if ( (xPos == x) && (yPos == y) ){
						continue;
					}
					else{
						nhbs.add(temp);
					}
				}
		}
		}
		// return the list
		return (List) nhbs;
	}
	

	
	// this function returns all the socialAgents on the landscape that are within
	// a radius of position (x,y). This will treat the landscape as a grid with integer
	// positions and is looking to find neighbors that are either x +/- 1 and/or y +/-1 
	// INPUT: position (x,y)
	// OUTPUT: List of SocialAgents within a 3x3 grid of the given position
	public List getSocialAgentsNear(double x, double y){
		ArrayList nhbs = new ArrayList();
		// get a list of all the social agents
		ArrayList agentList = (ArrayList ) this.socialAgents.toList();
		SocialAgent temp;
		// for each socialAgent, check its position and see if it is a neighbor
		for( int i=0; i < agentList.size() ; i++){
			temp = ( SocialAgent ) agentList.get(i);
			double xPos = temp.getX();
			double yPos = temp.getY();
			// check to see if it is in the 3x3 grid block
			if( (xPos >= (x-1) ) && (xPos <= (x+1) ) ) {
				if( (yPos >= (y-1) ) && (yPos <= (y+1) ) ){
					// do not add itself to the list
					if ( (xPos == x) && (yPos == y) ){
						continue;
					}
					else{
						// if it is add it
						nhbs.add(temp);
					}
				}
				
			}
		}
		//return the list of neighbors
		return (List) nhbs;
	}
	
	
	
	// This function returns all the SimObjects within the given radius from position (x,y) 
	// that are in the SimObjectslist, ListObjects and returns them all as a java.util.List
	// This method is private so that the user cannot acces it, this is only called by Landscape class
	// methods wishing to find their neighbors on their own SimObjectLists
	// INPUT: x,y location, radius and SimObjectList to traverse
	private List getNear(double x, double y, double radius, SimObjectList ListObjects){
		ArrayList neighbors = new ArrayList();
		// get the arrayList of the SimObjectList
		ArrayList simList = (ArrayList) ListObjects.toList();
		SimObject temp;
		double xDistance, yDistance;
		// for each element in the list of SimObjects
		for( int i = 0 ; i < simList.size() ; i++ ){
			temp = ( SimObject ) simList.get(i);
			xDistance = x - temp.getX();
			yDistance = y - temp.getY();
			
			// check to see if xdistance^2+yDistance^2 < radius^2 (pathagorean's theorem)
			if( (xDistance*xDistance + yDistance*yDistance) <= (radius*radius) ){
				neighbors.add(temp);
			}
			
		}
		
		return (List) neighbors;
	}
	
	// This method will advance the game, this will update the landscape, regardless of 
	// what simulation is being run. 
	public void advance(){
		// goes down the list of resources and updates all of the resources
	
		// if there are resources, update them
		if ( resources.size() != 0){
			this.resources.updateAll(this);
		}
			
		// if there are agents, update them
		if( agents.size() != 0){
			// randomly shuffles the list of Sim Objects on the landscape
			this.agents.shuffle();
			// updates the list of agents, that are now in a random order
			this.agents.updateAll(this);
			System.out.println(agents.size());
		}
		
		// if there are SocialAgents on the landscape, update them
		if( socialAgents.size() != 0){
			this.socialAgents.shuffle();
			this.socialAgents.updateAll(this);
		}

		
		// if there are cells on the landscape, update them
		if( cells.size() != 0){
			this.cellsList = getCellListCopy();
			this.cells.updateAll(this);
		}
			
		//increment the day (for the seasons)
		day ++;
		if ((day % 364) == 0){
			day = 0;
		}
		
	}
	
	// this method will check the basics of the class
	public static void main( String[] args){
		Landscape L = new Landscape(50,50);
		System.out.println(L.getWidth() + "     " + L.getHeight());
		System.out.println("day " + L.getDay());
		L.advance();
		System.out.println("day " + L.getDay());
		
		
	}
	
}