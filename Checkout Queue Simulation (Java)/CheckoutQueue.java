// FILE: CheckoutQueue.java
// AUTHOR: Chris Hoder (created during Lab with direction of Professor Eastwood)
// DATE: 10/23/2011
// PROJECT 05

// imports
import java.util.Queue;
import java.awt.Graphics;
import java.awt.Color;
import java.util.ArrayList;

/* A que of SimObjects that represent a line of shoppers in a store simulation */

public class CheckoutQueue extends SimObject {

	//data declarations
	int size;
	ListNode head,tail;

	// queue number
	int queueNumber;

	// this is the constructor for the class, it places it at the position (x,y) and with the queueNumber given
	public CheckoutQueue(double x, double y, int queueNumber){
		super(x,y);
		this.size = 0;
		this.queueNumber = queueNumber;
		// initially empty
		this.head = this.tail = null;
	}

	// this method will return the size of the queue
	public int size(){
		return this.size;
	}
	
	//this method inserts an element if possible at the end
	public void offer(SimObject o){
		ListNode node = new ListNode(o,null);
		if(this.isEmpty()){
			this.head = this.tail =node;
		}
		else{
			this.tail.next = node;
			this.tail = tail.next;
		}
		this.size ++;
	}
	
	
	// removes and returns the head of the Queue
	public SimObject poll(){
		SimObject obj = null;
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
	
	// returns but does not remove the head of the Queue
	public SimObject peek(){
		SimObject obj = null;
		if(!this.isEmpty()){
			obj = this.head.data;
		}
		return obj;
	}


	// this method checks to see if the queue is empty.
	// INPUT: nothing
	// OUTPUT: true if it is empty, false if there are elements in the queue
	public boolean isEmpty(){
		return this.head == null;
	}
	
	// this method will update the singleQueue that houses all of the shoppers waiting inline for the single queue simulation
	// INPUT: landscape
	// OUTPUT: nothing
	public void updateShopperQueues( Landscape scape ){
		//updatePositions();
		// there are no shoppers to check out
		if(this.isEmpty()){
			return;
		}
		
		CheckoutQueue queue;
		// for every queue in the list
		ArrayList queues  = ( ArrayList ) scape.getResources();
		for (int i=0 ; i < queues.size() ; i++){
			
			queue = ( CheckoutQueue )queues.get(i);
			// this queue is empty and can accept a shopper
			if( queue.isEmpty()){
				queue.offer(this.poll());
			}
			// total queue is now empty and there are no more shoppers looking to be checked out
			if( this.isEmpty() ){
				return;
			}
			
		} // end for loop
		// update all the positions of the new shoppers again
		updatePositions();
	}

	// This recursively updates the position of the shoppers in the CheckoutQueue
	private void updatePositions(){
		// if the queue isn't empty, update the positions
		if(!this.isEmpty()){
			this.head.updatePosition(this.x-1,this.y);
		}
	}

   // This method will draw the CheckoutQueue on the landscape
	public void draw(Graphics g, int x, int y, int scale){
		// first draw the counter
		g.setColor(Color.GRAY);
		g.fillRect(x, y-2*scale, scale, scale*3);
		// this draws the number queue that this is above the counter in red
		g.setColor(Color.RED);
		String number = Integer.toString(this.queueNumber);
		char[] numberChar = number.toCharArray();
		// draws the characters
		g.drawChars(numberChar, 0, numberChar.length, x, y-2*scale);
	
	}
	
	
	// This method updates the state of the CheckoutQueue, it will first update the position of all the shoppers in the queue and then look at the first shopper needs to get more
	// items scanned. If it does it scans an item. if all the items have been scanned it asks the customer to pay. if the customer has already paid it removes it from the queue
	// INPUT: landscape
	// OUTPUT: always returns true
	public boolean updateState(Landscape scape){
		this.updatePositions();
		
		if(isEmpty()){
			return true;
		}
		Shopper s = ((Shopper)this.peek());
		// the shopper still has items left to be scanned
		if( s.getItems() != 0 ){
			s.scanItem();
		}
		// the shopper has had all his items scanned and needs to pay
		else if( (s.getItems() == 0) && (s.paid() == false)){
			s.pay();
		}
		// the shopper has paid
		else if( s.paid() ){
			//remove them from the Queue
			s = ( Shopper ) this.poll();
			// update the positions now that someobody has been removed
			this.updatePositions();
			// add this removed shopper to the inactive list for statistics gathering
			scape.addInactive(s);
		}
		// always
		return true;
	}
	
	


	// Test the checkout queue
	public static void main( String[] args){
		// create a checkout que
		CheckoutQueue queue = new CheckoutQueue(10,10,1);
		System.out.println("Empty: " + queue.peek());
		
		// fill with some shoppers
		for ( int i=0; i < 5; i++){
			queue.offer(new Shopper(0,0,5));
		
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




// private class that describes the nodes used in our singly linked queue
	
	private class ListNode
	{
		public SimObject data;
		public ListNode next;
		
		public ListNode(SimObject d, ListNode n)
		{
			this.data = d;
			this.next = n;
		}
	
		// recursive method to update the positions of the elements within the queue
		public void updatePosition(double x, double y){
			((SimObject)this.data).setPosition(x,y);
			// base case is that there is no next element
			if(this.next != null){
				// update the next shoppers positionto 1 unit behind this shopper
				this.next.updatePosition(x , y-1);
			}
			
		}
		
		public int itemCount(){
			if(this.next == null){
				return ((Shopper)this.data).getItems();
			}
			else{
				return (( Shopper )this.data).getItems() + this.next.itemCount();
			}
		
		}
		
	  }
	  
  
  }