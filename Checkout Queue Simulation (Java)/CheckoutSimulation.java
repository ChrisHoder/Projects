// FILE: CheckoutSimulation.java
// AUTHOR: Chris Hoder
// DATE: 10/23/2011
// PROJECT 05

/* This class will simulate the shopping market with shoppers and checkouts */

//imports
import java.util.Random;

public class CheckoutSimulation {
	
	// data declarations

	//UNCOMMENT TO SAVE IMAGES
	//int iteration = 0;
	
	
	private Landscape scape;

	// Shopper spawner
	private ShopperSpawner spawn;
	
	private LandscapeDisplay display;

	// this is the constructor, 
	public CheckoutSimulation(int width, int height, int ShoppersSpawned ){
		scape = new Landscape(width,height);
		display = new LandscapeDisplay(scape,8);
		// creates a shopper spawner, it is in an arbitrary position as it isn't drawn
		spawn = new ShopperSpawner(10,10);
		// sets the number of shoppers created per turn
		ShopperSpawner.setShoppersCreated(ShoppersSpawned);
	}
	
	
	// This initializes the queues, it will create queues number of queues in the landscape, evenly separated. It is up to the user to make sure that ther aren't
	// too many queues in the landscape
	// INPUT: int number of queues to be created
	// OUTPUT: nothing
	public void initializeQueues(int queues){
		// for all the queues to be created.
		for (int i=0; i < queues; i++){
			// the position here, starts at the right and then subtracts i*(fraction of landscape dependant on number of queues)
			CheckoutQueue queue = new CheckoutQueue( this.scape.getWidth()-5 - i*(this.scape.getWidth()/queues)  , this.scape.getHeight()-3, i );
			// add resource to the landscape
			scape.addResource(queue);
		}
		
	}
	
	
	// this method initializes the board with an initial amount of shoppers on it. they will be at random positions on the top 1/4 of the board with a random abount of items
	// between 1 and ITEMS_MAX
	// INPUT: number of shoppers to initialize
	// OUTPUT: nothing
	public void initializeShoppers(int startShoppers){
		double x,y;
		int items;
		Random rand = new Random();
		// for each new shopper
		for (int i = 0 ; i < startShoppers ; i++){
			// position in the x, anywhere
			x = Math.random()*scape.getWidth();
			// position in the y is only the top quarter
			y = Math.random()*scape.getHeight()/4;
			// number of items the shopper has is between 1 and ITEMS_MAX
			items = rand.nextInt(Shopper.ITEMS_MAX)+1;
			// create a new shopper and add them
			Shopper s = new Shopper(x,y,items);
			scape.addAgent(s);
		}
	}
	
	// This metho initializes a single queue line for the Single queue simulation, position is at the far left of the landscape
	public void initializeSingleQueue(){
		scape.setSingleQueue(new CheckoutQueue(2, this.scape.getHeight()-10, 0));
	}
	
	// This method advances the simulation by 1 iteration
	public void advance(){
		// spawns new shoppers
		spawn.updateState(scape);
		// updates the landscape
		scape.advance();
		//repaints the landscape
		display.repaint();
		
		//UNCOMMENT TO SAVE IMAGES
		/*
		if ( ( this.iteration % 40 ) == 0){
			String filename = String.format("image-%04d.png",this.iteration);
			this.display.saveImage(filename);
		}
		this.iteration++;
		*/
	}
	
	
	// This method runs the Checkout simulation. It can be run with several command line
	// options that are all entirely optional. These allow for speicialization of the simulation
	// The syntax:
	/*
	 *   java CheckoutSimulation [-g,--gameType] [-w,--width] [-h,--height] [-s,--strategy] [-q,--queues] [-p,--pauseTime] 
	 *   							[-c,--SpawnCreate] [-i,--itemsMax] [-t,--shopperStart]
	 */
	// gameType is the type of simulation ( 1 == "classial" shoppers choose the queues, 2 == 1 queue and they go to the first available queue
	// width and height are the size of the landscape
	// strategy is the type of strategy to be used by the shoppers
	//		- 0 == shoppers choose a random queue
	//      - 1 == shoppers choose the best queue amonst them all
	//      - 2 == shoppers choose the best of 2 randomly selected queues
	//      - 3 == shoppers chose randomly between the first 3 strategies (colors indicate strategy)
	// queues is the number of queues on the landscape, it is up to the user to make sure that they fit on the landscape with no overlap
	// pauseTime is the time the program will pause between iterations
	// SpawnCreate is the number of shoppers spawned with each iteration
	// itemsMax is the maximum number of items a shopper can have
	// shopperStart is the number of shoppers on the landscape at the start
	//      - 
	public static void main( String[] args) throws Exception {
	
		CmdLineParser parser = new CmdLineParser();
		// set the different command line options
		CmdLineParser.Option gameType      = parser.addIntegerOption('g',"gameType");
		CmdLineParser.Option widthSize     = parser.addIntegerOption('w',"width");
		CmdLineParser.Option heightSize    = parser.addIntegerOption('h',"height");
		CmdLineParser.Option strategyValue = parser.addIntegerOption('s',"strategy");
		CmdLineParser.Option queues        = parser.addIntegerOption('q',"queues");
		CmdLineParser.Option pauseTime     = parser.addIntegerOption('p',"pauseTime");
		CmdLineParser.Option Spawner       = parser.addIntegerOption('c',"SpawnCreate");
		CmdLineParser.Option itemsMax      = parser.addIntegerOption('i',"itemsMax");
		CmdLineParser.Option shopperStart  = parser.addIntegerOption('t',"shopperStart");
		
		
		parser.parse(args);
		
		
		// get the inputed options, also included default values if the user fails to input them
		int game        = (Integer)parser.getOptionValue( gameType,      new Integer(1));
		int width       = (Integer)parser.getOptionValue( widthSize,     new Integer(100));
		int height      = (Integer)parser.getOptionValue( heightSize,    new Integer(100));
		int strategy    = (Integer)parser.getOptionValue( strategyValue, new Integer(3));
		int queueNumber = (Integer)parser.getOptionValue( queues,        new Integer(10));
		int pause       = (Integer)parser.getOptionValue( pauseTime,     new Integer(1000));
		int spawnTurn   = (Integer)parser.getOptionValue( Spawner,       new Integer(1));
		int items       = (Integer)parser.getOptionValue( itemsMax,      new Integer(10));
		int shopper     = (Integer)parser.getOptionValue( shopperStart,  new Integer(10));    
		
		
		// create the simulation
		CheckoutSimulation cs = new CheckoutSimulation(width,height,spawnTurn);
		// set the max number of items
		Shopper.setItemsMax(items);
		
		
		// if game == 2 we are doing a simulation with only 1 queue and then they
		// all go to the next open line
		if( game == 2){
			cs.initializeSingleQueue();
			Shopper.setStrategy(4);
		}
		// this is a "classic" queue situation, with shoppers choosing the queues themselves
		else{
			// you can't have htis classic situation with the strategy for a single queue
			if( strategy == 4){
				strategy = 3;
			}
			Shopper.setStrategy(strategy);
		}
		
		// initialize the Queues and the Shoppers to the landscape
		cs.initializeQueues(queueNumber);
		cs.initializeShoppers(shopper);
		
		
		// Run the simulation forever
		while (true){
			cs.advance();
			Thread.sleep(pause);
		}		
	}

}