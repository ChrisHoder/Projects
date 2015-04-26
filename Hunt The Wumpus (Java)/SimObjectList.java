// FILE: SimObjectList.java
// AUTHOR: Brian Eastwood modified by Chris Hoder
// DATE: 12/09/2011
// PROJECT 10

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * A List implementation that maintains a list of SimObjects.
 * <p>
 * Modified by Chris Hoder for Project 9
 * <p>
 * Made the SimObjectList extend the SimObject so that it
 * has an updateState and a draw method. Draw method is left
 * blank. This List was also converted from a single linked list
 * to a double linked list.
 * @author chris
 *
 */
public class SimObjectList
{
	private static Random rand = new Random();
	
	private Node head;
	private Node tail;
	private int count;
	
	/**
	 * Constructs a new empty SimObjectList.
	 */
	public SimObjectList()
	{
	
		this.head = null;
		this.tail = null;
		this.count = 0;
	}
	
	/**
	 * Clear all the elements from the list.
	 */
	public void clear()
	{
		this.head = null;
		this.tail = null;
		this.count = 0;
	}

	/**
	 * Returns the number of elements in the list.
	 * @return the number of elements in the list
	 */
	public int size()
	{
		return this.count;
	}
		
	/**
	 * Adds a SimObject onto the end of the list.
	 * @param data
	 */
	public void add(SimObject data)
	{
		Node end = new Node(data, null,null);
		
		if (this.head == null)
			// adding first element
			this.head = end;
		else
			// at least one element already in the list
			this.tail.next = end;
			end.prev = this.tail;
		
		// update tail pointer and count
		this.tail = end;
		this.count++;
	}
		
	/**
	 * This method will get the ith SimObject in the list and return it
	 * @param i - index of the SimObject desired in the list
	 * @return SimObject at the ith index
	 */
	  public SimObject get(int i) {
		  Node temp = head;
	      // Go down the list until you are on the ith object
	      for(int j = 0; j < i; j++)
	          temp = temp.next;
	      //return the data that was recieved
	      return temp.data;
	  }
	  

	  /*
	  public SimObject remove( int i ){
		  // out of index (SHOULD THROW EXCEPTION)
		  if( i > this.size() ){
			  return null;
		  }
		  // boundary case when it is hte first element being removed
		  if ( i == 0 ){
			  SimObject sO = this.head.data;
			  this.head = head.next;
			  if ( this.head == null ) {
				  this.tail = null;
			  }
			  else{
				  this.head.prev = null;
			  }
			  //decrement the size
			  this.count--;
			  return sO;
		  }
		  else{
			  // not the first element
			  Node temp = head;
			  //go up to the one before the ith element
			  for( int j = 1 ; j < i ; j++){
				  temp = temp.next;
			  }
			  SimObject sO = temp.next.data;
			  // if it is the last element in the list, tail pointer needs to be updated
			  if( temp.next == null ) {
				  tail = temp;
			  }
			  else{
				  //set the next pointer
				  temp.next = temp.next.next;
				  // set the prev pointer on the one beyond sO
				  temp.next.prev = temp;
			  }
			  //decrement the size
			  this.count--;
			  // return removed object
			  return sO;
			  
		  }
		  
		  
	  }
	  */
	  
	  /**
	   * This method will remove the ith element in the list.
	   * That element will be returned, but will no longer
	   * be in the list.
	   * @param i - index of the element to remove
	   * @return SimObject at the index i
	   */
	  public SimObject remove( int i ){
		  // get the i'th element node
		  Node removedNode = this.getNode(i);
		  // if it is not the first element in the list
		  if( removedNode.prev != null){
			  removedNode.prev.next = removedNode.next;
		  }
		  //first element being removed change the head pointer
		  else{
			  this.head = removedNode.next;
		  }
		  // if it is not the last element in the list
		  if( removedNode.next != null){
			  removedNode.next.prev = removedNode.prev;
		  }
		  // if it is move the tail pointer back
		  else{
			  this.tail = removedNode.prev;
		  }
		  //decrement the count
		  this.count--;
		  //return the removed object
		  return removedNode.data;
		  
	  }
	  
	  /**
	   * This method will return the node in the i'th spot. This method is private
	   * so that the user cannot access the inner nodes of this list. This method
	   * does not remove the Node, simply returns it.
	   * @param i - index of the desired Node
	   * @return Node at the index i in the list
	   */
	  private Node getNode(int i){
		  Node temp = head;
	      // Go down the list until you are on the i'th object
	      for(int j = 0; j < i; j++)
	          temp = temp.next;
	      //return the data that was received
	      return temp;
	  }
	
	/**
	 * Copies the elements in this list to a List implementation.
	 * Added a generic in.
	 * @author chris
	 * @return the new list
	 */
	public List<SimObject> toList()
	{
		ArrayList<SimObject> copy = new ArrayList<SimObject>(this.size());
		Node node = this.head;
		while (node != null)
		{
			copy.add(node.data);
			node = node.next;
		}
		
		return copy;
	}
	
	/** 
	 * This method will cut the SimObjectList at the index i (inclusive)
	 * All of the elements from i to the end will be copied
	 * into a new SimObjectList (the one returned) and removed from
	 * this list
	 * @param i - index upon which to make the cut
	 * @return new SimObjectList containing the SimObjects from the i'th
	 * index to the end
	 */
	public SimObjectList Cut(int i){
		// new SimObjectList to copy the SimObjects into
		SimObjectList slice = new SimObjectList();
		Node temp = getNode(i);
		// add this element and every one after it until the end of the
		// list
		while(temp != null){
			// add the new data
			slice.add(temp.data);
			// if there is a previous, reset its next pointer
			if( temp.prev != null){
				temp.prev.next = null;
			}
			// go to next node in the list
			temp = temp.next;
			// decrement the count on this list
			this.count--;
		}
		
		
		// return the slice that was just created
		return slice;
	}
	
	
	/**
	 * Shuffles the elements in this List in place.
	 * <p>
	 * Added in some generics
	 * @author chris
	 */
	public void shuffle()
	{
		// copy elements into a new array-based list
		List<SimObject> copy = this.toList();
		
		// randomly reorder elements in the array
		int idx;
		Object swap;
		for (int i = copy.size() - 1; i > 0; i--)
		{
			idx = rand.nextInt(i + 1);
			swap = copy.get(idx);
			copy.set(idx, copy.get(i));
			copy.set(i, (SimObject) swap);
		}
		
		// copy elements back into linked list
		this.clear();
		for (int i = 0; i < copy.size(); i++)
		{
			this.add((SimObject) copy.get(i));
		}
	}
	
	/**
	 * Calls updateState on all the elements in this list.
	 * @param scape  the landscape where all the agents live
	 */
	public void updateAll(Landscape scape)
	{
		Node curr = this.head;
		Node prev = null;
		boolean alive = true;
		
		while (curr != null)
		{
			// update the agent
			alive = curr.data.updateState(scape);
			
			// remove the agent from the list if it dies
			if (!alive)
			{
				this.count--;
				//scape.addInactive(curr.data);
				
				if (curr == head)
				{
					// removing the head from the list
					this.head = head.next;
				}
				else
				{
					// removing any other node
					prev.next = curr.next;
				}
				
				if (curr == tail)
				{
					// removing the tail from the list
					this.tail = prev;
				}
			}
			else
			{
				// advance previous reference if we didn't remove a node
				prev = curr;
			}
			
			// advance node reference
			curr = curr.next;
		}
	}
	
	/**
	 *  This method will print out a string representation of the List.
	 *  <P>
	 *  CAUTION: this method
	 *  depends on whether the node data has a toString method which may not be true.
	 *  @return String representation of the list
	 */
	public String toString(){
		String str = "[ ";
		if( this.head != null){
			// call into the nodes, which will recursively calls
			str += this.head.toString();
		}
		str += " ]";
		//return string
		return str;
		
	}


	
	/**
	 * An inner Node.
	 */
	private class Node
	{
		private SimObject data;
		private Node next;
		private Node prev;
		
		public Node(SimObject data, Node next, Node prev)
		{
			this.data = data;
			this.next = next;
			this.prev = prev;
		}
		
		/**
		 * Prints a string representation of each node, recursively calls itself to print all from this node
		 * to the end.
		 * <p>
		 * CAUTION: Not all SimObjects are required to have a toString method so you may get the Object toString method
		 * which may not provide useful information.
		 * @return string representation of all nodes from this one to the end
		 */
		public String toString(){
			// string representation of the SimObject it is holding
			String str = this.data.toString();
			// if there are more elements
			if( this.next != null){
				// recursive call
				return str + ", " + this.next.toString();
			}
			// last element, just return it's string
			else{
				return str;
			}
		}

	}
	
	/**
	 * This method will test the capabilities of the SimObjectList class
	 * @param args - not used
	 */
	public static void main(String[] args)
	{
		/*
		SimObjectList list = new SimObjectList();
		for (int i = 0; i < 10; i++)
		{
			list.add(new Millipede(i,i));
		}
		
		System.out.println(list.size());
		System.out.println(list.toString());
		SimObjectList l2 = list.Cut(5);
		System.out.println(list.toString());
		System.out.println(l2.toString());
		System.out.println(list.size() + " the new sliced list" + l2.size());
		l2.remove(0);
		System.out.println(l2.toString());
		
		// a smarter way to represent it as a string
		List<SimObject> listimpl = list.toList();
		System.out.println(listimpl);
		
		System.out.println(list.head + ": " + list.head.data);
		System.out.println(list.tail + ": " + list.tail.data);
	*/
	}

	
}
