// FILE: HarvestSimulation.java
// AUTHOR: Chris Hoder
// DATE: 10/16/2011
// PROJECT 04

/* This class will run the simulations, it is called on the command line to run the 
 * various simulations. The command line parsing uses the package jargs, downloaded from
 * http://jargs.sourceforge.net/ 
 * This site also contained the documentation for how to use these classes
 */


// imports
import java.util.Random;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;
import java.io.IOException;



public class HarvestSimulation {
	
	// data declarations
	private Landscape scape;
	private LandscapeDisplay display;
	//UNCOMMENT AS PART OF THE IMAGE SAVING
	//private int i=0;
	
	
	// This is the class constructor, it will set the size of the landscape and
	// initialize the display
	// INPUT: width and height of the landscape
	public HarvestSimulation(int width, int height){
		scape = new Landscape(width,height);
		//System.out.println(scape.getHeight());
		display = new LandscapeDisplay(scape,8);
	}
	
	// This method will create alliances, it is the interactive part of creating alliances
	// asking the user to choose them for the SocialSimulation mode. The data for alliances
	// will be stored in the SocialAgent class
	public void createAlliances(int types) throws IOException{
		ArrayList[] alliances = new ArrayList[types];
		// first create the arrayList and then add an alliance with its own type to the list
		for(int i=0; i< types; i++){
			alliances[i] = new ArrayList();
			alliances[i].add(new Integer(i));
		}
		Scanner reader = new Scanner(System.in);
		System.out.println("Input the allinances you want to create. There are " + types + 
							" different types on the grid. To create an alliance, use the" +
							" following syntax\n [1] [2] \n to create an alliance between types" +
							" 1 and 2, then hit enter. After you are done, hit enter on an" + 
							" empty line. Types are from 0 (inclusive) to types (exclusive)");
		String line;
		String[] teams;
		int team1;
		int team2;
		// While there are more alliances to be created
		while((line = reader.nextLine()).equals("") != true){
			// split the input on the space between the two teams
			teams = line.split(" ");
			// two strings returned should have the integer of the two types that are going
			// to be allys
			team1 = Integer.parseInt(teams[0]);
			team2 = Integer.parseInt(teams[1]);
			// test to make sure that the team types exist before adding them
			if( (team1 > types) || (team2 > types) || (team1 < 0) || (team2 < 0) ){
				System.out.println("Bad input, team types do not exist");
				continue;
			}
			// check to see if they are already allys, if they are it doesn't make a duplicate
			else if( (alliances[team1].contains(team2) == true) ){
				System.out.println("They are already Allys!");
				continue;
			}
			// otherwise add them as allys of eachother
			else{
				// set the alliances between eachother
				alliances[team1].add(new Integer(team2));
				alliances[team2].add(new Integer(team1));
			}
		
		}
		// set this alliance in the scape class where the data is stored for it
		SocialAgent.setAlliance(alliances);
	}
	
	
	
	// This method will initialize the harvest landscape. It takes several variables
	// as its input to specialize the harvest landscape, the density effects both the 
	// number of plands and the number of broccolifiends (related by fiends will be 1/8 the amount
	// of the plants at start. fiendFoodMax is the max amount of food that a fiend will start with
	// resourceFoodMax is the max amount of broccoli that a broccoli plant will start with
	/* PSEUDOCODE
	 *  1. determine the amount of broccoli (density*grid area)
	 *  2. FOR (each plant) DO
	 *  	- determine its position randomly
	 *  	- determine amount of resource it has randomly between 0 and resourceFoodMax
	 *     END
	 *  3. determine number of broccoliFiends (amount of broccoli / 8)
	 *  4. FOR (each broccoliFiend) DO
	 *  	- determine its position randomly
	 *  	- determine amount of food it has randomly between 0 and fiendFoodMax
	 *  END
	 */
	public void initializeHarvest(double density, double fiendFoodMax, double resourceFoodMax){
		// determine the number of plants and fiends to start with based on the density
		int amount = ( int ) ( scape.getWidth() * scape.getHeight() * density );
		// for each broccoli on the map
		for(int i=0; i < amount ; i++){
			double xPos = Math.random()*scape.getWidth();
			double yPos = Math.random()*scape.getHeight();
			scape.addResource(new Broccoli(xPos,yPos,Math.random()*resourceFoodMax));
		}
		int amount2 = amount/8;
		for( int i=0; i<amount2; i++){
			double xPos = Math.random()*scape.getWidth();
			double yPos = Math.random()*scape.getHeight();
			scape.addAgent(new BroccoliFiend(xPos,yPos,Math.random()*fiendFoodMax));
		}
	}
	
	// This method will initialize the landscape for a social simulation
	//  It will have a density of agents and the type of each agent will be determined randomly
	//	INPUT: density of agents, number of types
	//	OUTPUT: nothing
	/* PSEUDOCODE
	 * 	1. For (each space in the grid) DO
	 * 		-  determine if there is an agent there
	 * 		-  IF (agent) DO
	 * 				- randomly determine its type
	 * 		    END
	 *      END 
	 *  2. Initialize alliances between the types
	 */
	public void initializeSocialSimulation(double density, int types ){
		Random rand = new Random();
		// for each "grid" location on the landscape
		for ( int i=0; i < scape.getWidth(); i++){
			for( int j=0; j< scape.getHeight(); j++){
				// if number < density it will be occupied
				if( Math.random() <= density){
					//determine which type of cell to create(randomly)
					int type = rand.nextInt(types);
					// add this new agent to the list of agents
					scape.addSocialAgent(new SocialAgent((double)i, (double)j, type));
				}
			}
		}
		//initialize alliances so that each type is allied with itself
		SocialAgent.initializeAlliances(types); 
	}
	
	// This method will initialize the gameOfLife simulation with as many alive cells given
	// by the density input
	// INPUT: density as a double
	// OUTPUT : nothing
	/* PSEUDOCODE
	 * 	1. For( each "grid" element) DO
	 * 		- create a cell, and determine based on the density if it is alive or dead
	 *   END
	 */
	public void initializeGameOfLife(double density){
		Random rand = new Random();
		for( int i = 0; i < scape.getWidth() ; i++ ){
			for( int j = 0; j < scape.getHeight(); j++){
				if( Math.random() <= density){
					scape.addCell(new Cell((double)i, (double)j, true));
				}
				else{
					scape.addCell(new Cell((double)i, (double)j, false));
				}
			}
		}
	}
	
	
	// This method will advance the simulation 1 iteration. It will call the advance on the
	// landscape and then repaint the display
	// INPUT: nothing
	// OUTPUT: nothing
	/* PSEUDOCODE
	 * 	1. advance the landscape
	 *  2. repaint
	 *  END
	 */
	public void advanceHarvest(){
		//advances landscape
		this.scape.advance();
		this.display.repaint();
		
		// UNCOMMENT: to save the image every 40 iterations
	/*		
			if (i == 0){
				String filename = String.format("image-%04d.png",i);
				this.display.saveImage(filename);
			}
			i++;
	*/
	}
	
	
	
	// This method will run the simulations. There are several command line options that the
	// user can opt to input to specialize the operation of this program. The usage is as follows
	/* 
	 * 		java HarvestSimulation [-g,--gameType] [-w,--width] [-h,--height] [-d,--denstiy] [-t,--types]
	 * 								[-f,--fiendFood] [-r,--resourceFood] [-a,--alliances] [-p,--pauseTime]
	 * 
	 */
	// gameType is the type of simulation (1 = harvest simulation, 2 = social simulation, 3 = game of life)
	// width and height are the size of the landscape
	// density is the density of the landscape
	// fiend food is the max amount a fiend can start with 
	// resourcefood is the max amount a plant can start with
	// alliances is only for the social simulation and it is a boolean (true = user wants to set alliances, false = user does not)
	// pauseTime is the tie to pause between updates
	// All of these options are optional. The following are the default values (Pseudocode):
	/*
	 * 		gameType: HarvestSimulation
	 * 		width: 100
	 * 		height: 100
	 * 		density: 0.5
	 * 		types: 3
	 * 		fiendFood: 16
	 * 		resourceFood: 30
	 * 		alliances: false
	 * 		pauseTime: 500 ms
	 */
	public static void main( String[] args ) throws Exception {

		CmdLineParser parser = new CmdLineParser();
		// set the different command line options
		CmdLineParser.Option gametype = parser.addIntegerOption('g',"gameType");
		CmdLineParser.Option widthSize = parser.addIntegerOption('w',"width");
		CmdLineParser.Option heightSize = parser.addIntegerOption('h',"height");
		CmdLineParser.Option densityValue = parser.addDoubleOption('d',"density");
		CmdLineParser.Option numTypes = parser.addIntegerOption('t', "types");
		CmdLineParser.Option fiendFoodMaxValue = parser.addDoubleOption('f',"fiendFood");
		CmdLineParser.Option resourceFoodMaxValue = parser.addDoubleOption('r',"resourceFood");
		CmdLineParser.Option alliances = parser.addBooleanOption('a',"alliances");
		CmdLineParser.Option pauseTime = parser.addIntegerOption('p',"pauseTime");
		
		parser.parse(args);
		
		// get the inputed options, also included default values if the user fails to input them
		int gameType = (Integer)parser.getOptionValue(gametype,new Integer(1));
		int width = (Integer)parser.getOptionValue(widthSize,new Integer(100));
		int height = (Integer)parser.getOptionValue(heightSize,new Integer(100));
		double density = (Double)parser.getOptionValue(densityValue,new Double(0.5));
		int types = (Integer)parser.getOptionValue(numTypes,new Integer(3));
		double fiendFoodMax = (Double)parser.getOptionValue(fiendFoodMaxValue,new Double(16));
		double resourceFoodMax = (Double)parser.getOptionValue(resourceFoodMaxValue,new Double(30));
		boolean alliance = (Boolean)parser.getOptionValue(alliances,Boolean.FALSE);
		int pauseTimeValue = (Integer)parser.getOptionValue(pauseTime,new Integer(500));
		
		
		// initialize Harvest simulation
		HarvestSimulation harvest = new HarvestSimulation(width,height);
		
		// Based on gametype we will initialize the landscape
		// Harvest Simulation
		if( gameType == 1){
			harvest.initializeHarvest(density, fiendFoodMax, resourceFoodMax);

		}
		// SocialSimulation
		else if (gameType == 2){
			harvest.initializeSocialSimulation(density, types);
			if (alliance){
				harvest.createAlliances(types);
			}
		}
		//Game of Life
		else if( gameType == 3){
			harvest.initializeGameOfLife(density);
		}
		
		// run forever
		while(true){
			harvest.advanceHarvest();
			Thread.sleep(pauseTimeValue);
		}
		
	}
}