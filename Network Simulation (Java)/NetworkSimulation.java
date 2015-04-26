// FILE: NetworkSimulation.java
// AUTHOR: Chris Hoder
// DATE: 10/30/2011
// PROJECT 06

/* This class will run a newtork simulation on the landscape using users who are trying to friend as many other friends, one at a time */

// imports
import java.util.List;

public class NetworkSimulation {
	// data declarations
	private Landscape scape;
	private LandscapeDisplay display;
	
	// UNCOMMENT THIS TO SAVE IMAGES
	//private int iteration = 0;
	
	// constructor sets the width and height of the landscape
	public NetworkSimulation ( int width, int height){
		scape = new Landscape( width , height );
		// display set
		display = new LandscapeDisplay(scape,4);
		
	}

	// this method will initialize the landscape with Users (userNumber many) and they will be positioned at random parts in the board
	// INPUT: integer number of users
	// OUTPUT: nothing
	/* PSEUDOCODE
	 *  1. for ( each number of user to create) DO
	 *  	- add new user to landscape at random x,y location
	 * 	   END
	 *  2. Get list of Users
	 *  3. sort list
	 *  4. set this sorted list as the list of all users in the User class
	 */
	public void initialize(int userNumber){
		for(int i = 0 ; i < userNumber ; i++){
			scape.addAgent(new User(Math.random()*scape.getWidth(), Math.random()*scape.getHeight()));
		}
		List L = scape.getAgents();
		User.setAllUsers(L);
		
	}
	
	// This method will advance the simulation by one iteration and then repaint the display of the landscape to show
	// the new situation
	public void advance(){
		scape.advance();
		display.repaint();
		
		// UNCOMMENT TO SAVE DATA
		/*
		if ( (this.iteration % 50) == 0){
			String filename = String.format("image-%04d.png",this.iteration);
			this.display.saveImage(filename);
		}
		this.iteration++;
		*/
	}
	
	
	// This method will print out the usage of the program if the user inputs something incorrectly
	// INPUT: nothing
	// OUTPUT: usage to screen (returns void)
	private static void printUsage() {
	        System.err.println(
	        		"Usage: NetworkSimulation [-u,--usersNum] [-w,--width] [-h, --height] [-p,--pauseTime]\n" +
	        		"                         [-s,--save] [-n, --saveNum] [-l,--saveLocation] [-r,--randomize] [-m,--randMove]");
	}

	
	
	// This method will run the NetworkSimulation. There are several command line options available for the user to take advantage of
	// the usage is as follows
	/*
	 *     Usage: NetworkSimulation [-u,--usersNum] [-w,--width] [-h, --height] [-p,--pauseTime]
	 *       		                        [-s,--save] [-n, --saveNum] [-l,--saveLocation] [-r,--randomize] [-m,--randMove]
	 */
	// usersNum is the number of users on the landscape
	// width is the width of the landscape
	// heigh tis the height of the landscape
	// pauseTime is the time the program will puase between iterations
	// save is a boolean to decide if you want to save the average number of friends every saveNum iterations (true to save)
	// saveNum is an integer to know after every saveNum iterations the program will save the average number of friends to the given path
	// saveLocation is the path to save the text file to
	// randomize will randomize the updating of the Users, when false it will update them in order of ids
	// randMove will when true move the User to a random position after friending another User
	// 
	// All the values have defaults and are completely optional to run the program
	public static void main( String[] args) throws Exception {
		CmdLineParser parser = new CmdLineParser();
		// set up the different command line options
		CmdLineParser.Option usersNum      = parser.addIntegerOption('u',"usersNum");
		CmdLineParser.Option widthSize     = parser.addIntegerOption('w',"width");
		CmdLineParser.Option heightSize    = parser.addIntegerOption('h',"height");
		CmdLineParser.Option pauseTime     = parser.addIntegerOption('p',"pauseTime");
		CmdLineParser.Option save		   = parser.addBooleanOption('s',"save");
		CmdLineParser.Option saveNum 	   = parser.addIntegerOption('n',"saveNum");
		CmdLineParser.Option pathLocation  = parser.addStringOption( 'l',"saveLocation");
		CmdLineParser.Option randUpdate    = parser.addBooleanOption('r',"randomize");
		CmdLineParser.Option randMoveValue = parser.addBooleanOption('m',"randMove");
		
		// this will try to see that everything is correct in the input, if not it will output the usage to the screen
		// and exit the program
		try{
			parser.parse(args);
		}
		catch ( CmdLineParser.OptionException e){
			System.err.println(e.getMessage());
			NetworkSimulation.printUsage();
			System.exit(-1);
		}
			
		// this will get the inputed options. if not the values all have defaults
		int users = (Integer)parser.getOptionValue( usersNum, new Integer(1000));
		int width       = (Integer)parser.getOptionValue( widthSize,     new Integer(100));
		int height      = (Integer)parser.getOptionValue( heightSize,    new Integer(100));
		int pause       = (Integer)parser.getOptionValue( pauseTime,     new Integer(300));
		boolean saveVl  = (Boolean)parser.getOptionValue( save,          Boolean.FALSE);
		int saveNumber  = (Integer)parser.getOptionValue( saveNum,       new Integer(100) );
		String path     = (String) parser.getOptionValue( pathLocation,  new String("data.txt"));
		boolean randVl    =  (Boolean)parser.getOptionValue( randUpdate,          Boolean.FALSE);
		boolean randMove = (Boolean)parser.getOptionValue(randMoveValue, Boolean.FALSE);
		
		
		// start a new simulation, at given width height
		NetworkSimulation ns = new NetworkSimulation(width,height);
		// initialize the landscape with users amount of people on it
		ns.initialize(users);
		// set whether or not to save the information, where and after every saveNumber trials
		Landscape.setSave(saveVl);
		Landscape.setIterationNum(saveNumber);
		Landscape.setPath(path);
		
		Landscape.setRandomUpdate(randVl);
		
		User.setRandMove(randMove);

		// run forever
		while(true){
			ns.advance();
			Thread.sleep(pause);
		}
		
	}
}