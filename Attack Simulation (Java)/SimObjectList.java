// FILE: SimObjectList.java
// AUTHOR: Chris Hoder, modified code provided in class
// DATE: 10/30/2011
// PROJECT 06

// reused from previous projects

// imports
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/* This class is a single linked list that holds SimObjects as its data */

public class SimObjectList {

  //data declarations
  ListNode head, tail;
  int size;

  
  // constructor just initializes everything to null
  public SimObjectList() {
    head = null;
    tail = null;
    size = 0;
  }
  
  // returns the size of the list (number of SimObjects)
  public int size() {
    return size;
  }
  

  // this clears the SimObjectList
  public void clear(){
    head = tail = null;
    size = 0;
  }
  
  // This gets the ith SimObject
  // INPUT: index of SimObject
  // OUTPUT: SimObject at index
  public SimObject get(int i) {
      ListNode temp = head;
      // Go down the list until you are on the ith object
      for(int j = 0; j < i; j++)
          temp = temp.next;
      //return the data that was recieved
      return temp.data;
  }
 
  // this removes the ith SimObject from the list
  // INPUT: index of SimObject to be removed
  // OUTPUT: SimObject that was removed
  public SimObject remove(int i) {
	  //boundary case of when it is the first element being removed
	if(i == 0) {
      SimObject sO = head.data;
      this.head = head.next;
      // if there is only one element in the list
      if ( this.head == null){
    	this.tail = null;
      }
      //decrement the size
      size --;
      return sO;
    }
	// not the first element in the list
    else {
      ListNode temp = head;
      // go up to the one before the ith element
      for(int j = 1; j < i; j++){
        temp  = temp.next;
      }
      SimObject sO = temp.next.data;
      // if it is the last element in the list, the tail pointer needs to be updated
      if( temp.next == null ){
      	tail = temp;
      }
      else{
      	temp.next = temp.next.next;
      }
      //decrement the size
      size --;
      //return SimObject
      return sO;
    }
  }
  
  
  // This method will add the SimObject at the end of the list
  // INPUT: SimObject to be added
  // OUTPUT: nothing
  public void addAtEnd(SimObject sO) {
	  // if it is the first element added, edge case
    if(head == null){
    		// call addAtFront
          addAtFront(sO);
    }
    else {
    		// just add it to the tail ListNode and change the tail pointer
          tail.next = new ListNode(sO, null);
          tail = tail.next;
          // increment the size of the list
          size ++; 
      }
 
  }
  
  // This method will ad the SimObject s at the front of the list
  // INPUT: SimObject to be added
  // OUTPUT: nothing
  
  public void addAtFront(SimObject s) {
    ListNode node = new ListNode(s,head);
    // if it is the first element in the list, edge case
    if(head == null){
    	// tail and head both point to this new first element
       tail = head = node;
    }
    else{
       head = node;
    }
    size ++;
  }
  
  // This method will return a string equivalent of the SimObjectList with element separated
  // by commas
  public String toString() {
	  // list is empty returns just ()
    if(head == null)
      return "()";
    // calls the method in the ListNode class
    else
      return head.toString();
  }
  
  /*
  // This method will return a complete copy of the SimObjectList as a List, in particular
  // an ArrayList. 
  public List copy(){
     ArrayList simList = new ArrayList();
     ListNode temp = head;
     // while there is another element
     while( temp != null ){
    // get a copy of the SimObject and add it to the list
      SimObject object = (SimObject)(temp.data).copyObject();
      simList.add(object);
   	  temp = temp.next;
     }
     // return list
     return simList;
  }
	*/  
  
  // This method will return the SimObjectList as a List (ArrayList)
  public List<SimObject> toList(){
     ArrayList<SimObject> simList = new ArrayList<SimObject>();
     ListNode temp = head;
     // while there is another element
     while( temp != null ){
    	 // add this element to the list
    	 simList.add(temp.data);
    	 temp = temp.next;
     }
     // return the list
     return simList;
  }
  
  
  // This method will shuffle the SimObject List randomly at time order O(n). it firsts copies
  // the list to an array list and then shuffles the array, while simultaneously rebuilding the
  // the linked list again.
  /* PSEUDOCODE
   * 	1. get list as an arraylist
   * 	2. clear linked list
   * 	3. FOR ( each element in the list) DO
   * 		- pick a random index 0 - (length-index in for loop)
   * 		- put this index into the spot (length-index)
   *       	- copy this SimObject backinto the SimObjectList
   *       END
   *       
   */
  public void shuffle(){
    ArrayList<SimObject> simList = (ArrayList<SimObject>) this.toList();
    this.clear();
    Random rand = new Random();
    int index;
    SimObject temp;
    SimObject temp2;
    // For loop that goes from Length down to 0.
    for(int i=simList.size()-1; i>=0; i--){
    	// as long as this isn't the last case, chose a random index
    	if(i != 0){
    		index = rand.nextInt(i);
    	}
    	// when i = 0 there is only 1 element left un-switched, the first
    	else{
    		index = 0;
    	}
    	// This will get the SimObject at the given index, then set that in the ith spot
    	// getting the data that was there and storing it in the index spot
    	//get SimObject at this location
    	temp = simList.get(index);
    	// put SimObject in the i'th spot in the list and get what was there.
    	temp2 = simList.set(i, temp);
    	// put this simObject in the spot that the other SimObject was in (index);
    	simList.set(index,temp2);	
    	// add this chosen simObject back into the list
    	this.addAtFront(temp);
    }
  }
  
  
  // This method wil update all of the SimObjects that are in the List, based on the landscape, scape
  // It will update every element by simply going down the linked list
  // INPUT: Landscape being played
  // OUTPUT: Nothing
  /* PSEUDOCODE
   * 	1. FOR ( each element in the list ) DO
   * 	 	- update the State
   * 		- IF( the element is to be removed) THEN
   * 			- remove it from the linked list
   * 		  END
   * 	   END
   * 
   */
  public void updateAll(Landscape scape){
    // if the list is empty
    if( head == null ){
      return;
    }
    //previous pointer and pointer to the next
    ListNode n1 = head;
    ListNode n2 = head.next;
    
    // check the first element, and keep checking the first element as long as you are removing the first element
    while( n1.data.updateState(scape) == false ){
      this.size--;
      // set the pointers to the next element
      head = n1 = n2;
      //if the list is now empty
      if( n1 == null ){
        // list is now empty
        tail = null;
        return;
      }
      // set the n2 pointer to the 2nd element ( this could be null )
      n2 = n1.next;
     
    }
    
    // we now know that the first element is still alive the next round, so we will check
    // all of the following elements
    //while we are not at the end of the list
    while( n2 != null ){
    	// if we are to remove n2 from the list
      if( n2.data.updateState(scape) == false ) {
        // check to see if we are removing the last element in the list
        if( n2 == tail ){
          // set the tail = n1 (the new end)
          tail = n1;
          // n1 points to null now
          n1.next = n2 = null;
        }
      
        else{
          n1.next = n2.next;
          n2 = n1.next;
        }
        this.size--;
      } // end if(n2.data.updateState(scape) == false)
      
      // if the item is still alive move on to the next element
      else{
       n1 = n2;
       n2 = n2.next;
      }
    } // end while loop
  } // end updateState
  
  // This method tests all the capabilities of the SimObjectList except updateAll
  public static void main(String[] args) {
	 
  }
}

//========================================================
// listNode class from class notes

class ListNode
{
    public SimObject data;
    public ListNode next;
    
    public ListNode(SimObject d, ListNode n)
    {
        this.data = d;
        this.next = n;
    }
    
    public String toString() {
        ListNode temp = next;
        String result = "(" + data.toString();
        while(temp != null) {
            result += ", " + temp.data.toString();
            temp = temp.next;
        }
        return result + ")";
    }
        

    
    public int length() {
       int total = 0;
       ListNode current = this;
       while(current != null) {
           total++;
           current = current.next;
       }
       return total;
    }
    
}
