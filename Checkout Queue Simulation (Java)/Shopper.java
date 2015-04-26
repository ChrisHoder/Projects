// FILE: Shopper.java
// AUTHOR: Chris Hoder
// DATE: 10/22/11
// PROJECT 05

import java.awt.Graphics;
import java.util.Random;
import java.awt.Color;

/* This class is used to simulate a shoppe within a store */

public class Shopper extends SimObject{

	//data declarations
	
	// max number of items that a shopper can have in the cart
	public static int ITEMS_MAX = 10;
	
	// number of items the shopper has to be scanned
	private int items;
	
	// time the shopper has until it will enter the queues (will be negative if the 
	// shopper has entered a queue already
	private int selectTime;
	
	// total iterations the shopper has been "in the store"
	private int totalTime;
	
	// the index of the queue it has chosen to get into
	private CheckoutQueue queue;
	
	// boolean to tell us if the shopper has paid or not. True if the shopper has already 
	// paid, false if it is yet to pay
	private boolean paid;

	// enum to represent the set of all possible strategies the shopper can use
	public enum Strategy { RANDOM, BESTOFALL, BESTOFTWO, MIX, SINGLEQUEUE }
	
	// the strategy for all shoppers to use
	public static Strategy STRATEGY = Strategy.SINGLEQUEUE;

	// integer telling us which strategy the shopper has chosen
	private int strategyChosen;
	
	
	// Constructor will place the shopper in the store at the given (x,y) position and with
	// the given number of items
	public Shopper(double x, double y, int items){
		super(x,y);
		this.items = items;
		// yet to choose a queue, null 
		this.queue = null;
		this.selectTime = 0;
		this.totalTime = 0;
		this.paid = false;
	}
	
	// this method wll return the integer value corresponding to the strategy chosen by the Shopper to join a queue
	// INPUT: nothing
	// OUTPUT: integer corresponding to the strategy chosen
	public int getStrategyChoice(){
		return this.strategyChosen;
	}

	// This static method will set the max number of items that a Shopper can have in the store
	// INPUT: integer items
	// OUTPUT: nothing
	public static void setItemsMax(int items){
		Shopper.ITEMS_MAX = items;
	}
	
	// This static method will set the strategy that shoppers will use to find a queue
	// 0 = picks random queue, 1 == picks best queue of all, 2 == best of 2 randomly chosen queues, 3 === mix of the previous 3 strategies, 4 == single queue simulation
	// default is a random queue
	// INPUT: integer value corresponding to strategy chioce
	public static void setStrategy(int choice){
		switch(choice){
			case 0:
				Shopper.STRATEGY = Strategy.RANDOM;
				break;
			case 1:
				Shopper.STRATEGY = Strategy.BESTOFALL;
				break;
			case 2:
				Shopper.STRATEGY = Strategy.BESTOFTWO;
				break;
			case 3:
				Shopper.STRATEGY = Strategy.MIX;
				break;
			case 4:
				Shopper.STRATEGY = Strategy.SINGLEQUEUE;
				break;
			default:
				Shopper.STRATEGY = Strategy.RANDOM;
				break;
		}
		
	}
	
	// This method returns the number of items the shopper has left to get scanned
	// INPUT: nothing
	// OUTPUT: number of items the shopper has left
	public int  getItems(){
		return this.items;
	}
	
	// This method will scan an item (i.e. decrement the number of items left to be scanned)
	// INPUT: nothing
	// OUTPUT: nothing
	public void scanItem(){
		this.items--;
	}
	
	
	// This method will have the shopper "pay" , i.e. the paid boolean is set to true
	// INPUT: nothing
	// OUTPUT: nothing
	public void pay(){
		this.paid = true;
	}
	
	// This method will check to see if the shopper has paid. returns true if the shopper has
	// paid, false if it hasn't
	// INPUT: nothing
	// OUTPUT: boolean corresponding to if the shopper has paid
	public boolean paid(){
		return this.paid;
	}


	// This method will update the state of the shopper. There are a number of different senarious. They are the following 
	// 1. The shopper has yet to choose a queue -- in this case it chooses a queue, and sets selectTime accordingly
	// 2. The shopper has selected a queue but hasn't yet joined a queue. If there is still time left in the selectTime it will decrement it
	//    			otherwise it will join the queue
	// 3. The shopper is waiting in a queue but is yet to pay -- in this case it will do nothing, the queue will decrement its itemsn and checking out
	// 4. The shopper has paid -- in this case it will return false ( in all others it will return true)
	// 
	// Additionally, with every call it will update the totalTime by 1 regardless of the senario that the shopper is in
	//
	// INPUT: Landscape scape on which the shopper sits
	// OUTPUT: boolean. true if it is still in the store, false if it has checkedout and left
	//
	/*  PSEUDOCODE
	 *  1. increment totalTime
	 *  2. IF( the shopper is yet to choose a queue) THEN
	 *	   SWITCH( on strategy )
	 *  			CASE RANDOM
	 *  				- pick a random queue
	 * 		 			- selection time is 0
	 *  	  		CASE BESTOFALL
	 *    				- pick the queue with the least shoppers waiting
	 *    				- selection time is 4
	 *    			CASE BESTOFTWO
	 *    				- pick 2 random queues and join the one with the least amount of shoppers
	 *    					in either of the 2
	 *    				- selection time is 2
	 *    			CASE MIX
	 *    				- randomly choose one of the previous strategies, update the selection time
	 *    					accordingly
	 *    			DEFAULT
	 *    				- choose randomly (see random case)
	 *    			END SWITCH
	 *   3. ELSE IF ( chosen queue but time left to wait ) THEN
	 *   		decremement the time lef to wait
	 *      END
	 *   4. ELSE IF ( chosen queue and selectTime is 0 ) THEN
	 *   		- get in line in the correct queue
	 *      END
	 *   5. ELSE IF ( shopper has paid ) THEN
	 *   		- return false
	 *      END
	 *   6. return true
	 */      
	public boolean updateState(Landscape scape){
		// in every case update the total time in the store
		this.totalTime ++;
		// IF the shopper has not chosen a queue to join yet
		if( this.queue == null){	
			// select a queue upon which to join based on the strategy chosen
			switch (Shopper.STRATEGY){
				// pick a random queue
				case RANDOM:
					this.queue = ( CheckoutQueue ) this.pickRandom(scape);
					break;
				// pick the shortest queue of them all
				case BESTOFALL:
					this.queue  = ( CheckoutQueue )this.pickBest(scape);
					break;
				// pick the of 2 randomly chosen queues
				case BESTOFTWO:
					this.queue = ( CheckoutQueue )this.pickBestOfTwo( scape );
					break;
				// this randomly picks one of the other strategies to try
				case MIX:
					Random rand = new Random();
					// randomly pick one of the 3 strategies
					int strategy = rand.nextInt(3);
					switch (strategy){
					// switch on the randomly chosen number to decide the strategyt
					// case 0 is a random queue
					case 0:	
						this.queue = ( CheckoutQueue )this.pickRandom(scape);
						break;
					// case 1 is the best of all choice
					case 1:
						this.queue  = ( CheckoutQueue )this.pickBest(scape);
						break;
					// case 2 is the best of 2 strategy
					case 2:
						this.queue = ( CheckoutQueue ) this.pickBestOfTwo( scape );
						break;
					// default case is pick a random queue (though it shouldn't get here)
					default:
						this.strategyChosen = 0;
						this.queue = ( CheckoutQueue ) this.pickRandom(scape);
						break;
					}
					
					break;
				case SINGLEQUEUE:
					this.strategyChosen = 0;
					this.selectTime = 0;
					this.queue = ( CheckoutQueue )scape.getSingleQueue();
					break;
				// default case is pick a random queue (though it shouldn't get here)
				default:
					//selects a random line
					this.queue = ( CheckoutQueue )this.pickRandom(scape);
					this.strategyChosen = 0;
					break;
			} // end switch
		}
		// shopper is waiting to join a queue and still has time to wait. decrement this waittime
		else if( this.selectTime > 0){
			selectTime --;
		}
		// time to join the queue, find it and add itself
		else if( this.selectTime == 0){
			// not running single Queue mode
				queue.offer(this);
				this.selectTime = -1;
		}
		// if they have paid, return false and "checkout"
		else if( this.paid == true){
			return false;
		}
		// in all cases except when it has paid, return true (i.e. still in the store)
		return true;
	}
	
	
	
	// This method will piack a random queue in the store and join it. there is no time penalty for such a choice
	// this is also strategy 0.
	// INPUT: landscape
	// OUTPUT: integer representation of the queue number
	private SimObject pickRandom(Landscape scape){
		this.strategyChosen = 0;
		this.selectTime = 0;
		// selects a random queue
		Random rand = new Random();
		return scape.getResource(rand.nextInt(scape.getResourceSize()));
	}
	
	// This method will pick the best queue of all of the queues in the store and choose it to join. There is a time penalty
	// of 4 for this method
	// INPUT: landscape
	// OUTPUT: integer representation of the queue that was chosen to join
	private SimObject pickBest(Landscape scape){
		this.strategyChosen = 1;
		// selects the shortest queue of all at the time
		CheckoutQueue q;
		int index = 0;
		//arbitrarily large start, though it will be changed in the first loop -- to satisfy the compiler
		int size = 99999;
		// for all of the queues in the store
		for( int i = 0 ; i < scape.getResourceSize() ; i++){
			q = ( CheckoutQueue ) scape.getResource(i);
			// if this is the first queue checked, set the size to it.
			if(i == 0){
				size = q.size();
				index = i;
			}
			// check to see if this queue's line is shorter than the others, if it is
			// it is now  the current top choice to join
			else if( q.size() < size ) {
				size = q.size();
				index = i;
			}
		}
		// 4 turn penalty for this option
		this.selectTime = 4;
		// return integer representation of the queue
		
		return scape.getResource(index);
		
	}
	
	//  This mehtod will pick the best of 2 randomly chosen queues. There is a time penalty of 2 turns for
	// this method option
	// INPUT: Landscape
	// OUTPUT: integer representation of the queue chosen in the store
	private SimObject pickBestOfTwo( Landscape scape ){
		this.strategyChosen = 2;
		this.selectTime = 2;
		Random rand = new Random();
		//selects the best of 2 random ones it checks
		int size = scape.getResourceSize();
		int queueChoice1 = rand.nextInt(size);
		int queueChoice2 = rand.nextInt(size);
		// check to see which queue has the smaller size
		if ( ( ( CheckoutQueue ) scape.getResource(queueChoice1)).size() <= ( ( CheckoutQueue )scape.getResource(queueChoice2)).size() ){
			// first randomly chosen one is smaller
			return scape.getResource(queueChoice1);
		}
		else{
			// second randomly chosen one is smaller
			return scape.getResource(queueChoice2);
		}
		
	}
	
	// This method draws the graphics	
	public void draw(Graphics g, int x, int y, int scale){
		double saturate = ((double)this.items / (double)Shopper.ITEMS_MAX )*(double)255;
		saturate = saturate < 25 ? (double)25 : saturate;
		// color of the shopper is going to depend on the approach it took to choose a Queue
		switch ( this.strategyChosen ){
		// random queue
			case 0:
				//blue
				g.setColor(new Color(0,0,255,(int)saturate));
				break;
		// best of all the queues
			case 1:
				//yellow
				g.setColor(new Color(255,255,0,(int)saturate));
				break;
		// best of 2 random queues
			case 2:
				//red
				g.setColor(new Color(255,0,0,(int)saturate));
				break;
		}
		
		// create an oval for the shopper
		g.fillOval(x, y, scale, scale);
	}
	
	// This method will return the total time that the shopper has been in the store for
	// INPUT: nothing
	// OUTPUT: totalTime in the store (Integer)
	public int getTotalTime(){
		return this.totalTime;
	}

	
	
	// This method will test the capabilities of the class, except those involved with updating the states
	public static void main( String[] args ){
		Shopper s = new Shopper(10,14,2);
		System.out.println(" Number of items: " + s.getItems());
		s.scanItem();
		System.out.println(" Number of items after a scan: " + s.getItems());
		System.out.println(" has the shopper paid? " + s.paid());
		s.pay();
		System.out.println(" Has the shopper paid?" + s.paid());
		System.out.println(" Current strategy choice? should be -1 because it hasn't decided " + s.getStrategyChoice());
		System.out.println(" Total time it has been in the store(should be 0) " + s.getTotalTime());
				
		
	}


}