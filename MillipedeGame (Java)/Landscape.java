// FILE: Landscape.java
// AUTHOR: Brian Eastwood, modified by Chris Hoder
// DATE: 11/22/2011
// PROJECT 09

import java.util.ArrayList;
import java.util.List;

/**
 * Represents the landscape where all simulation objects live, work, 
 * and play.
 * <p>
 * Added new data fields to hold the bullet and defender (as SimObjects). Additionally the resources was
 * changed from a SimObjectList to an ArrayList of SimObjectLists.
 * @author chris
 *
 */
public class Landscape
{
	
	private int width;
	private int height;
	
	private SimObjectList agents;
	private ArrayList<SimObjectList> resources;
	
	private SimObject bullet;
	private SimObject defender;
	
	
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
		this.resources = new ArrayList<SimObjectList>();
	}
	
	public SimObject getDefender(){
		return this.defender;
	}
	
	public void setDefender( SimObject defender){
		this.defender = defender;
	}
	
	public void setBullet( SimObject bullet){
		this.bullet = bullet;
	}
	
	public SimObject getBullet(){
		return this.bullet;
	}
	
	
	public int getWidth()
	{
		return this.width;
	}
	
	public int getHeight()
	{
		return this.height;
	}
	
	public List<SimObject> getAgents()
	{
		return this.agents.toList();
	}
	
	public ArrayList<SimObjectList> getResources()
	{
		return this.resources;
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
	
	public void addResource(SimObjectList agents)
	{
		this.resources.add(agents);
	}
	
	
	/**
	 * Advances the landscape a single generation by updating the state
	 * of all agents inhabiting the landscape.
	 * @return returns false when the Defender has died, true otherwise
	 */
	public boolean advance()
	{	
		boolean check;
		if( this.bullet != null){
			check = this.bullet.updateState(this);
			if( check == false ){
				this.bullet = null;
			}
			//System.out.println("Bullet nonEmpty");
		}
		
		boolean gameStatus = this.defender.updateState(this);
		if(!gameStatus){
			return false;
		}
			
	
		
		// update the resources
		
		for( int i = 0 ; i < this.resources.size(); i++){
			check = this.resources.get(i).updateState(this);
			if(!check){
				this.resources.remove(i);
			}
		}
		
		
		// update the agents
		this.agents.updateAll(this);
		
		//Defender still alive
		return true;
	}
		
	
	public void clear(){
		this.resources.clear();
		this.agents.clear();
		this.bullet = null;
	}

	public static void main(String[] args)
	{
		// populate a landscape
		Landscape scape = new Landscape(30, 20);
		System.out.println(scape.getHeight() + " width: " + scape.getWidth());
		// it should be null
		System.out.println(scape.getBullet());
		
		
	}
}
