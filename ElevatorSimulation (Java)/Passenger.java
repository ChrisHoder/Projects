// FILE: Passenger.java
// AUTHOR: Chris Hoder
// DATE: 11/14/2011
// PROJECT 08

import java.awt.Color;
import java.awt.Graphics;
import java.util.Comparator;

/**
 * Represents a passenger in an elevator Simulation. A passenger has a starting floor where they enter the simulation and a target floor where they wish to exit the simulation.
 * The passenger keeps track of how long it has been in the simulation, waiting to be delivered to it's target floor
 * @author chris
 *
 */

public class Passenger extends SimObject {

	//data declarations
	/**
	 * Indicates whether the passenger is active in the simulation
	 */
	private boolean active;
	/**
	 * Indicates whether the Passenger is currently on the elevator
	 */
	private boolean onboard;
	/**
	 * The passenger's initial floor, declared final
	 */
	private final int startFloor;
	/**
	 * the passenger's target floor, declared final
	 */
	private final int targetFloor;
	/**
	 * The amount of time the passenger has spent in the simulation
	 */
	private int waitTime;
	
	/**
	 * this initializes a new passenger with the given start floor and target floor
	 * @param start the Passenger's start floor
	 * @param target the Passenger's target floor
	 */
	public Passenger(int start, int target) {
		//default location, simulation sets the position.
		super(5, 5);
		this.startFloor = start;
		this.targetFloor  = target;
		
	}

	/**
	 * Gets the passenger's starting floor
	 * @return the start floor
	 */
	public int getStartFloor(){
		return this.startFloor;
	}
	
	/**
	 * Gets the passenger's target floor
	 * @return the target floor
	 */
	public int getTargetFloor(){
		return this.targetFloor;
	}
	
	/**
	 * Gets the total time this passenger has been waiting to be delivered to its target floor
	 * @return the waiting time
	 */
	public int getWaitTime(){
		return this.waitTime;
	}
	
	/**
	 * Indicates whether the passenger is active, still within the simulation
	 * @return true if the passenger is active, false otherwise
	 */
	public boolean isActive(){
		return this.active;
	}
	
	/**
	 * Indicates whether the passenger is onboard an elevator
	 * @return true if the passenger is on the elevator, false otherwise
	 */
	public boolean isOnBoard(){
		return this.onboard;
	}
	
	/**
	 * Sets the passenger to be active in the simulation
	 * @param active true if the passenger is active, false otherwise
	 */
	public void setActive(boolean active){
		this.active = active;
	}
	
	
	/**
	 * Sets the passenger's onboard status
	 * @param onboard true if the passenger is on an elevator, false otherwise
	 */
	public void setOnboard(boolean onboard){
		this.onboard = onboard;
	}
	
	
	@Override
	/**
	 * Increments this passenger's waittime. Returns true if the passenger is still active, false otherwise
	 * @param scape the Landscape the agent lives on
	 * @return true if the object survives depending on it's state false if it does not
	 */
	public boolean updateState(Landscape scape) {
		this.waitTime++;
		if(this.active){
			return true;
		}
		else{
			return false;
		}
	}
	
	/**
	 * Returns a string containing the passenger start floor, target floor, and wait time, for example:
	 * Passenger: [24 -> 0, 20]
	 */
	public String toString(){
		String str  = "Passenger: [" + this.startFloor + " -> " + this.targetFloor + ", " + this.targetFloor + "]";
		return str;
	}

	@Override
	/**
	 * Draws the passenger as a red circle if it is not onboard the elevator. If it is onboard an elevator, draws nothing
	 */
	public void draw(Graphics g, int x, int y, int scale) {
		if(!onboard){
			g.setColor(Color.RED);
			g.fillOval(x, y, scale, scale);
		}
		
		
	}
	
	/**
	 * This tests the class methods
	 * @param args not used
	 */
	public static void main(String[] args){
		Passenger p = new Passenger(0, 25);
		System.out.println("start floor: " + p.getStartFloor() + " targetfloor: " + p.getTargetFloor());
		System.out.println("isActive: " + p.isActive() + " isOnboard?: " + p.isOnBoard());
		p.setActive(false);
		p.setOnboard(false);
		System.out.println("isActive: " + p.isActive() + " isOnboard?: " + p.isOnBoard());
		System.out.println("waittime" + p.getWaitTime());
		
		
	}
	
	/**
	 * Compares two passengers by target floor, where passenger P1 is considered greater than passenger P2 if P1.targetFloor > P2.targetFloor.
	 * @author chris
	 *
	 */
	public static class MaxFloor implements Comparator<Passenger> {
		public int compare(Passenger o1, Passenger o2){
			return (o1.targetFloor - o2.targetFloor);
		}
		
	}
	
	/**
	 *  Compares two passengers by target floor, where passenger P1 is considered greater than passenger P2 if P1.targetFloor < P2.targetFloor.
	 * @author chris
	 *
	 */
	public static class MinFloor implements Comparator<Passenger>{
		public int compare(Passenger o1, Passenger o2){
			return(o2.targetFloor - o1.targetFloor);
		}
	}

}
