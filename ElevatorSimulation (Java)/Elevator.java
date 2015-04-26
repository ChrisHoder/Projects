// FILE: Elevator.java
// AUTHOR: Brian Eastwood modified by Chris Hoder
// DATE: 11/14/2011
// PROJECT 08


import java.awt.Color;
import java.awt.Graphics;
import java.util.Comparator;
import java.util.Queue;

/**
 * Represents an elevator in an elevator simulation.  The elevator travels
 * between floors picking up and dropping off passengers.  It maintains
 * a priority queue of passengers riding in the elevator.
 * 
 * 
 * @author bseastwo
 */
public class Elevator extends SimObject
{	
	/**
	 * Represents the current traveling state of an elevator.  An elevator
	 * can be moving up or down or be idle.
	 */
	public enum Direction { DOWN, IDLE, UP }
	
	
	/**
	 * Represents the current action as directed by the Elevator Bank. If this is INDIV it will act
	 * on it's own strategy
	 */
	public enum Action { MOVE_UP, MOVE_DOWN, OPEN_DOORS, CLOSE_DOORS}
	private Action act;
	
	private int targetFloor;
	private Direction targetDirection;
	
	// the penalty incurred from stopping at a floor
	public static int DOOR_TIME = 5;
	// the maximum number of floors one can move at a time
	public static int FLOOR_DMAX = 1;

	private int currentFloor;
	private Direction direction;
	private PassengerGroup passengers;
	private ElevatorBank bank;
	private int waitTime;
	
	/**
	 * Create an elevator in an elevator bank with a maximum capacity.
	 * 
	 * @param bank the elevator bank this elevator belongs to
	 * @param capacity the maximum number of passengers in this elevator
	 */
	public Elevator(ElevatorBank bank, int capacity, int startFloor)
	{
		super(5, 5);
		this.bank = bank;
		this.passengers = new PassengerGroup(capacity);
		
		this.currentFloor = startFloor;
		this.direction = Direction.IDLE;
		this.waitTime = 0;
		
		this.targetFloor = -1;
	}

	public int getCurrentFloor() { return this.currentFloor; }
	public void setCurrentFloor(int floor) { this.currentFloor = floor; }
	
	/**
	 * this method sets the target floor for this elevator
	 * @param floor floor that the Elevator should head to
	 */
	public void setTargetFloor(int floor){ this.targetFloor = floor; }
	/**
	 * this method sets the direction the elevator is going to head once it reaches the target floor
	 * @param d Elevator.Direction which is either UP or DOWN
	 */
	public void setTargetDirection(Direction d ){ this.targetDirection = d; }
	/**
	 * This method returns the target floor for this elevator
	 * @return  integer of the floor
	 */
	public int getTargetFloor(){ return this.targetFloor; }
	/**
	 * Returns the direction that the elevator is going to head once it reaches the targetFloor
	 * @return Elevator.Direction which is either UP or DOWN
	 */
	public Elevator.Direction getTargetDirection(){ return this.targetDirection;} 
	
	/**
	 * Gets the Direction the elevator is traveling.
	 * @return the direction
	 */
	public Direction getDirection() { return this.direction; }
	
	
	/**
	 * Returns the Passengers in the elevator
	 * @return the passengers in a PassengerGroup class
	 */
	public PassengerGroup getPassengers(){
		return this.passengers;
	}
	
	/**
	 * Returns boolean whether it the elevator is empty or not
	 * @return true if elevator is empty, false if non-empty
	 */
	public boolean isEmpty(){
		return this.passengers.isEmpty();
	}
	/**
	 * Returns boolean as to whether or not the elevator is full or not
	 * @return false if the elevator is not full, true if the elevator is full;
	 */
	public boolean isFull(){
		return this.passengers.isFull();
	}
	
	
	/**
	 * returns the time the elevator has to wait before it can move (i.e. time till the doors shut
	 * @return integer time in terms of iterations
	 */
	public int getWaitTime(){
		return this.waitTime;
	}
	
	/**
	 * this reduces the waittime int field by 1
	 */
	public void decrementWaitTime(){
		this.waitTime--;
	}
	
	/**
	 * Sets the direction the elevator is traveling. This modifies
	 * the ordering used on the passengers riding the elevator, and
	 * so should only be called when the elevator is empty.
	 * 
	 * @param direction2 the new direction for the elevator
	 */
	public void setDirection(Elevator.Direction direction2) 
	{ 
		this.direction = direction2;
		if (this.direction == Direction.UP)
		{
			this.passengers.useMinFloors();
		}
		else if (this.direction == Direction.DOWN)
		{
			this.passengers.useMaxFloors();
		}
	}
	
	/**
	 * Returns a string representation of this elevator.  This includes
	 * the elevator's current floor, direction, number of passengers,
	 * current wait time before the doors close, and the passenger with
	 * highest priority.  For example:
	 * <p>
	 * <tt>Elevator ( 0,    UP):  2 pass,  0 wait, Passenger: [ 0 ->  3,   0]</tt>
	 */
	public String toString()
	{
		return String.format(
			"Elevator (%2d, %5s): %2d pass, %2d wait, %s", 
			this.currentFloor, this.direction, this.passengers.getSize(), this.waitTime, this.passengers.getNext());
	}
	
	/**
	 * Default implementation for handling the case where the doors
	 * open on a particular floor.
	 * <p>
	 * Note that the direction for this elevator should be set before
	 * this function is called, otherwise we risk not ordering passengers
	 * properly as they board.
	 * <p>
	 * First, let as many passengers off at this floor as want to get off,
	 * then let anyone on who wants to travel in the same direction as
	 * the elevator.
	 */
	public void openDoors()
	{
		assert (this.direction != Direction.IDLE) : 
			"Elevator should decide what direction to go before opening doors.";
		
		// incur the penalty for opening the doors
		this.waitTime = Elevator.DOOR_TIME;
		
		// let passengers off, if anyone has reached their destination
		while (!this.passengers.isEmpty() &&
			this.getCurrentFloor() == this.passengers.getNext().getTargetFloor())
		{
			Dispatch.instance().consumePassenger(this.passengers.remove(), this);
		}
		
		// see if there are passengers waiting to get on
		Queue floorQueue = this.bank.getFloorQueue(this);
		Passenger nextWaiter = (Passenger) floorQueue.peek();
		while (nextWaiter != null &&
			!this.passengers.isFull())
		{
			this.passengers.add((Passenger) floorQueue.poll());
			nextWaiter.setOnboard(true);
			nextWaiter = (Passenger) floorQueue.peek();
		}
	}
	
	/**
	 * Determines what an elevator does when it is empty.
	 * <p>
	 * If the elevator is currently at a floor where it can pick up
	 * passengers, do so. The elevator turns around at the bottom and
	 * top floors. Otherwise, the elevator continues in the direction
	 * it was headed.
	 * <p>
	 * Returns a negative number to move down, positive number to move up,
	 * and 0 to stay put.
	 * 
	 * @return an int that determines what direction to move
	 */
	private int emptyRule()
	{
		int move = 0;
		
		// save current direction so we can continue if we do not
		// pick up any passengers on this floor
		Direction dir = this.getDirection();
				
		// find the closest waiting passenger in either direction
		this.direction = Direction.IDLE;
		Passenger nextWaiting = this.bank.getNearestPassenger(this);
		
		// if we are on the floor that the nearest passenger is on
		if (nextWaiting != null &&
			this.getCurrentFloor() == nextWaiting.getStartFloor())
		{
			// get passengers if we are on their floor
			// decide on our direction before opening door
			if (this.getCurrentFloor() < nextWaiting.getTargetFloor())
				this.setDirection(Direction.UP);
			else
				this.setDirection(Direction.DOWN);
				
			// pick up passengers from current floor
			this.openDoors();
		}
		// if we are heading down to pick up the next closest passenger
		else if ( nextWaiting != null &&
				  this.getCurrentFloor() > nextWaiting.getStartFloor() ){
			this.setDirection(Direction.DOWN);
		}
		// we are heading up to the next closest passenger
		else if ( nextWaiting != null &&
				  this.getCurrentFloor() < nextWaiting.getStartFloor() ){
			this.setDirection(Direction.UP);
		}
		// we are on the bottom floor, need to head up
		else if (nextWaiting != null && this.getCurrentFloor() == 0 && 
				dir != Direction.UP)
		{
			// switch directions at the bottom of the bank
			this.direction = Direction.UP;
			this.openDoors();
		}
		// even if there is no passenger waiting, we should be heading up.
		else if ( this.getCurrentFloor() == 0 &&
				  dir != Direction.UP )
		{
			//switch directions at bottom of the bank
			this.direction = Direction.UP;
		}
		// if we are on the top floor we should begin to head down
		else if (this.getCurrentFloor() == this.bank.getFloorCount()-1 &&
				dir != Direction.DOWN)
		{
			// switch directions at the top of the bank
			this.direction = Direction.DOWN;
			// only open doors if somebody is waiting
			if( nextWaiting != null && nextWaiting.getStartFloor() == this.getCurrentFloor()){
				this.openDoors();
			}
		}
		// no people in the getNearestPassenger, then begin to head back down
		else
		{
			this.direction = Direction.DOWN;
		}
						
		// move in the direction we are headed
		move = this.getDirection() == Direction.DOWN ? -Elevator.FLOOR_DMAX : +Elevator.FLOOR_DMAX;
		// return the move direction (either +1 or -1)
		return move;
	}
	
	/**
	 * Determines what an elevator does when it is not empty. This 
	 * method is used for simulations that do not involve communicating with
	 * other elevators (i.e. simulations INDIV and INDIV_2 )
	 * <p>
	 * If the current floor is one where passengers need to be let off,
	 * the elevator opens its doors. Otherwise, the elevator continues in
	 * the direction it was headed.
	 * <p>
	 * If the simulation being run is INDIV_2 the elevator will also check to see if
	 * there are any waiting passengers on this floor who want to travel in any direction.
	 * if there are it will change directions and open it's doors.
	 * <p>
	 * Returns a negative number to move down, positive number to move up,
	 * and 0 to stay put.
	 * 
	 * @return an int that indicates what direction to move
	 */
	private int nonEmptyRule()
	{
		
		int move = 0;
		
		// we have passengers; find the one with highest priority
		Passenger nextAboard = this.passengers.getNext();
		
		// get the nextWaiting passenger in the direction of motion
		Passenger nextWaiting = this.bank.getNearestPassenger(this);
		
		// see if someone wants to get off the elevator here
		if (this.getCurrentFloor() == nextAboard.getTargetFloor())
		{
			this.openDoors();
		}
		
		//if somebody wants to get on on this floor and is headed in the right direction and the elevator is not empty
		else if(nextWaiting != null && !this.passengers.isFull() &&
				this.getCurrentFloor() == nextWaiting.getStartFloor())
			{
				this.openDoors();
			}	
		// if we are running the STRATEGY INDIV_2 we will run the following code
		if( ElevatorBank.strategy == ElevatorBank.STRATEGY.INDIV_2 ){
			// if the elevator became empty in this iteration (let all of the passengers off)
			if ( this.isEmpty() ){
				// set the direction to idle, and find the nearest passengers
				this.setDirection(Direction.IDLE);
				nextWaiting = this.bank.getNearestPassenger(this);
				// if there is somebody waiting on this floor (could be going in either direction)
				if( nextWaiting != null && nextWaiting.getStartFloor() == this.currentFloor ){
					// determine the direction and set the Elevator to that direction
					if( nextWaiting.getStartFloor() < nextWaiting.getTargetFloor() ){
						this.setDirection(Direction.UP);
					}
					else{
						this.setDirection(Direction.DOWN);
					}
					// open the doors for this waiting passenger
					this.openDoors();	
				}
			}
		}
		
		// move in the direction we are headed
		move = this.getDirection() == Direction.UP ? +Elevator.FLOOR_DMAX : -Elevator.FLOOR_DMAX;

		return move;
	}
	
	
	/**
	 * Determines what an elevator does when it is not empty. This mehtod is
	 * used for the simulations that involve the elevators working together to 
	 * determine the optimal plan of action (i.e. strategies GROUP, GROUP_2
	 * and GROUP_3)
	 * <p>
	 * If the current floor is one where passengers need to be let off,
	 * the elevator opens its doors. Otherwise, the elevator continues in
	 * the direction it was headed.
	 * <p>
	 * If the elevator became empty while dropping off passengers, it will
	 * check the floor to see if there are any waiting passengers. They can be
	 * Traveling in any direction.
	 * <p>
	 * Returns a negative number to move down, positive number to move up,
	 * and 0 to stay put.
	 * 
	 * @return an int that indicates what direction to move
	 */
	private int groupNonEmptyRule()
	{
		int move = 0;
		
		// we have passengers; find the one with highest priority
		Passenger nextAboard = this.passengers.getNext();
		
		// get the nextWaiting passenger in the direction of motion
		Passenger nextWaiting = this.bank.getNearestPassenger(this);
		
		// see if someone wants to get off the elevator here
		if (this.getCurrentFloor() == nextAboard.getTargetFloor())
		{
			this.openDoors();
		}
		//if there are waiting passengers and the elevator is not full, open the doors and let 
		// them board
		else if(nextWaiting != null && !this.passengers.isFull() &&
				this.getCurrentFloor() == nextWaiting.getStartFloor())
			{
				this.openDoors();
			}
		
		// if the elevator became empty
		if ( this.isEmpty() ){
			//reset the target floor and direction (so that if it remains empty it will
			// get a new target floor in the ElevatorBank's updateState
			this.targetFloor = -1;
			this.targetDirection = null;
			//set direction to IDLE to check both directions
			this.setDirection(Direction.IDLE);
			nextWaiting = this.bank.getNearestPassenger(this);
			// if there is a waiting passenger on this floor, open doors
			if( nextWaiting != null && nextWaiting.getStartFloor() == this.currentFloor ){
				if( nextWaiting.getStartFloor() < nextWaiting.getTargetFloor() ){
					this.setDirection(Direction.UP);
				}
				else{
					this.setDirection(Direction.DOWN);
				}
				this.openDoors();
			}
			
			
		}// move in the direction we are headed
		
		move = this.getDirection() == Direction.UP ? +Elevator.FLOOR_DMAX : -Elevator.FLOOR_DMAX;

		return move;
	}
	
	
	/**
	 * This method determines the plan of action of the Elevator when a simulation
	 * is being run that has the elevators acting as a group and not just individually
	 * (i.e. simulation strategies: GROUP,GROUP_2,GROUP_3). This method is for when 
	 * the elevator is empty.
	 * <p>
	 *  If the elevator is at it's targetFloor (as designated by the ElevatorBank), then it 
	 *  will open it's doors and head in the targetDirection.
	 *  <p>
	 *  If we are running the following simulations GROUP_2 or GROUP_3 we will also
	 *  check to see if there are passengers at this floor that are travelling in the direction of the elevator
	 *  and in the direction of the Queue at the targetfloor.
	 *  <p>
	 *  returns a negative number to move down, positive number to move up
	 * @return integer corresponding to the elevator direction of motion
	 */
	private int groupEmptyRule(){
		
		int move = 0;
		// if we are at the target floor
		if( this.targetFloor >= 0 &&  this.currentFloor == this.targetFloor ){
			// change to the targetDirection of travel
			this.setDirection(this.targetDirection);
			// get passengers
			Passenger nextWaiting = this.bank.getNearestPassenger(this);
			// if we still have a passenger waiting
			if( nextWaiting != null && this.currentFloor == nextWaiting.getStartFloor() ){
				this.openDoors();
				// reset target data
				this.targetFloor  = -1;
				this.targetDirection = null;
			}
			// reset target data since there is nobody waiting
			else{
				this.targetDirection = null;
				this.targetFloor = -1;
			}
			
			
		}
		// in the case where we are not at the targetfloor yet
		// we are moving toward a target direction
		else{
			// For the GROUP_2 and GROUP_3 strategies, it will check to see if any passengers are waiting to go
			// in the direction of the elevator. Though it will only open it's doors if the elevator is also moving in the direction
			// of the targetDirection (to avoid annoying boundry cases)
			if( ElevatorBank.strategy == ElevatorBank.STRATEGY.GROUP_2 ||
					ElevatorBank.strategy == ElevatorBank.STRATEGY.GROUP_3){
				Passenger nextWaiting = this.bank.getNearestPassenger(this);
				// if there are passengers waiting at this floor in the direction of the motion of the elevator
				if( nextWaiting != null && this.currentFloor == nextWaiting.getStartFloor()){
					// if the person on this floor is going down
					if( nextWaiting.getStartFloor() < nextWaiting.getTargetFloor() ){
						//we are both going the same direction, down (assuming everybody is going ot bottom makes this appropriate
						if( this.direction == Elevator.Direction.DOWN && this.getTargetDirection() == Elevator.Direction.DOWN){
							this.openDoors();
							// reset data now that the elevator is no longer empty
							this.targetFloor = -1;
							this.targetDirection = null;
						}
					}
					// if passenger waiting is going up / and elevator going up
					else{
						if( this.direction == Elevator.Direction.UP && this.getTargetDirection() == Elevator.Direction.UP){
							this.openDoors();
							// reset data as the elevator is no longer empty
							this.targetFloor = -1;
							this.targetDirection  = null;
						}
					}
				}
			}
		}
		// if we are traveling in the direction of the target floor still, find the direction, set it and move
		if( this.targetFloor >= 0){
			if( this.currentFloor < this.targetFloor){
				this.setDirection(Direction.UP);
			}
			else {
				this.setDirection(Direction.DOWN);
			}
		}
		
		move = this.getDirection() == Direction.UP ? +Elevator.FLOOR_DMAX : -Elevator.FLOOR_DMAX;

		return move;
		
	}
	
	
	
	/**
	 * Updates the elevator by dropping off or picking up passengers at
	 * the current floor, if needed, or moving one floor in either
	 * direction.
	 * <p>
	 * This method will act differently depending on what simulation strategy being used
	 * Group strategies( GROUP,_2 and _3) recieve information from the ElevatorBank in the following 
	 * data fields: targetFloor and targetDirection
	 * <p>
	 * this will always return true because the elevators don't die
	 */
	public boolean updateState(Landscape scape)
	{
		int move = 0;
		// if we are running a group strategy (GROUP,GROUP_2, GROUP_3)
		if( ElevatorBank.strategy == ElevatorBank.STRATEGY.GROUP ||
				ElevatorBank.strategy == ElevatorBank.STRATEGY.GROUP_2 ||
				  ElevatorBank.strategy == ElevatorBank.STRATEGY.GROUP_3){
			// if the elevator is empty
			if (this.passengers.isEmpty())
			{
				move = this.groupEmptyRule();
			}
			// non-empty elevator
			else
			{
				move = this.groupNonEmptyRule();
			}
			
		}
		// running an INDIV strategy
		else{
			// Choose one of two behaviors, based on whether the elevator
			// is empty or has passengers.
			if (this.passengers.isEmpty())
			{
				move = this.emptyRule();
			}
			else
			{
				move = this.nonEmptyRule();
			}
		}
		
		
			// See if we can move
			if (this.waitTime > 0)
			{
				// we have to wait for the doors to close--count down
				this.waitTime--;
			}
			else
			{
				// we are free to move--move
				this.currentFloor += move;
				
				// make sure we didn't jump the tracks
				this.currentFloor = Math.max(this.currentFloor, 0);
				this.currentFloor = Math.min(this.currentFloor, this.bank.getFloorCount() - 1);
			}
		
		// elevators never die
		return true;
	}

	/**
	 * Draws an elevator as a stack of floors.  Each floor is a rectangle
	 * labeled with the floor number.  The elevator carriage is drawn as
	 * a solid rectangle on the elevator's current floor.  If the elevator
	 * has passengers, the carriage has a filled in circle within it.
	 */
	public void draw(Graphics g, int x, int y, int scale)
	{
		// draw each floor separately
		for (int floor = 0; floor < this.bank.getFloorCount(); floor++)
		{
			int ypos = y + (this.bank.getFloorCount() - floor) * scale;
			g.setColor(Color.black);
			
			// draw a box for the floor and label it
			g.drawRect(x, ypos, 3 * scale, scale);
			g.drawString("" + floor, x + 1, ypos + scale - 1);
			
			// draw the elevator carriage on the proper floor
			if (floor == this.getCurrentFloor())
			{
				g.setColor(Color.blue);
				g.fillRect(x + scale, ypos, 2 * scale, scale);
				
				// fill the carriage if there's a passenger
				if (!this.passengers.isEmpty())
				{
					g.setColor(Color.yellow);
					g.fillOval((int) (x + 1.5 * scale), ypos, scale-1, scale-1);
				}
			}
		}
	}
	
	/**
	 * Tests the elevator class by creating a new elevator and adding a
	 * few passengers.
	 * 
	 * @param args not used
	 */
	public static void main(String[] args)
	{
		Elevator lift = new Elevator(null, 10,0);
		System.out.println("Init => " + lift);
		
		lift.setDirection(Direction.UP);
		lift.passengers.add(new Passenger(0, 3));
		lift.passengers.add(new Passenger(0, 4));
		System.out.println("Adds => " + lift);
	}

}
