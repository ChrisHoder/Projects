// FILE: ElevatorBank.java
// AUTHOR: Brian Eastwood modified by Chris Hoder
// DATE: 11/14/2011
// PROJECT 08

import java.awt.Graphics;
import java.util.Queue;



/**
 * Represents a collection of elevators that operate independently.  The
 * bank maintains a list of all the elevators in the bank; an individual
 * elevator can be accessed by ElevatorBank.getElevator(index).
 * <p>
 * The bank also maintains queues of passengers on each floor that have requested
 * to travel to a different floor.  There are two queues for each floor,
 * one for passengers traveling to a higher floor and one for passengers
 * traveling to a lower floor.
 * 
 * @author bseastwo
 */
/**
 * The Queues that the waiting passengers are stored in has been updated to be
 * a custom designed Queue called Elevator Queue. This Queue is a comparable (compares based on
 * size) but also stores the floor that the Queue is on and the Direction that it's passengers
 * want to travel in
 * @author chris
 *
 */
public class ElevatorBank extends SimObject
{
	
	/**
	 * This holds the different strategies that can be set for the simulation
	 * @author chris
	 */
	public enum STRATEGY { INDIV, GROUP, INDIV_2, GROUP_2, GROUP_3}
	public static STRATEGY strategy;
	private Elevator[] elevators;
	private Queue[] upQueues;
	private Queue[] downQueues;
	
	/**
	 * Initializes an elevator bank with the given number of elevators
	 * and floors.
	 * @param lifts -  the number of elevators
	 * @param floors -  the number of floors
	 */
	public ElevatorBank(double x, double y, int lifts, int floors, int capacity)
	{
		super(x,y);
		// initialize all the elevators
		this.elevators = new Elevator[lifts];
		
		//set strategy
		ElevatorBank.strategy = STRATEGY.GROUP;
		
		for (int i = 0; i < lifts; i++)
		{
			int start = 0;
			// for the GROUP_3 strategy we will start with half of the elevators at the top and half
			// at the bottom
			if( ElevatorBank.strategy == STRATEGY.GROUP_2){
				
				if( i < lifts/2){
					start = 0;
				}
				else{
					start = floors-1;
				}
			}
			this.elevators[i] = new Elevator(this, capacity, start);
		}
		
		// initialize all the queues on each floor
		this.upQueues = new Queue[floors];
		this.downQueues = new Queue[floors];
		for (int i = 0; i < floors; i++)
		{
			//changed to ElevatorQueues
			this.upQueues[i] = new ElevatorQueue(i,Elevator.Direction.UP);
			this.downQueues[i] = new ElevatorQueue(i,Elevator.Direction.DOWN);
		}
		
		
	}
	
	/**
	 * this method will return the number of floors in the ElevatorBank
	 * @return number of floors
	 */
	public int getFloorCount() { return this.upQueues == null ? 0 : this.upQueues.length; }
	/**
	 * This method will return the number of elevators in the ElevatorBank
	 * @return number of elevators
	 */
	public int getElevatorCount() { return this.elevators == null ? 0 : this.elevators.length; }
	
	/**
	 * Gets the elevator with the given index.
	 * @param index the elevator index
	 * @return the elevator, or null if the index is invalid
	 */
	public Elevator getElevator(int index)
	{
		Elevator lift = null;
		if (index >= 0 && index < this.getElevatorCount())
			lift = this.elevators[index];
		return lift;
	}
	
	/**
	 * Determines whether a given floor index is valid for this bank.
	 * @param floor the floor index
	 * @return true if the floor is valid, false otherwise
	 */
	private boolean isFloorValid(int floor)
	{
		return floor >= 0 && floor < this.getFloorCount();
	}
		
	/**
	 * Adds a passenger to the bank by placing them in the proper queue
	 * on their start floor.  This method checks to make sure the
	 * passenger has valid start and end floors for this elevator bank.
	 * 
	 * @param user the passenger to add
	 */
	public void addPassenger(Passenger user)
	{
		if (this.isFloorValid(user.getStartFloor()) &&
			this.isFloorValid(user.getTargetFloor()) &&
			user.getStartFloor() != user.getTargetFloor())
		{
			if (user.getStartFloor() < user.getTargetFloor())
			{
				this.upQueues[user.getStartFloor()].offer(user);
			}
			else
			{
				this.downQueues[user.getStartFloor()].offer(user);
			}
		}
		else
		{
			System.err.println("ElevatorBank.addPassenger is rejecting a naughty passenger: " + user);
		}
	}

	/**
	 * Returns a reference to the passenger that is closest to the given
	 * elevator in the direction it is traveling. If the elevator is idle, this
	 * is the nearest passenger traveling in either direction. If the elevator
	 * is moving in a direction, this is the closest passenger in that
	 * direction.
	 * 
	 * @param lift the elevator to consider
	 * @return the closest passenger or null if a suitable one does not exist.
	 */
	public Passenger getNearestPassenger(Elevator lift)
	{	
		// find all nearby passengers
		Passenger[] nearby = new Passenger[4];
		
		// find nearest passengers above
		for (int i = lift.getCurrentFloor(); i < this.getFloorCount(); i++)
		{
			if (nearby[0] == null && this.upQueues[i].size() > 0)
				nearby[0] = (Passenger) this.upQueues[i].peek();
			if (nearby[1] == null && this.downQueues[i].size() > 0)
				nearby[1] = (Passenger) this.downQueues[i].peek();
		}
		
		// find nearest passengers below
		for (int i = lift.getCurrentFloor(); i >= 0; i--)
		{
			if (nearby[2] == null && this.upQueues[i].size() > 0)
				nearby[2] = (Passenger) this.upQueues[i].peek();
			if (nearby[3] == null && this.downQueues[i].size() > 0)
				nearby[3] = (Passenger) this.downQueues[i].peek();
		}
		
		// if we're already moving, we only need to consider one passenger
		if (lift.getDirection() == Elevator.Direction.UP)
			return nearby[0];
		
		if (lift.getDirection() == Elevator.Direction.DOWN)
			return nearby[3];
		
		// Direction is IDLE...find any nearest passenger.
		Passenger best = null;
		int bestDist = 0;
		for (int i = 0; i < nearby.length; i++)
		{
			if (nearby[i] != null && best == null)
			{
				// found first nearby passenger
				best = nearby[i];
				bestDist = Math.abs(lift.getCurrentFloor() - best.getStartFloor());
			}
			else if (nearby[i] != null)
			{
				// found another nearby passenger; are they closer?
				int dist = Math.abs(lift.getCurrentFloor() - nearby[i].getStartFloor());
				if (dist < bestDist)
				{
					best = nearby[i];
					bestDist = dist;
				}
			}
		}
		
		return best;
	}
	
	/**
	 * Gets a queue of passengers waiting to board an elevator.  This queue
	 * contains passengers at the given elevator's current floor who 
	 * would like to travel in the same direction the elevator is traveling.
	 * In other words, this is the queue from which passengers would board
	 * the given elevator if there is room.
	 * <p>
	 * Note that this method prefers the upwards queue when the elevator
	 * direction is idle.
	 * 
	 * @param lift the elevator that is stopped at a floor
	 * @return the queue of passengers or null if the elevator's floor
	 * is invalid
	 */
	public Queue getFloorQueue(Elevator lift)
	{
		Queue queue = null;
		if (this.isFloorValid(lift.getCurrentFloor()))
		{
			// prefer up queue
			queue = this.upQueues[lift.getCurrentFloor()];
			
			// unless we're headed down or we're idling and the up queue is empty
			if (lift.getDirection() == Elevator.Direction.DOWN ||
				(lift.getDirection() == Elevator.Direction.IDLE &&
				queue.size() == 0))
			{
				queue = this.downQueues[lift.getCurrentFloor()];
			}
		}
		else
		{
			System.err.println("ElevatorBank.getFloorQueue got an elevator that found a new floor:" + lift);
		}
		
		return queue;
	}

	/**
	 * Returns a string representation of the elevator bank. This string
	 * contains the number of elevators and floors in the elevator bank as well
	 * as the count of passengers waiting in each queue on each floor. For
	 * example:
	 * <p>
	 * 
	 * <pre>
	 * Bank ( 3 els,   5 fls):
	 *    4:  0 u,  1 d
	 *    3:  1 u,  0 d
	 *    2:  0 u,  1 d
	 *    1:  1 u,  0 d
	 *    0:  0 u,  0 d
	 * </pre>
	 */
	public String toString()
	{
		StringBuilder str = new StringBuilder(
			String.format("Bank (%2d els, %3d fls):\n", this.getElevatorCount(), this.getFloorCount()));
		
		for (int i = this.getFloorCount()-1; i >= 0; i--)
		{
			str.append(String.format("\t%3d: %2d u, %2d d\n", i, this.upQueues[i].size(), this.downQueues[i].size()));
		}
		
		return str.toString();
	}
	
	/**
	 *  This method will update the state of the ElevatorBank as a whole. The information processed
	 *  in this updateState method is used for the group strategies (GROUP,GROUP_2,GROUP_3)
	 *  <p>
	 *  Non-empy elevators will function more or less exactly as they would for the individual strategies.
	 *  However the empty elevators will do the following depending on the strategy method
	 *  <p>
	 *  For GROUP and GROUP_2 strategies:
	 *  Each empty elevator will be assigned a targetFloor and targetDirection for that floor.
	 *  The floor will be chosen by finding the Queue (either up or down) that has the most waiting passengers.
	 *  This is done using a priorityQueue for the Queues ( see QueueSorter.java ). This is done in the emptyRule() method
	 *  <p>
	 *  For GROUP_3 strategy:
	 *  This will find the closest empty elevator to the Queue that has the most waiting passengers.Also done using a priorityQueue.
	 *  The floor assignment is done in the emptyRule2() method
	 *  <p>
	 *  This method will find out which elevators are empty and then call the appropriate emptyRule method
	 *  @param scape Landscape that the simulation is on
	 *  @return true, this bank never dies
	 */
	public boolean updateState(Landscape scape) {
		boolean[] emptyElevators =  new boolean[this.elevators.length];
		int emptyCount = 0;
		
		
				
		// this finds out which elevators are in which state and what direction they are traveling in so that
		// we can only act on ones that are in similar situations
		for( int i = 0 ; i < this.elevators.length ; i++){
			// empty and has no target floor
			if( this.elevators[i].isEmpty() ){
				emptyElevators[i] = true;
				emptyCount++;
			}
			else{
				emptyElevators[i] = false;
			}
		}
		
		if( ElevatorBank.strategy == ElevatorBank.STRATEGY.GROUP_3){
			emptyRule2(emptyElevators, emptyCount);
		}
		else{
			emptyRule(emptyElevators, emptyCount);
		}
		// never dies
		return true;
	}
	
	
	/**
	 *  This method is used for the GROUP_3 strategy. it will use QueueSorter to find the Queue with the most waiting
	 *  passengers, regardless of the direction of travel. The working from the largest Queue it will assign the closest empty
	 *  elevators to travel to these Queues.
	 *  <p>
	 *  Once an elevator has been assigned a targetFloor it will keep this targetFloor until it reaches the targetfloor or some other elevator picks
	 *  up the passengers before it reaches it. 2 empty elevators will not be assigned the same targetFloor and targetDirection
	 * @param emptyElevators boolean array where each index corresponds to the elevator in the elevator field. True means the elevator is empty. false means it's not empty
	 * @param emptyCount this is an integer count of the number of empty elevators.
	 */
	private void emptyRule2(boolean[] emptyElevators, int emptyCount){
		//create a  sorted list of all of the floors based on the number of people waiting either to go up or down
		QueueSorter qs = new QueueSorter(this.upQueues.length*2+1);
		for(int i = 0; i < this.upQueues.length ; i++){
			//add both the queue of people waiting to go up and down
			qs.add(( ElevatorQueue )this.upQueues[i]  );
			qs.add(( ElevatorQueue )this.downQueues[i]);
		}
		
		// for every empty elevator
		for( int i = 0 ; i < emptyCount; i++ ){
			// get the fullest floor Queue
			ElevatorQueue tempQueue = qs.remove();
			//floor this queue is on
			int floor = tempQueue.getFloor();
			// do nothing if there is nobody in the queue (less non empty queues than elevators), no non empty queue's left, break from for loop
			if( tempQueue.size() == 0){
				break;
			}
			
			
			// this checks to see if another elevator is headed to the target floor
			boolean check = false;
			//for each elevator
			for( int j = 0; j < this.elevators.length ; j++ ){
				// if another elevator is headed to this target floor
				if( this.elevators[j].getTargetFloor() == floor &&
					 this.elevators[j].getTargetDirection() == tempQueue.getDirectionQueue()){
					check = true;
				}
			}
			// if another elevator is already headed to this queue, continue to next biggest Queue
			if( check == true){
				continue;
			}
			
			
			// initial values, will always be overwritten
			int tempIndex = -1;
			int tempDistance = -9999;
			// this will get the closest empty elevator, with no targetFloor set that is also empty
			for( int j = 0 ; j < emptyElevators.length ; j++){
				if( emptyElevators[j] == true && this.elevators[j].getTargetFloor() < 0){
					//get the distance the elevator is from the Queue
					
					int distance = Math.abs(this.elevators[j].getCurrentFloor() - floor);
					// if this is the first empty Elevator checked, set it's values as the default
					if( tempDistance < 0 ){
						tempDistance = distance;
						tempIndex = j;
					}
					// if this elevator is closest elevator to the Queue checked so far
					else if( distance < tempDistance ){
						// set the new minimum distance
						tempDistance = distance;
						// index of this elevator
						tempIndex = j;
					}
				}
			}
			
			// If there is an elevator that is empty (should always be if it gets this far). set the target information
			// for this elevator to head toward the Queue
			if( tempIndex >= 0){
				Elevator.Direction d = tempQueue.getDirectionQueue();
				//set targetfloor / target direction
				this.elevators[tempIndex].setTargetFloor(floor);
				this.elevators[tempIndex].setTargetDirection(d);
				
				// this elevator has been assigned to a direction/ place to go, so we don't 
				// want to consider it for future Queue's
				emptyElevators[tempIndex] = false;
				
				// Set the direction that the elevator needs to go in to make it to the targetFloor
				if( this.elevators[tempIndex].getCurrentFloor() < floor){
					this.elevators[tempIndex].setDirection(Elevator.Direction.UP);
				}
				else{
					this.elevators[tempIndex].setDirection(Elevator.Direction.DOWN);
				}
			}
		}
		
		
		// This is for any remaining empty elevators that were not assigned a targetFloor (i.e. if there
		// are more empty elevators than queues with passengers waiting.
		for( int i = 0 ; i < this.elevators.length ; i++){
			if( emptyElevators[i] == true){
				// half of the elevators will wait at the top and half will wait at the bottom
				if( i < this.elevators.length/2){
					this.elevators[i].setDirection(Elevator.Direction.DOWN);
				}
				else{
					this.elevators[i].setDirection(Elevator.Direction.UP);
				}
			}
		}
		
	}
	
	
	

	/**
	 * This method will assign targetFloors and targetDirections for the empty elevators in the ElevatorBank.
	 * The information from this method will only be used by the Elevators in the group strategies
	 * i.e. GROUP,GROUP_2.
	 * <p>
	 * This method will, for each empty elevator with no targetFloor, assign it a targetFloor and Direction
	 * to head for. The targetFloor will be determined by finding the Queue that has the most passengers waiting for
	 * an elevator in a given direction. The targetDirection is the direction that the elevator will travel in when
	 * the elevator reaches the targetFloor
	 * <p>
	 * There is checking to make sure that no 2 empty elevators have the same targetFloor and targetDirection
	 * @param emptyElevators boolean array where each index corresponds to the elevator in the same index in the 
	 * elevators[] data field in this class. True means that the elevator is empty, false means it is not empty
	 * @param emptyCount this is a count of the number of empty elevators at this iteration
	 */
	private void emptyRule(boolean[] emptyElevators, int emptyCount){
		// create a new QueueSorter which will tell us where the largest Queue of waiting passengers is
		QueueSorter qs = new QueueSorter(this.upQueues.length*2+1);
		for( int k = 0 ; k < this.upQueues.length ; k++){
			// add both directions
			qs.add( (ElevatorQueue)this.upQueues[k]);
			qs.add( (ElevatorQueue)this.downQueues[k]);
		}
		
		// For each elevator in the bank
		for (int i = 0 ; i < this.elevators.length ; i++ ){
			// if the elevator is empty and does not already have a targetFloor assigned
			if( emptyElevators[i] == true && this.elevators[i].getTargetFloor() <= 0 ){
				//get the largest Queue from our list
				ElevatorQueue eq = qs.remove();
				// if this queue size is 0 then there are no waiting passengers and no elevators will be
				// assigned to move that are empty
				if( eq.size() == 0 ){
					// all of the remaining queues are empty
					break;
				}
				// floor of this queue
				int floor = eq.getFloor();
				Elevator.Direction d = eq.getDirectionQueue();
				
				
				
				// this checks to see if another elevator is headed to the target floor
				boolean check = false;
				//for each elevator
				for( int j = 0; j < this.elevators.length ; j++ ){
					
					// if another elevator is headed to this target floor, that is not the same
					// elevator as the one being assigned this targetFloor. Also make sure it is in the same direction
					if( this.elevators[j].getTargetFloor() == floor &&
							i != j && this.elevators[j].getTargetDirection() == d){
						check = true;
					}
				}
				// if there is another elevator, continue on
				if( check == true){
					continue;
				}
				
				//otherwise set the targetfloor and direction
				this.elevators[i].setTargetFloor(floor);
				this.elevators[i].setTargetDirection(d);
				//set direction to get to floor
				if( this.elevators[i].getCurrentFloor() < floor){
					this.elevators[i].setDirection(Elevator.Direction.UP);
				}
				else{
					this.elevators[i].setDirection(Elevator.Direction.DOWN);
				}
				
				// we have no assigned this elevator to a targetFloor, remove it from out list of emtpyElevators
				emptyElevators[i] = false;
				
			}
			// if we have an elevator that is Empty but is still heading toward it's targetFloor, check to see 
			// that there are still waiting passengers at the targetFloor
			else if( emptyElevators[i] == true ){
				ElevatorQueue temp = null;
				//check to see if anybody has picked up the passengers it was going to, find the correct Queue on
				// the correct floor
				if( this.elevators[i].getTargetDirection() == Elevator.Direction.DOWN){
					temp = ( ElevatorQueue ) this.downQueues[this.elevators[i].getTargetFloor()];
				}
				else{
					temp = (ElevatorQueue) this.upQueues[this.elevators[i].getTargetFloor()];
				}
				// somebody picked up the passengers, reset
				if( temp.size() == 0 ){
					this.elevators[i].setTargetFloor(-1);
					this.elevators[i].setTargetDirection(null);
					// repeat so that it will find a floor to go to
					i--;
				}
				
			}
		}
	}
	
	
	/**
	 * no draw method
	 */
	public void draw(Graphics g, int x, int y, int scale) {
		return;
	}
	
	/**
	 * Tests the elevator bank by creating a new bank, adding
	 * passengers to it, and seeing where an elevator would stop traveling
	 * up and down.
	 * 
	 * @param args not used
	 */
	public static void main(String args[])
	{
		// initialize an elevator bank
		ElevatorBank bank = new ElevatorBank(0, 0, 3, 5, 8);
		System.out.println("Init => " + bank);
		
		// fill the bank with some passengers
		for (int i = 0; i < bank.getFloorCount(); i++)
		{
			if (i % 2 == 0)
				bank.addPassenger(new Passenger(i, i - 1));
			else
				bank.addPassenger(new Passenger(i, i + 1));
		}
		System.out.println("Adds => " + bank);
		
		// get an elevator
		Elevator lift = bank.elevators[0];
		
		// see who the elevator would get going up
		lift.setTargetDirection(Elevator.Direction.UP);
		for (int i = 0; i < bank.getFloorCount(); i++)
		{
			lift.setCurrentFloor(i);
			System.out.println(lift + " => " + bank.getNearestPassenger(lift));
			System.out.println("\tqueue => " + bank.getFloorQueue(lift));
		}
		
		// see who the elevator would get going down
		lift.setTargetDirection(Elevator.Direction.DOWN);
		for (int i = bank.getFloorCount()-1; i >= 0; i--)
		{
			lift.setCurrentFloor(i);
			System.out.println(lift + " => " + bank.getNearestPassenger(lift));
			System.out.println("\tqueue => " + bank.getFloorQueue(lift));
		}
	}

	
	
	
}
