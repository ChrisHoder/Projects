// FILE: ElevatorQueue.java
// AUTHOR: Chris Hoder
// DATE: 11/14/2011
// PROJECT 08


//imports
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.Queue;


/**
 * This Queue is linked list that implements Queue. It also stores the floor number that the Elevator Queue sits on
 * and the direction that it's passengers want to travel in. Some of the methods to make it implement Queue are left blank
 * and are unusable.
 * @author chris
 *
 */
public class ElevatorQueue implements Queue {
	//data declarations
	private int size;
	private ListNode head,tail;

	/**
	 * This is the floor that the Queue sits on
	 */
	private final int floorNumber;
	
	
	/**
	 * This is the Direction that the Passengers in the Queue want to travel in
	 */
	private final Elevator.Direction dir;
	
	
	/**
	 * This constructor will initialize a Queue at the given floor and with passengers travelling in the 
	 * given direction
	 * @param floorNumber floor that the Queue sits on
	 * @param dir Direction that passengers in the Queue want to travel
	 */
	public ElevatorQueue( int floorNumber , Elevator.Direction dir  ){
		//super(x,y);
		// initially 0
		this.size = 0;
		//floor this Queue is on
		this.floorNumber = floorNumber;
		// initially empty
		this.head = this.tail = null;
		// Direction Passengers want to travel in
		this.dir = dir;
	}

	
	/**
	 * Returns the size of the Queue
	 * @return size of queue
	 */
	public int size(){
		return this.size;
	}
	/**
	 * returns the floor that the Queue sits on
	 * @return floor the Queue is on
	 */
	public int getFloor(){
		return this.floorNumber;
	}
	/**
	 * Returns the direction that the passengers want to travel
	 * @return direction
	 */
	public Elevator.Direction getDirectionQueue(){
		return this.dir;
	}
	
	/**
	 * Adds a new Passenger to the Queue. Throws IllegalArgumentException of it cannot add. Otherwise
	 * this method acts exactly like offer
	 * @param o to add to the Queue
	 * @return returns true always
	 */
	public boolean add(Object o){
		try{
			this.offer(o);
		}
		catch( IllegalArgumentException e){
			throw new IllegalArgumentException();
		}
		return true;
	}
	
	/**
	 * This method adds another Passenger to the Queue. Throws an IllegalArgumentException if anything
	 * but a SimObject is added to the list.
	 * @param o addes this object to the Queue if possible
	 * @return returns true if it is added (always)
	 */
	public boolean offer(Object o){
		if(!( o instanceof SimObject) ){
			throw new IllegalArgumentException();
		}
		SimObject obj = ( SimObject )o;
		ListNode node = new ListNode(obj,null);
		if(this.isEmpty()){
			this.head = this.tail =node;
		}
		else{
			this.tail.next = node;
			this.tail = tail.next;
		}
		this.size ++;
		
		// always able to add?
		return true;
	}
	
	
	/**
	 * This method will remove the SimObject from the Queue and return the removed SimObject
	 * @return SimObject removed from the Queue, null if the Queue is empty
	 */
	public SimObject poll(){
		SimObject obj = null;
		// if it is not empty
		if(!this.isEmpty()){
			obj = this.head.data;
		
			this.head = this.head.next;
			if( this.isEmpty() ){
				this.tail = null;
			}
			
			this.size--;
		}
		
		return obj;	
	}
	
	/**
	 * This method will function exactly like poll() but instead of returning
	 * null if the list is empty it will throw a NoSuchElementException
	 * @return SimObject removed from the Queue
	 */
	public SimObject remove(){
		SimObject obj = this.poll();
		if( obj == null){
			throw new NoSuchElementException();
		}
		else{
			return obj;
		}
	}
	
	
	/**
	 * This method will return the SimObject at the head of the Queue but will
	 * not remove it from the Queue
	 * @return SimObject at the head of the Queue, null if the list is empty
	 */
	public SimObject peek(){
		SimObject obj = null;
		//non empty list
		if(!this.isEmpty()){
			obj = this.head.data;
		}
		return obj;
	}
	
	/**
	 * This method will act exactly like peek() returning the SimObject at the head of the list
	 * without removing it. However if the list is empty it will throw a NoSuchElementExcpetion()
	 * @return SimObject at the head of the list
	 */
	public SimObject element(){
		SimObject obj = this.peek();
		//throw excpetion if it is null
		if(obj == null){
			throw new NoSuchElementException();
		}
		else{
			return obj;
		}
		
	}


	/**
	 * This method checks to see if the Queue is empty
	 * @return true if the list is empty, false otherwise
	 */
	public boolean isEmpty(){
		return this.head == null;
	}
	
	
	

	/** 
	 * This method checks the capabilities of the ElevatorQueue
	 * @param args not used
	 */
	public static void main( String[] args){
		// create a checkout que
		ElevatorQueue queue = new ElevatorQueue(1, Elevator.Direction.DOWN);
		System.out.println("Empty: " + queue.peek());
		
		// fill with some shoppers
		for ( int i=0; i < 5; i++){
			queue.offer(new Passenger(0,0));
		
		}
		System.out.println("Full: " + queue.peek());
		System.out.println("Size: " + queue.size());
		// remove all the shoppers
		while(!queue.isEmpty()){
			System.out.println("Item: " + queue.poll() + " Size: " + queue.size());
		}
		
		// make sure queue is empty
		System.out.println("Empty: "  + queue.peek());
		
		}
	
	




	/**
	 * private class that describes the linked list Nodes that will
	 * hold the SimObjects
	 * @author chris
	 *
	 */
	private class ListNode
	{
		public SimObject data;
		public ListNode next;
		
		/**
		 * Constructor
		 * @param d SimObject to be held in data
		 * @param n Next listNode pointer
		 */
		public ListNode(SimObject d, ListNode n)
		{
			this.data = d;
			this.next = n;
		}
		
	
		
	  }






	@Override
	/**
	 * not used
	 */
	public boolean addAll(Collection arg0) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	/**
	 * Clears the ElevatorQueue of all queues
	 */
	public void clear() {
		this.head = this.tail = null;
		this.size = 0;
		
	}

	/**
	 * not used
	 */
	public boolean contains(Object arg0) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	/**
	 * not used
	 */
	public boolean containsAll(Collection arg0) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	/**
	 * not used
	 */
	public Iterator iterator() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	/**
	 * not used
	 */
	public boolean remove(Object arg0) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	/**
	 * not used
	 */
	public boolean removeAll(Collection arg0) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	/**
	 * not used
	 */
	public boolean retainAll(Collection arg0) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	/**
	 * not used
	 */
	public Object[] toArray() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	/**
	 * not used
	 */
	public Object[] toArray(Object[] arg0) {
		// TODO Auto-generated method stub
		return null;
	}
	  
	/**
	 * This Compares two ElevatorQueue's based on their size. This is useful for ordering Queues
	 * based on the number of waiting passengers
	 * @author chris
	 *
	 */
	public static class numPassangers implements Comparator<ElevatorQueue>{
		public int compare(ElevatorQueue q1,ElevatorQueue q2){
			return ( q1.size() - q2.size());
		}
	}

}