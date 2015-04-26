// FILE: Landscape.java
// AUTHOR: Brian Eastwood, modified by Chris Hoder
// DATE: 11/14/2011
// PROJECT 08

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Represents the landscape where all simulation objects live, work, 
 * and play.
 * 
 * @author bseastwo
 */
/**
 * Added a new data field that will hold the ElevatorBank ( as a SimObject ) and update with the advance() method
 * @author chris
 *
 */
public class Landscape
{
	private static Random rand = new Random();
	private static int YEAR = 200;
	
	private int width;
	private int height;
	
	private SimObjectList agents;
	private SimObjectList resources;
	private List inactive;
	private SimObject bank;
	
	private int day;
	
	/**
	 * Create a Landscape of size (width, height).
	 * 
	 * @param width		the width of the landsape
	 * @param height		the height of the landscape
	 */
	public Landscape(int width, int height)
	{
		this.width = width;
		this.height = height;
		this.agents = new SimObjectList();
		this.resources = new SimObjectList();
		this.inactive = new ArrayList();
		this.day = 0;
	}
	
	public void setBank( SimObject bank){
		this.bank = bank;
	}
	
	public SimObject getBank(){
		return this.bank;
	}
	
	
	public int getWidth()
	{
		return this.width;
	}
	
	public int getHeight()
	{
		return this.height;
	}
	
	public List getAgents()
	{
		return this.agents.toList();
	}
	
	public List getResources()
	{
		return this.resources.toList();
	}
	
	public List getInactive()
	{
		return this.inactive;
	}
	
	public int getTime()
	{
		return this.day;
	}
	
	/**
	 * Adds an Agent to this Landscape.
	 * 
	 * @param agent		the agent to add
	 */
	public void addAgent(SimObject agent)
	{
		this.agents.add(agent);
	}
	
	public void addResource(SimObject agent)
	{
		this.resources.add(agent);
	}
	
	public void addInactive(SimObject agent)
	{
		this.inactive.add(agent);
	}
	
	/**
	 * Advances the landscape a single generation by updating the state
	 * of all agents inhabiting the landscape.
	 */
	public void advance()
	{
		SimObject agent;
		boolean alive;
		
		if( this.bank != null){
			this.bank.updateState(this);
		}
		
		
		// update the resources
		this.resources.updateAll(this);
		
		// update the agents in a random order
		this.agents.shuffle();
		this.agents.updateAll(this);
		this.day++;
	}
		
	/**
	 * Returns the set of agents that are within radius of a 
	 * position (x, y).
	 * 
	 * @param x			the x position
	 * @param y			the y position
	 * @param radius		the radius of the search area
	 * @return a List of SimObject agents near positon (x, y)
	 */
	public List getAgentsNear(double x, double y, double radius)
	{
		// copy agents to a new list
		List agents = this.getAgents();
		// create a list to hold the nearby agents
		List nearby = new ArrayList();
		
		// variables used inside the loop
		double rSquared = radius * radius;
		SimObject agent;
		double dSquared = 0;
		
		// visit every agent
		for (int i = 0; i < agents.size(); i++)
		{
			// find distance between (x, y) and agent)
			agent = (SimObject) agents.get(i);
			dSquared = Math.pow(x - agent.getX(), 2) + Math.pow(y - agent.getY(), 2);
			
			// add to nearby list if within radius
			if (dSquared <= rSquared)
			{
				nearby.add(agent);
			}
		}
				
		return nearby;
	}
	
	/**
	 * Returns the set of resources that are with radius of a
	 * position (x, y)
	 * 
	 * @param x
	 * @param y
	 * @param radius
	 * @return a List of SimObject resources that are near (x, y)
	 */
	public List getResourcesNear(double x, double y, double radius)
	{
		// copy resources to a new list
		List resources = this.getResources();
		
		// create a list to hold nearby agents and inialize variables 
		// used inside the loop
		List nearby = new ArrayList();
		double rSquared = radius * radius;
		SimObject agent;
		double dSquared = 0;
		
		// visit each resource
		for (int i = 0; i < resources.size(); i++)
		{
			// find the distance from (x, y) to the resource
			agent = (SimObject) resources.get(i);
			dSquared = Math.pow(x - agent.getX(), 2) + Math.pow(y - agent.getY(), 2);
			
			// add the resource to nearby list if close enough
			if (dSquared <= rSquared)
			{
				nearby.add(agent);
			}
		}
				
		return nearby;
	}
	
	/**
	 * Determines whether it is summer at position (x, y) on this landscape.
	 * @param x		the x position
	 * @param y		the y position
	 * @return		true if it is summer, false otherwise
	 */
	public boolean isSummer(double x, double y)
	{
		double season = (int) ((2.0 * this.day / Landscape.YEAR)) % 2;
		double hemisphere = (int) ((2.0 * y / this.getHeight())) % 2;
		
//		System.out.println("isSummer season: " + season);
//		System.out.println("isSummer hemis:  " + hemisphere);
		
		return season == hemisphere;
	}
	
	public static void main(String[] args)
	{
		// populate a landscape
		Landscape scape = new Landscape(30, 20);
		
//		scape.addAgent(3.0, 3.2, new BroccoliFiend(0));
//		scape.addAgent(4.0, 2.2, new BroccoliFiend(1));
//		scape.addResource(3.0, 3.2, new Broccoli(0));
//		scape.addResource(4.0, 2.2, new Broccoli(1));
		
		// find neighbors
		System.out.println("3.0,  3.2: " + scape.getAgentsNear(3.0, 3.2, 0.01).size());
		System.out.println("3.5,  2.7: " + scape.getAgentsNear(3.5, 2.7, 0.71).size());
		
		// test summer
		System.out.println(String.format("day %3d at (%4.1f, %4.1f) %b", scape.day, 15., 8., scape.isSummer(15, 8)));
		System.out.println(String.format("day %3d at (%4.1f, %4.1f) %b", scape.day, 15., 12., scape.isSummer(15, 12)));
		scape.day = 190;
		System.out.println(String.format("day %3d at (%4.1f, %4.1f) %b", scape.day, 15., 8., scape.isSummer(15, 8)));
		System.out.println(String.format("day %3d at (%4.1f, %4.1f) %b", scape.day, 15., 12., scape.isSummer(15, 12)));
	}
}
