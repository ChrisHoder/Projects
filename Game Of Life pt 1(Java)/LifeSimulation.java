// FILE: LifeSimulation.java
// AUTHOR: Chris Hoder
// DATE: 9/25/2011
// PROJECT 02

// This class will run the game of life. 
 

import java.util.Scanner;
import java.io.IOException;

public class LifeSimulation{

	//Data declarations
	
	// This is the Landscape driven by this simulation
	private Landscape scape;
	
	// This function initializes the landscape with the given shape
	public LifeSimulation(int rows, int cols){
		this.scape = new Landscape(rows,cols);
	
	}
	
	public LifeSimulation(String path) throws IOException {
		this.scape = new Landscape(path);
		
	}
	
	//This function initializes the landscape with each cell having a density chance
	// of having life, where density is a number between 0.0 and 1.0.  If a random number
	// between 0.0 and 1.0 created for each cell is less than the input density the cell
	// will be set to be alive.
	// INPUT: density (double between 0.0 and 1.0)
	// OUTPUT: nothing
	/* Psuedocode
		1. FOR (each cell ) DO
			- IF ( a random number is less than the density ) DO
					- set the cell to alive
		   END
	*/
	public void initializeRandom(double density){
		Cell c;
		for (int i=0; i<this.scape.getRows(); i++){
			for( int j=0; j< this.scape.getCols(); j++){
				if( Math.random() <= density){
					c = scape.getCell(i,j);
					c.setAlive(true);
				}
			}
			
			
		}
	
	}
	

	// This function will print out the grid where a ' ' represents a dead cell
	// and '0' represents a live cell in the grid
	public void print(){
		System.out.println(scape.toString());
	}
	
	// This function will advance the Landscape a step
	public void advance(){
		scape.advance();
	}
	
	// This function will run the game of life for a given number of loops ( int loops )
	// It will also pause for 500 ms.
	// INPUT: int loops
	// OUTPUT: nothing
	/* Pseudocode
		1. FOR ( the designated number of loops ) DO
			- Print out iteration number
			- print out the grid
			- advance the game one turn
			- sleep 500 ms
		   END
	*/
	public void run(int loops) throws InterruptedException{
		for( int i=1; i<(loops+1); i++){
			System.out.println("Iteration number " + i + "\n\n\n");
			print();
			advance();
			Thread.sleep(500);
		}
	}	


	// This function will run the game of life. 
	/*
	 * The command line input will be of the form
	 * 	java LifeSimulation [rows] [cols] [iterations] [density/mode]
	 * 			- [rows] == integer greater than 0
	 * 			- [cols] == integer greater than 0
	 * 			- [iterations] == integer 0 or greater
	 * 			- [density/mode] == double between 0.0 and 1.0. If the input is greater than 1.0 it wills start the custom grid mode
	 * 					- which will prompt you to load a grid from a text file
	 *  PROGRAM INPUT OPTIONS:
	 * 	 		- if nothing is input, the program will run a grid of 20 rows, 80 columns, 100 iterations, 0.5 density
	 * 			- if just the rows are input, the columns will be set to the number of rows, unless the number of rows < 0 (goes to default 20x80)
	 * 					- Iterations set to default 100, density set to default 0.5
	 * 			- if rows, cols and iterations are input the density is set to default 0.5
	 * 			- if exactly 4 inputs the rows, cols iterations and density will be set
	 * 			- if you input a density > 1.0, a new LifeSimulation mode is run where you get to load a grid from a text file.
	 * 			- if more than 4 inputs into command line, only the first 3 will be read
	 */
	public static void main( String[] args ) throws InterruptedException, IOException
	{
		
		int rows = 20;
		int cols = 80;
		// initialized here because the compiler would otherwise think it could be uninitialized
		LifeSimulation LS = new LifeSimulation(20,80);
		int iterations = 100;
		double density = 0.5;
		// No inputs. 20/80 size grid loop a 100 times
		if (args.length == 0){
			System.out.println("Default values used of 20 ros, 80 columns, and 100 iterations");
			LS.initializeRandom(density);
			}
		// if there is only 1 input -- the number of rows, or if rows < 0 default 20x80 grid
		else if( args.length  < 2 ){
			System.out.println("Only 1 input, need the number of columns. A square will be made");
			rows = Integer.parseInt(args[0]);
			if (rows <0) {
				System.out.println("number of rows cannot be negative. Game changed to default"
						+ "20 rows by 80");
				rows = 20;
				cols = 80;
				
			}
			else{
				cols = rows;
			}
			
			LS = new LifeSimulation(rows,cols);
			LS.initializeRandom(density);
			}
		// more 1 input
		else {
			rows = Integer.parseInt(args[0]);
			cols = Integer.parseInt(args[1]);
			if( (rows < 0 ) ){
				System.out.println("Bad Input! Rows set to default 20");
				rows = 20;
			}
			else if ( cols < 0 ){
				System.out.println("Bad Input! Cols set to default 80");
				cols = 80;
			}
			
			// if there are at least 3 inputs then they have input
			// rows cols iterations
			if( args.length >= 3 ){
				iterations = Integer.parseInt(args[2]);
				// if iterations is less than 0 doesn't make sense. Iterations will be set to the default 100.
				if (iterations < 0){
					System.out.println("Bad Input. Iterations must be greater than 0. Set to default 100");
					iterations = 100;
				}
			}
			// If there is no specified iterations on the input, set to default 100.
			else{
				iterations = 100;
			}
			
			// This input will be the life density or can also open another mode
			// if you can set the density of the life in the grid.
			// Any number greater than 1 will open another mode of the game
			// where you can load a game map.
			if( args.length == 4 ){
				density = Double.parseDouble(args[3]);
				System.out.println(density);
				// can't have a density less than 0, will automatically change to default
				if( density <= 0 ){
					System.out.println("density too low, reset to .5");
					density = 0.5;
					LS = new LifeSimulation(rows,cols);
					LS.initializeRandom(density);
				}
				// if the density is greater than 1 this starts a new game mode where you can load a text file.
				else if( density > 1 ){
					// Options displayed to user
					System.out.println("You have selected a new mode in this game." );
					System.out.println("You can load a predesigned map or give the path to your " + 
									"own text file.\n Press the given number for the following " + 
									"options:\n\n 1) Blinker \n 2) Blinker2 \n 3) Block \n 4)" + 
									" Boat \n 5) Glider \n 6) LWSS \n 7) Pulsar \n 8) Toad \n" + 
									" 9) enter your own path to a text file");
					// read in user selection
					Scanner reader = new Scanner(System.in);
					int choice = Integer.parseInt(reader.nextLine());
					// Switch on user selection to determine which files to load
					switch (choice) {
						//load Blinker.txt
						case 1:
							System.out.println("Loading Blinker.txt ...");
							LS = new LifeSimulation("./Patterns/Blinker.txt");
							break;
						// load Blinker2.txt
						case 2:
							System.out.println("Loading Blinker2.txt ...");
							LS = new LifeSimulation("./Patterns/Blinker2.txt");
							break;
						// load block.txt
						case 3:
							System.out.println("Loading Block.txt ...");
							LS = new LifeSimulation("./Patterns/Block.txt");
							break;
						// load boat.txt
						case 4:
							System.out.println("Loading Boat.txt ...");
							LS = new LifeSimulation("./Patterns/Boat.txt");
							break;
						// load Glider.txt
						case 5:
							System.out.println("Loading Glider.txt ...");
							LS = new LifeSimulation("./Patterns/Glider.txt");
							break;
						// load LWSS.txt
						case 6:
							System.out.println("Loading LWSS.txt ...");
							LS = new LifeSimulation("./Patterns/LWSS.txt");
							break;
						// load Pulsar.txt
						case 7:
							System.out.println("Loading Pulsar.txt ...");
							LS = new LifeSimulation("./Patterns/Pulsar.txt");
							break;
						// load Toad.txt
						case 8:
							System.out.println("Loading Toad.txt ...");
							LS = new LifeSimulation("./Patterns/Toad.txt");
							break;
						// load a text file input by the user. Inputs the full path
						case 9:
							System.out.println("Input the full path to the text file");
							String path = reader.nextLine();
							LS = new LifeSimulation(path);
							break;
						// bad input. exits the program
						default:
							System.out.println("Bad input! pick a number 1-9");
							return;
					}

				
			
				}
				else{
					LS.initializeRandom(density);
				}
				
			}
			// if there are more than 4 arguments it will ignore all the arguments after the 3rd and use the 1st for rows, 2nd for cols, 3rd for iterations
			// the density will be set at 0.5
			else {
				LS = new LifeSimulation(rows,cols);
				LS.initializeRandom(density);	
			}
			
			
			

	
		}	
		// all of the simulations will be run a given number of iterations. This is either specified on the command line or changed to the default 100 iterations
		LS.run(iterations);
	}

}