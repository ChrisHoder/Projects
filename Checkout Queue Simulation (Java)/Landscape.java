// FILE: Landscape.java
// AUTHOR: Chris Hoder
// DATE: 10/22/2011
// PROJECT 05

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


public class Landscape {
	
	//data declarations
	
	//size of the grid
	private int width;
	private int height;
	
	// prevNumber is used to determine the number of shoppers that have left. it will store
	// the number of shoppers who have already left the store, and then we can tell the 
	// number that left this turn by the incraese in total shoppers that have left
	private int prevNumber;
	// this will be the minimum amount of time that a shopper spent in the store
	private int minTime;
	// this will be the maximum amount of time that a shopper spent in the store
	private int maxTime;
	

	
	//list of all the agents in the Landscape
	private SimObjectList agents;
	//List of all the resources in the Landscape
	private SimObjectList resources;

	// this will hold the single line option
	private SimObject line;
	
	// this will hold the shoppers that have left the simulation. used for statistics gathering
	private ArrayList inactive;
	
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
		this.inactive = new ArrayList();
		this.prevNumber = 0;
		this.maxTime = 0;
		// arbitrarily large
		this.minTime = 999999;
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
	
	// This method will return the SimObjec that is in the line data declaration (i.e. the singleQueue for the 
	// checkoutSimulation
	public SimObject getSingleQueue(){
		return this.line;
	}
	
	// this method will create a CheckoutQueu
	public void setSingleQueue(SimObject line){
		this.line = line;
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
	
	// This method will add a SimObject to the ArrayList of inactive SimObjects on the landscape
	// INPUT: SimObject to be added
	// OUTPUT: nothing
	public void addInactive( SimObject o){
		this.inactive.add(o);
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
	
	
	// This method will compute various statistics of the simulation and print it out to the screen
	// 1st it will compute the number of shoppers that left in this iteration, and the total number of shoppers that have left
	// during the simulation. It will also calculate the average time for each strategy (if there is more than one strategy in the simulation)
	// as well as the minimum and maximum time that a shopper had to spend in the store
	// INPUT: nothing
	// OUTPUT: nothing
	/* PSEUDOCODE
	 *  1. 
	 */
	public void computeStatistics(){
		// print out header
		System.out.print("\n ---------------------------------------- \n");
		System.out.print(  " --------------Statistics --------------- \n");
		System.out.print(  " ---------------------------------------- \n\n");
		// data storage needed to compute the stastics
		// number of randomstrategy  shoppers
		int randomStrategy = 0;
		// total time of shoppers using the random strategy
		int randomTime = 0;
		// number of shoppers who used the best of all strategy
		int bestOfAllStrategy = 0;
		// total time of shoppers using the best of all strategy
		int bestAllTime = 0;
		// number of shoppers using the best of two strategy
		int bestOfTwoStrategy = 0;
		// total time of the shoppers who used the best of two strategy
		int bestTwoTime = 0;
		// this is the number of shoppers who finished and left in this round
		int finished = this.inactive.size() - prevNumber;
		// print information to the terminal
		System.out.println(" " + finished + " Shoppers paid and left. Total Shoppers: " + this.inactive.size());
		int time = 0;
		Shopper s;
		// This for loop will determine the total time that all the shoppers spent in the store
		// as well as for each individual strategy
		for(int i =0 ; i <  this.inactive.size() ; i++){
			s = ( Shopper ) this.inactive.get(i);
			// if this shopper spent less than the minimum time. set its time to be the new
			// minimum time
			if( s.getTotalTime() < this.minTime ){
				this.minTime = s.getTotalTime();
			}
			
			// if this shopper spent more than the max time. set its time to be the new maximum time
			if( s.getTotalTime() > this.maxTime ){
				this.maxTime = s.getTotalTime();
			}
			
			int strategyChoice = s.getStrategyChoice();
			// this will complete the total times for the different strategies so you can see which one is working the best
			switch (strategyChoice) {
			//random case
				case 0:
					randomStrategy ++;
					randomTime += s.getTotalTime();
					break;
			// chose the best queue of them all
				case 1:
					bestOfAllStrategy ++;
					bestAllTime += s.getTotalTime();
					break;
			// chose the best of two random queues
				case 2:
					bestOfTwoStrategy ++;
					bestTwoTime += s.getTotalTime();
					break;
					//default case does nothing
				default:
					break;
			}
			
			time += s.getTotalTime();
		}
		prevNumber = inactive.size();
		double average = 0;

		// need to check to see that these terms aren't zero to avoid a divide by 0 error. These print out the average times for the different strategies
		// in the case where only 1 strategy only that startegy will print, in the mix case these will all print
		if (inactive.size() != 0){
			average = time / inactive.size();
		}
		if( randomStrategy != 0){
			System.out.println(" The average time of the random strategy: " + (randomTime/randomStrategy));
		}
		if( bestOfAllStrategy != 0){
			System.out.println(" The average time of the best of all strategy: " + (bestAllTime/bestOfAllStrategy));
			
		}
		if( bestOfTwoStrategy != 0){
			System.out.println(" The average time of the best of 2 strategy: " + (bestTwoTime/bestOfTwoStrategy));
		}
	
		
		System.out.println("\n Min: " + this.minTime +"   Max: " + this.maxTime + "   Average of all: " + average);
	
	}
	
	
	
	// This method will advance the game, this will update the landscape, regardless of 
	// what simulation is being run. 
	public void advance(){
		//if there is only 1 queue, i.e. if SimObject line is not null.
		// then we update the queues so that it can put shoppers in the correct areas
		if ( this.line != null){
			((CheckoutQueue)line).updateShopperQueues(this);
		}
		
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
			//System.out.println(agents.size());
		}
		
		// computer and print out the current statistics on the simulation
		this.computeStatistics();
		
	}
	
	// this method will check the basics of the class
	public static void main( String[] args){
		Landscape l = new Landscape(100,100);
		System.out.println("The width " + l.getWidth() + " The height " + l.getHeight());
		l.advance();
	}
	
}