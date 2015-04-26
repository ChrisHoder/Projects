// FILE: QueueSorter.java
// AUTHOR: Chris Hoder
// Date: 11/14/2011
// PROJECT 08

import java.util.Comparator;


/**
 *  This class will act as a Priority queue for ElevatorQueues. It will sort
 *  the Queues based on their sizes and allows for easy computation of the location 
 *  where the most passengers are waiting
 * @author chris
 *
 */
public class QueueSorter {

	
	//data declarations
	private Comparator<ElevatorQueue> comp;
	private ElevatorQueue[] floors;
	private int size;
	
	/**
	 * Creates a new QueueSorter with the given maximum capacity
	 * @param maxsize - the maximum number of Elevator Queues that can be added
	 */
	public QueueSorter(int maxsize){
		this.floors = new ElevatorQueue[maxsize];
		this.comp = new ElevatorQueue.numPassangers();
		this.size = 0;
	}
	
	
	/**
	 * Swaps the references of the last 2 elements with the given indices
	 * @param i - the position of the first element
	 * @param j - the position of the second element
	 */
	private void swap( int i, int j){
		ElevatorQueue temp = this.floors[i];
		this.floors[i] = this.floors[j];
		this.floors[j] = temp;
	}
	
	/**
	 * Adds a new ElevatorQueue to this PQ if there is room. Returns true if the addition
	 * was successful and false if it wasn't (no room). The Elevator Queue added will be placed
	 * in order of it's size
	 * @param eq - ElevatorQueue to be added
	 * @return true if successfully added, false otherwise
	 */
	public boolean add(ElevatorQueue eq){
		//if still room
		if( ( this.size + 1 ) < floors.length ){
			this.size++;
			this.floors[this.size] = eq; 
			//recursively call moveUP to restore heap order
			moveUp(this.size);
			return true;
		}
		// full
		else{
			return false;
		}
	}
	
	/**
	 * This recursive method will compare the element at the given index
	 * with the the element's parent (index/2)
	 * if needed it will swap the elements and recursively call itself
	 * @param indx - index of the element to compare to it's parent
	 */
	private void moveUp(int indx){
		if ( (indx > 1) && ( this.comp.compare(this.floors[indx], this.floors[indx/2]) > 0 ) ){
			this.swap(indx,indx/2);
			this.moveUp(indx/2);
		}
		
	}
	/**
	 * Removes the ElevatorQueue with greatest priority from this group, restoring order 
	 * to the heap afterwards
	 * @return the ElevatorQueue of biggest size, null if Queue is empty
	 */
	public ElevatorQueue remove(){
		// queue is empty
		if( isEmpty() ){
			return null;
		}
		
		ElevatorQueue temp = this.floors[1];
		//swap first and last element
		this.floors[1] = this.floors[this.size];
		this.size--;
		//recursively call moveDown to restore heap order
		this.moveDown(1);
		//return ElevatorQueue of highest priority
		return temp;
	}

	/**
	 * This method will compare the element at the given index with it's children. If it has less
	 * priority than either of it's children it will swap with the child (which ever of the 2 has a greater priority)
	 * It will then recursively call moveDown on the new child element to continue restoring heapOrder
	 * @param indx - index of desired element to compare to child
	 */
	private void moveDown(int indx) {
		
		int largerChildIndex = indx*2;
		// check boundry conditions
		if( largerChildIndex > this.size ){
			return;
		}
		// compare 2 children (if there are 2) to see which one has higher priority
		if( ( largerChildIndex+1 <= this.size ) && ( this.comp.compare( this.floors[largerChildIndex], this.floors[largerChildIndex+1])  < 0 )){
			largerChildIndex++;
		}
		// compare the child with the highest prioirty to the parent, swap if needed, recursively call
		// move down if needed to restore heapOrder
		if( this.comp.compare( this.floors[largerChildIndex], this.floors[indx]) > 0 ){
			swap(largerChildIndex, indx);
			moveDown(largerChildIndex);
		}
	}
	
	/**
	 * Returns the next ElevatorQueue in the priority queue.
	 *  the ElevatorQueue is not removed from the group. 
	 * @return the next ElevatorQueue or null if the group is empty
	 */
	public ElevatorQueue getNext(){
		// not empty PQ
		if(!isEmpty()){
			//return highest priority
			return this.floors[1];
		}
		// empty PQ
		return null;
	}
	
	/**
	 * Indicates if this PQ is empty.
	 * @return true if empty, false otherwise
	 */
	public boolean isEmpty(){
		return this.size == 0;
	}
	
	/**
	 * Indicates if this PQ is full
	 * @return true if the PQ is full, false otherwise
	 */
	public boolean isFull(){
		return ( this.floors.length-1 ) == this.size;
	}
	
	/**
	 * Returns the size of the QueueSorter
	 * @return the size of the QueueSorter
	 */
	public int getSize(){
		return this.size;
	}
	
	/**
	 * Removes all Queues from this QueueSorter
	 */
	public void clear(){
		this.size = 0;
	}
	
	/**
	 * Returns a string representation of the group. For Example
	 * floors (8): [empty:false, full: true]
	 * @return string representation
	 */
	public String toString(){
		String str = "floors (" + (this.floors.length-1) +"): [empty:" + isEmpty() + ", full: " + isFull() + "]";
		return str;
	}
	
	/**
	 * This tests the capabilities of the QueueSorter and demonstrates that all parts
	 * are working properly
	 * @param args - not used
	 */
	public static void main( String[] args){
		QueueSorter pg = new QueueSorter(9);
		// fill the QueueSorter with Queues
		for (int i = 0 ; i < 8 ; i++){
			// Fill with some up queues and down queues
			 Elevator.Direction b = Elevator.Direction.DOWN;
			if ( Math.random()*2 < 1){
				b = Elevator.Direction.UP;
			}
			else{
				b = Elevator.Direction.DOWN;
			}
			// create a new elevatorQueue to add
			ElevatorQueue eq = new ElevatorQueue(i,b);
			// populate each ElevatorQueue with passengers
			for( int j = 0 ; j < (int)(Math.random()*20) ; j++){
				eq.add(new Passenger(i,2));
			}
			pg.add(eq);
			System.out.println("ElevatorQueue size: " + eq.size() + " travelling in the " + eq.getDirectionQueue());
			System.out.println("QueueSorter size: " + pg.getSize());
		}
		
		System.out.println(pg.toString());
		
		// remove each Queue individually and print out some information
		while(!pg.isEmpty()){
			
			System.out.println("QueueSorter size: " + pg.getSize());
			ElevatorQueue eq2 = pg.remove();
			System.out.println("ElevatorQueue removed's size: " + eq2.size() + "travelling in the " + eq2.getDirectionQueue());
		}
		
		System.out.println(pg.toString());
		System.out.println("\n\n\n");
		
	}
}