// FILE: PassengerGroup.java
// AUTHOR: Chris Hoder
// DATE: 11/14/2011
// PROJECT 08



import java.util.Comparator;

/**
 * Represents a collection of passengers traveling in an elevator.
 * This is implemented as a priority queue so that the next passenger's floor can be easily computed. 
 * @author chris
 *
 */
public class PassengerGroup {

	//data declarations
	private Comparator<Passenger> comp;
	private Passenger[] group;
	private int lastIdx;
	
	/**
	 * Creates a new Passenger group with a given max capacity
	 * @param maxsize - the maximum passenger capacity
	 */
	public PassengerGroup(int maxsize){
		group = new Passenger[maxsize+1];
		useMaxFloors();
		this.lastIdx = 0;
	}
	
	
	//methods
	
	/**
	 * Sets this passenger group to use a Passenger.MinFloor
	 *  comparator to determine priority, appropriate for passenger 
	 *  groups in ascending elevators.
	 */
	public void useMinFloors(){
		// if the group isn't empty, throw error
		if( !this.isEmpty()){
			System.err.println("PassengerGroup.useMinFloors is reordering angry passengers.");
		}
		this.comp = new Passenger.MinFloor();
	}
	
	/**
	 * Sets this passenger group to use a Passenger.MaxFloor
	 *  comparator to determine priority, appropriate for passenger 
	 *  groups in descending elevators. 
	 */
	public void useMaxFloors(){
		// if the group isn't empty throw an error
		if( !this.isEmpty()){
			System.err.println("PassengerGroup.useMaxFloors is reordering angry passengers.");
		}
		this.comp = new Passenger.MaxFloor();
	}
	
	/**
	 * Swaps the references of the two elements with the given indices
	 * @param i - the position of the first element
	 * @param j - the position of the second element
	 */
	private void swap( int i, int j){
		Passenger temp = this.group[i];
		this.group[i] = this.group[j];
		this.group[j] = temp;
	}
	
	
	/**
	 * Adds a new passenger to this group if there is room. Returns true if 
	 * the addition was successful (there was room), and false if it was unsuccessful. 
	 * The passenger added is placed in the proper place within the internal heap representation 
	 * in the group.
	 * <p>
	 * Note that Passenger.onboard is set to true if the passenger is successfully
	 *  added to the group. 
	 * @param pass - the passenger to add
	 * @return true if successfully added, false otherwise
	 */
	public boolean add(Passenger pass){
		// if we are still under the size of the group, we can add
		if( ( this.lastIdx + 1 ) < group.length ){
			// increment size
			this.lastIdx++;
			// add them into the end
			this.group[this.lastIdx] = pass;
			// recursively call moveUp to regain heap order
			moveUp(this.lastIdx);
			//return true because it added it in
			return true;
		}
		else{
			// full, return false
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
		// if the child has greater priority than the parent, swap and recursively call
		if ( (indx > 1) && ( this.comp.compare(this.group[indx], this.group[indx/2]) > 0 ) ){
			this.swap(indx,indx/2);
			this.moveUp(indx/2);
		}
		
	}
	
	/**
	 * Removes the passenger with greatest priority from this group, restoring order 
	 * to the heap afterwards
	 * <p>
	 * Note that Passenger.onboard is set to false for the passenger removed from this group
	 * @return the passenger
	 */
	public Passenger remove(){
		// if the list is null
		if( isEmpty() ){
			return null;
		}
		//else remove the top element
		Passenger temp = this.group[1];
		//swap top and bottom
		this.group[1] = this.group[this.lastIdx];
		this.lastIdx--;
		// move the top element back down to restore heap (recursive)
		this.moveDown(1);
		//return removed Passenger
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
		// base case, if we are at the end of the heap
		if( largerChildIndex > this.lastIdx ){
			return;
		}
		// if the right child exists and if it is of greater priority than the left child) 
		if( ( largerChildIndex+1 <= this.lastIdx ) && ( this.comp.compare( this.group[largerChildIndex], this.group[largerChildIndex+1])  < 0 )){
			largerChildIndex++;
		}
		//compare the parent to the child with greatest priority. if needed swap
		if( this.comp.compare( this.group[largerChildIndex], this.group[indx]) > 0 ){
			swap(largerChildIndex, indx);
			//recursively call moveDown on the new child element
			moveDown(largerChildIndex);
		}
	}
	
	/**
	 * Returns the next person in the priority queue 
	 * of this Passenger group; the Passenger is not removed from the group. 
	 * @return the next person or null if the group is empty
	 */
	public Passenger getNext(){
		// group not empty
		if(!isEmpty()){
			//return first person, does not remove
			return this.group[1];
		}
		// else returns null
		return null;
	}
	
	/**
	 * Indicates if this group is empty.
	 * @return true if empty, false otherwise
	 */
	public boolean isEmpty(){
		return this.lastIdx == 0;
	}
	
	/**
	 * Indicates if this group is full
	 * @return true if full, false otherwise
	 */
	public boolean isFull(){
		return ( this.group.length-1 ) == this.lastIdx;
	}
	
	/**
	 * Returns the number of passengers in this group.
	 * @return the size
	 */
	public int getSize(){
		return this.lastIdx;
	}
	
	/**
	 * Removes all passengers from the group
	 */
	public void clear(){
		this.lastIdx = 0;
	}
	
	/**
	 * Returns a string representation of this group. For Example: 
	 * Group (5): [empty: false, full: true, next: Passenger: [ 0 -> 2, 0]]
	 */
	public String toString(){
		// start the string, puts in the lenght, if its empty, full
		String str = "Group (" + (this.group.length-1) +"): [empty:" + isEmpty() + ", full: " + isFull() + ", next: ";
	    // if the list is empty no next
		if( isEmpty()){
	    	 str += " null ]";
	     }
		// if it is not empty, get the next Passenger to put it in the string
	     else{ 
	    	str += getNext().toString() + "]";
	     }
		// return the string
		return str;
	}
	
	/**
	 * Tests the passenger group class by creating and filling a passenger group, changing the comparator
	 * being used, and removing all the passengers one by one until empty
	 * @param args  - not used
	 */
	public static void main( String[] args){
		PassengerGroup pg = new PassengerGroup(8);
		//change compartor
		pg.useMinFloors();
		// add passengers
		for (int i = 0 ; i < 8 ; i++){
			pg.add(new Passenger(0, (int)(Math.random()*25)));
			System.out.println(pg.getSize());
			System.out.println("is full? " + pg.isFull());
		}
		//remove passengers and print out each removed passenger
		while(!pg.isEmpty()){
			System.out.println(pg.remove().toString());
			System.out.println(pg.getSize());
		}
		System.out.println("is full?" + pg.isFull());
		
		// test toString method on an empty group
		System.out.println(pg.toString());
		System.out.println("\n\n\n");
		
		// change comparator
		pg.useMaxFloors();
		//add new passengers
		for (int i = 0 ; i < 8 ; i++){
			pg.add(new Passenger(25,(int)(Math.random()*25)));
		}
		
		// print out toString method
		System.out.println(pg.toString());
		
		//remove each passenger individually and print them out
		while(!pg.isEmpty()){
			System.out.println(pg.remove().toString());
		}
		// test toString method
		System.out.println(pg.toString());
		
	}
}
