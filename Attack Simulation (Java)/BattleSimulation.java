// FILE: BattleSimulation.java
// AUTHOR: Chris Hoder
// DATE: 11/5/2011
// PROJECT 07

/* This class will run the simulation of a battle. Attackers will attack the castle */

public class BattleSimulation {

	// data declarations
	private Landscape        scape;
	private LandscapeDisplay display;
	// Attacker Spawner
	private AttackSpawner  spawn;
	
	public static int simulation;
	
	public BattleSimulation(int width, int height){
		this.scape   = new Landscape( width , height );
		this.display = new LandscapeDisplay( scape , 6 );
		this.spawn   = new AttackSpawner(10,10);
		
		BattleSimulation.simulation = 0;
	}
	
	// This method will reset the landscape for a new simulation
	// INPUT: nothing
	// OUTPUT: nothing
	public void reset(){
		this.scape.reset();
	}
	
	
	// This method will save the simulation data to a text file, that is in Excel ready format
	// INPUT: full path as a string
	// OUTPUT: nothing
	public void saveData(String path){
		this.scape.saveData(path);
	}

	
	// This method will create the castle and place it on the Landscape
	// INPUT: nothing
	// OUTPUT: nothing
	public void initializeCastle(){
		//add a castle to our simulation
		Castle s = new Castle((2.0/3.0)*Landscape.getWidth(),0 );
		scape.addCastle(s);
	}
	
	// This method will initialize an army behind the castle. The number of 
	// soldiers (army instances) will be given by the input, soldiers
	// INPUT: soldiers to be in the army
	// OUTPUT: nothing
	public void initializeArmy(int soldiers){
		// this will initially place them in a nice line behind the wall ( but they will randomly slowly
		// during the simulation ) 
		double increment = ((double)Landscape.getHeight())/(double)soldiers;
		// for each new army instance to be created
		for(int i = 0; i < soldiers ; i++){
			// set x,y position
			double x = scape.getCastle().getX() + 10;
			double y = increment*i+3;
			// add new army object to the landscape
			scape.addAgent(new Army( x , y ));
		}
		
	}
	
	// This method will advance the simulation by 1 iteration. 
	// INPUT: nothing
	// OUTPUT: boolean, false when the castle is dead, true otherwise
	public boolean advance(){
		// spawn new Attackers
		this.spawn.updateState(this.scape);
		// advance the landscape (all objects on the landscape), returns false when castle falls
		boolean b = scape.advance();
		// repaint the display
		display.repaint();

		//UNCOMMENT TO SAVE IMAGES
		/*
		if ( (Landscape.iteration % 100) == 0){
			String filename = String.format("image-%04d.png",Landscape.iteration);
			this.display.saveImage(filename);
		}
		*/
		// returns true while the simulation is still running
		return b;
	
	}
	
	
	// This method will print out the usage of the program if the user inputs something incorrectly
	// INPUT: nothing
	// OUTPUT: usage to screen (returns void)
	private static void printUsage() {
	        System.err.println(
	        		"Usage: BattleSimulation [-w,--width] [-h, --height] [-p,--pauseTime]\n" +
	        		"                        [-s, --soldiers] [-a,--spawns] [-c,--castleMax] [-n,--changeProb] [-t,--trials]\n" + 
	        		"						 [-d,--saveData] [-l,--saveLocation]");
	}

	// This method will run the BattleSimulation, there are a number of input options that can help to customize the simulation.
	// the syntax is as follows
	/*
	 * Usage: BattleSimulation [-w,--width] [-h, --height] [-p,--pauseTime] 
	        		           [-s, --soldiers] [-a,--spawns] [-c,--castleMax] [-n,--changeProb] [-t,--trials]
	        		           [-d,--saveData] [-l,--saveLocation]
	 */
	// where:
	//      width, height are the size of the landscape, pauseTime is the time to pause between iterations, soldiers is the number of defending Army objects,
	//      spawns is the MaxNumber of Attackers spawned during a non-surge iteration, castleMax is the maxHealth of the castle and changeProb is the probability that
	//		any army object will change its position after a given update, trials is the number of simulations to run, saveData is a boolean whether to save the data or not, 
	//		save location is the fullpath name where to save the simulation data ( iteration till finish and attackers killed)
	// All of these options are completely optional and reasonable values will be chosen in the absence of an input.
	//
	// This simulation will run forever or until the castle is destroyed  ( the health goes to 0 )
	public static void main(String[] args) {
		
		
		CmdLineParser parser = new CmdLineParser();
		// set up the command line options
		CmdLineParser.Option widthSize     = parser.addIntegerOption('w',"width");
		CmdLineParser.Option heightSize    = parser.addIntegerOption('h',"height");
		CmdLineParser.Option pauseTime     = parser.addIntegerOption('p',"pauseTime");
		CmdLineParser.Option soldierNum    = parser.addIntegerOption('s',"soldiers" );
		CmdLineParser.Option spawns        = parser.addIntegerOption('a',"spawns");
		CmdLineParser.Option castleMax     = parser.addDoubleOption ('c',"castleMax");
		CmdLineParser.Option changeProb    = parser.addDoubleOption ('n',"changeProb");
		CmdLineParser.Option trialsNum     = parser.addIntegerOption('t',"trials");
		CmdLineParser.Option dataSave      = parser.addBooleanOption('d',"saveData");
		CmdLineParser.Option pathLocation  = parser.addStringOption( 'l',"saveLocation");
	
		
		
		// Try to parse the command line, if there is an error it will catch it, print out the syntax and exit the program
		try{
			parser.parse(args);
		}
		catch( CmdLineParser.OptionException e){
			System.err.println(e.getMessage());
			BattleSimulation.printUsage();
			System.exit(-1);
		}
		
		// get the input options, if they are not input, a reasonable default has been chosen
		int width       = (Integer)parser.getOptionValue( widthSize ,    new Integer(200));
		int height      = (Integer)parser.getOptionValue( heightSize,    new Integer(100));
		int pause       = (Integer)parser.getOptionValue( pauseTime ,    new Integer(300));
		int soldiers    = (Integer)parser.getOptionValue( soldierNum,    new Integer(7));
		int spawnNumber = (Integer)parser.getOptionValue( spawns    ,    new Integer(8));
		double cstleMax = (Double) parser.getOptionValue( castleMax ,    new Double(100));
		double chngPrb  = (Double) parser.getOptionValue( changeProb,    new Double(0.03));
		int trials      = (Integer)parser.getOptionValue( trialsNum ,    new Integer(1));
		boolean save    = (Boolean)parser.getOptionValue(  dataSave ,    Boolean.FALSE);
		String path     = (String) parser.getOptionValue( pathLocation,  new String("data.txt"));

		
		// These few lines will set the static variables that have been set in the input options
		// attackers created with each iteration
		AttackSpawner.setAttackersCreated(spawnNumber);
		// castle max health
		Castle.setMaxHealth(cstleMax);
		// army change probability
		Army.setChangeProb(chngPrb);
		
		// This starts the new simulation with given (width,height)
		BattleSimulation bs = new BattleSimulation(width, height);
		
		
		for (int i = 0 ; i < trials; i++){
			// reset the BattleSimulation
			bs.reset();
			
			// puts a castle on it
			bs.initializeCastle();
			// adds defending soldiers
			bs.initializeArmy(soldiers);
			
			// this will run until the castle has been destroyed and then stop
			while( bs.advance()){
				// try and catch the sleep
				try{
					Thread.sleep(pause);
				}
				catch( Exception e){
					System.out.println(e.getMessage());
					System.exit(-1);
				}
			}
			
			//if the user wanted to save the data, then call the save method
			if( save == true ){
				bs.saveData(path);
			}
			
			// iteration the counter of the trials
			BattleSimulation.simulation++;
			
		}
		

	}
}
