// FILE: SocialSimulation.java
// AUTHOR: Chris Hoder
// DATE: 10/2/11
// PROJECT 03

// imports
import java.util.Random;
import java.util.Scanner;
import java.io.IOException;
import java.util.ArrayList;


public class SocialSimulation{


	//Data declarations
	private Landscape scape;
	private LandscapeDisplay display;
	

	
	// basic constructor. The display variable is not initiated here because
	// there are terminal inputs to be collected before the window pops up
	// the display will be initialized when the program begins to run
	// INPUT: row, col sizes for the Landscape
	public SocialSimulation(int rows, int cols){
		this.scape = new Landscape(rows,cols);
		
	}
	
	
	// This constructor will build a landscape based on the text file supplied in the path
	// This is for the Game of Life simulation only, it does not work for the life simulation
	// INPUT: path to text file
	public SocialSimulation(String path) throws IOException {
		this.scape = new Landscape(path);
	}
	
	// This method will initialize the display, since it is not initialized in the constructor
	// for aesthetic reasons when creating the simulation, this must be called before either of 
	// the advance methods can be called!
	public void intializeDisplay(){
		this.display = new LandscapeDisplay(scape, 12);
	}
	
	// This method will initialize the grid based on the input parameters, density which is the
	// number of alive SimObjects and types which is the number of SocialAgent types that there are
	// going to be on the grid.
	// INPUT: density (as a double) of the grid, number of Social agent types
	/* PSEUDOCODE
		1. for ( every space in the grid) DO
			- IF (a random number is less than or equal to the density) THEN
			   - Choose a random type of SocialAgent to create (between 0 and number of types input)
			   - create new SocialAgent at this space of the random type selected
			END
		END
		2. create an initialized alliance
	*/
	public void initializeRandom(double density, int types){
		Random rand = new Random();
		for( int i = 0; i < this.scape.getRows() ; i++ ){
			for( int j = 0; j< this.scape.getCols(); j++){
				if( Math.random() <= density){
					//determine which type of cell to create (randomly)
					int type = rand.nextInt(types);
					SocialAgent sA = new SocialAgent(i,j,type);
					scape.setAgent(i,j,sA);
				}
				
			}
		
		}

		scape.initialzeAlliances(types);
	}
	
	
	// This method will advance the SocialSimulation by one iteration and repaint the display
	// and show the new picture.WARNING: The display must be initialized before calling this method
	public void advance(){
		scape.advance();
		this.display.repaint();
		
	}
	
	
	// This method will advance the Game of Life by one iteration and repaint the display
	// WARNING: the display must be initialized before calling this method
	public void advanceGameOfLife(){
		scape.advanceLifeSim();
		this.display.repaint();
	}
	
	
	// This method will play the game of Life for the given number of trials with the given
	// pause time inbetween trials.
	// INPUT: number of trials to iterate through, pause time between trials
	/* PSEUDOCODE
		1. Initialize display
		2. paint the starting grid
		3. FOR ( given number of trials ) DO
			- advance the game of life
			- pause
		   END
	*/
	public void playGameOfLife(int trials,int pauseTime) throws InterruptedException{
		this.display = new LandscapeDisplay(scape,12);
		display.repaint();
		Thread.sleep(pauseTime);
		// Advance the game the given number of trials in this for loop	
		for( int i=0; i< trials ; i++){
			advanceGameOfLife();
			Thread.sleep(pauseTime);
		
		}
	}
	
	
	// This method will play the Social Simulation game for the given number of trials with the
	// given pause time between trials
	// INPUT: trials to iterate through, pausetime between trials
	/* PSEUDOCODE
		1. initialize the display
		2. display the first image
		3. FOR( the number of trials ) DO
			- advance the game
			- pause
		END
	
	*/
	public void playSocialSimulation(int trials, int pauseTime) throws InterruptedException{
		this.display = new LandscapeDisplay(scape, 12);
		this.display.repaint();
		Thread.sleep(pauseTime);
		
		for( int i=0; i < trials ; i++ ){
	// UNCOMMENT: to save the image every 100 iterations
// 			if (i%100 == 0){
// 				String filename = String.format("image-%04d.png",i);
// 				this.display.saveImage(filename);
// 			}
		
			advance();
			Thread.sleep(pauseTime);
		}
	
		
	}
	
	
	// This method will create alliances between different types in the SocialSimulation.
	// This is dynamic, the number of alliances is to be determined by the user. They can input
	// as many as they want. The way that the user inputs alliances is by puting the first type in
	// followed by a space and then the second type. Error checking is done to make sure that
	// both integers are a type in the game and that there are no repeats
	// INPUTS: number of types in the simulation
	/* PSEUDOCODE
		1. create an array of Arraylists of length types
		2. FOR( every element in the array ) DO
			- create an arrayList
			- make it an ally with itself
		   END
		3. While ( USER inputs new alliance ) DO
			-parse the input into 2 integers
			- set these 2 types as allys to eachother in their respective arraylist
		   END
		4. Save this Array of alliances to the landscape	   
	*/
	public void createAlliances(int types) throws IOException {
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
		scape.setAlliances(alliances);
			
	}


	// This function will run the program fully. This program can be run in a few different ways
	// to allow the user to run different simulations. First the user can just start this program 
	// with no input parameters. This will result in the user being asked for all the parameters
	// one at a time on the command line. This is the only way to load a predesigned map from a
	// text file for the Game of Life mode of this program.
	// The other way to start this program is with command line parameters of the syntax:
	/*
SocialSimulation [Mode]﻿[rows] [cols] [iterations] [pauseTime] [density] [Types] [changeProbability]
	*/
	// Mode is the type of simulation to run: 1 == Social Simulation, 2 == Game of Life
	// Rows = number of rows in the landscape grid
	// Cols = number of cols in the landscape grid
	// Iterations = number of iterations of the game to run
	// pauseTime = time to pause between iterations on the display
	// density = density of the initialized board
	// The last 2 are only needed for the SocialSimulation version and should be left of for 
	// the Game of life simulation
	// Types = number of different SocialAgents to have
	// changeProbability = probability that a happy socialAgent will try to move to a new cell
	//     					in the 9-neighborhood area of the agent
	//
	// When in the SocialSimulation mode, the user will be prompted to set allys from the command
	// line in either way you start the program.
	//
	// There is no fact checking so inputs into the program need to all be there and they need
	// to be values that make sense inorder for this program to run effectively.
	public static void main(String[] args) throws InterruptedException, IOException {
		// these will all be parameters of the game, they are initialized to their default values
		int gameType = 2;
		int gameChoice = 0;
		int rows = 50;
		int cols = 80;
		int trials = 100;
		int types = 1;
		double density =  0.5;
		double changeProb = 0.05;
		int pauseTime = 500;
		// This has to be initialized despite being overwritten later because
		// otherwise the compiler won't know that the below list is logically exhaustive
		SocialSimulation SS = new SocialSimulation(20,80);
		
		Scanner reader = new Scanner(System.in);
		// if no inputs into the program, the program will ask you for all the components
		if( args.length == 0){

			System.out.println("You started the simulation Program! \n Choose the type of game" +
								" you would like to play \n 1) Game of Life 2) Social Simulation");
								
			gameType = Integer.parseInt(reader.nextLine());
			
			// if you want to play the Game of Life, you have the option to load a Map
			if( gameType == 1 ){
				System.out.println("You selected Game of Life Simulation \n What type would you" +
									" like to play \n 1) Load Grid \n 2) Traditional");
				gameChoice = Integer.parseInt(reader.nextLine());
				
				// This will ask the user which map they wish to load for the game of life				
				if( gameChoice == 1 ){
					System.out.println("You can load a predesigned map or give the path to your " + 
									"own text file.\n Press the given number for the following " + 
									"options:\n\n 1) Blinker \n 2) Blinker2 \n 3) Block \n 4)" + 
									" Boat \n 5) Glider \n 6) LWSS \n 7) Pulsar \n 8) Toad \n" + 
									" 9) enter your own path to a text file");
					// read in user selection
					int choice = Integer.parseInt(reader.nextLine());
					// Switch on user selection to determine which files to load
					switch (choice) {
						//load Blinker.txt
						case 1:
							System.out.println("Loading Blinker.txt ...");
							SS = new SocialSimulation("./Patterns/Blinker.txt");
							break;
						// load Blinker2.txt
						case 2:
							System.out.println("Loading Blinker2.txt ...");
							SS = new SocialSimulation("./Patterns/Blinker2.txt");
							break;
						// load block.txt
						case 3:
							System.out.println("Loading Block.txt ...");
							SS = new SocialSimulation("./Patterns/Block.txt");
							break;
						// load boat.txt
						case 4:
							System.out.println("Loading Boat.txt ...");
							SS = new SocialSimulation("./Patterns/Boat.txt");
							break;
						// load Glider.txt
						case 5:
							System.out.println("Loading Glider.txt ...");
							SS = new SocialSimulation("./Patterns/Glider.txt");
							break;
						// load LWSS.txt
						case 6:
							System.out.println("Loading LWSS.txt ...");
							SS = new SocialSimulation("./Patterns/LWSS.txt");
							break;
						// load Pulsar.txt
						case 7:
							System.out.println("Loading Pulsar.txt ...");
							SS = new SocialSimulation("./Patterns/Pulsar.txt");
							break;
						// load Toad.txt
						case 8:
							System.out.println("Loading Toad.txt ...");
							SS = new SocialSimulation("./Patterns/Toad.txt");
							break;
						// load a text file input by the user. Inputs the full path
						case 9:
							System.out.println("Input the full path to the text file");
							String path = reader.nextLine();
							SS = new SocialSimulation(path);
							break;
						// bad input. exits the program
						default:
							System.out.println("Bad input! pick a number 1-9");
							return;
					}
				
				}
				
			}
			//The user wants to play the SocialSimulation game, needs to know how many types in
			// the grid that the user wants, and the probability that a happy cell will change
			// positions
			else{
				System.out.print("How many types? \t");
				types = Integer.parseInt(reader.nextLine());
				System.out.print("\nWhat do you want the probability( i.e. 0.05 == 5%) that a " +
									"happy agent moves to be?  ");
				changeProb = Double.parseDouble(reader.nextLine());
				SimObject.changeProb = changeProb;
			}
				
			// get the trials and the pause time
			System.out.print("\nHow many trials? \t");
			trials = Integer.parseInt(reader.nextLine());
			System.out.print("\nPause Time (ms)? \t");
			pauseTime = Integer.parseInt(reader.nextLine());
			// if you are not loading a map, you need to choose the number of rows,cols and density
			if( gameChoice != 1 ){
				System.out.print("\nHow many rows? \t");
				rows = Integer.parseInt(reader.nextLine());
				System.out.print("\nHow many cols? \t");
				cols = Integer.parseInt(reader.nextLine());
				System.out.print("\nHow dense? \t");
				density = Double.parseDouble(reader.nextLine());
				SS = new SocialSimulation(rows,cols);
				
			}

		} // end of if( args.length == 0)
		// Mode 2 will have a length of 6 (this is the life simulation traditional), to load a map
		// you must go through the no input, interactive mode. Mode 1 will have length 8
		else if( (args.length == 6) || (args.length == 8) ){
			if( Integer.parseInt(args[0]) == 2 ){
				gameType = 1;
				gameChoice = 0;
			}
			else if( Integer.parseInt(args[0]) == 1){
				types = Integer.parseInt(args[6]);
				changeProb = Double.parseDouble(args[7]);
				SimObject.changeProb = changeProb;
			}
			rows = Integer.parseInt(args[1]);
			cols = Integer.parseInt(args[2]);
			trials = Integer.parseInt(args[3]);
			pauseTime = Integer.parseInt(args[4]);
			density = Double.parseDouble(args[5]);
			SS = new SocialSimulation(rows,cols);
		}
		
		
		// play the Game of Life
		if( gameType == 1){
			if( gameChoice != 1){
				SS.initializeRandom(density,1);
			}
			SS.playGameOfLife(trials,pauseTime);
		
		}
		// play the Social Simulation
		else{
			// initializeRandom will also set the alliances to only people of equal type
			SS.initializeRandom(density,types);
			//gives the choice to have allys in this simulation.
			System.out.print("\n Would you like to set alliances? (1) Yes (2) No \t");
			int allys = Integer.parseInt(reader.nextLine());
			if(allys == 1 ) {
				// this program will create the allys array and save it to the landscape
				SS.createAlliances(types);
			}
			
			SS.playSocialSimulation(trials,pauseTime);
			
		}
	
		
	}



}