// FILE: ElevatorSimulation.java
// AUTHOR: Brian Eastwood with modifications by Chris Hoder
// DATE: 11/13/2011
// PROJECT 08

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;


/**
 * Simulates the operation of a bank of elevators.  This simulation was 
 * inspired by waiting for an elevator at the Marriott Marquis Times Square 
 * elevator bank, <a href="http://flic.kr/p/rvHG7" target="_blank">seen here</a>.
 * <p>
 * The Javadoc for this project was generated with the following
 * command:
 * <pre><code>
 * $ javadoc -d html -private -link http://download.oracle.com/javase/6/docs/api/ *.java
 * </code></pre>
 * 
 * @author bseastwo
 */
public class ElevatorSimulation
{
	//private ElevatorBank bank;
	private Landscape landscape;
	private LandscapeDisplay display;
	private JLabel textMessage;
	
	// controls whether the simulation is playing, paused, or exiting
	private enum PlayState { PLAY, PAUSE, STOP }
	private PlayState state;
	// controls whether or not the to save the images every 10 iterations or not
	private enum saveState {SAVE, NO_SAVE}
	private saveState saveStatus;
	
	
	
		
	// simulation control
	private int iteration;
	// the number of milliseconds to pause between iterations.
	public static int pause;
	
	/**
	 * Initializes an elevator simulation.  Creates an elevator bank and
	 * populates a landscape with the elevators.
	 * 
	 * @param lifts the number of elevators in the simulation
	 * @param floors the number of floors in the simulation
	 * @param capacity the passenger capacity of each elevator
	 */
	public ElevatorSimulation(int lifts, int floors, int capacity)
	{
		ElevatorSimulation.pause = 1000;
		
		
		// creates the elevator bank
		ElevatorBank bank = new ElevatorBank(0,0,lifts,floors,capacity);
		Dispatch.instance().setBank(bank);
		
		// create the landscape
		this.landscape = new Landscape(bank.getElevatorCount() * 4 + 4, bank.getFloorCount() + 4);
		Dispatch.instance().setLandscape(this.landscape);
		
		// create the display
		if (this.display != null)
			this.display.dispose();
		this.display = new LandscapeDisplay(landscape, 16);
		
		//set initial state
		this.state = PlayState.PLAY;
		this.saveStatus = saveState.NO_SAVE;
		
		// set the bank to the landscape ( it will have it's own update method)
		this.landscape.setBank(bank);
		
		
		// add the elevators to the landscape
		for (int i = 0; i < bank.getElevatorCount(); i++)
		{
			bank.getElevator(i).setPosition(4 * i + 2, 2);
			this.landscape.addResource(bank.getElevator(i));
		}
		
		
		
		this.setupUI();
	}
	
	/**
	 * Sets up the UI controls for the elevator simulation.
	 */
	private void setupUI()
	{
		// add elements to the UI
		this.textMessage = new JLabel("Your text here.");
		
		JPanel panel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
		panel.add(this.textMessage);
		
		this.display.add(panel, BorderLayout.SOUTH);
		this.display.pack();
		
		// listen for keystrokes
		Control control = new Control();
		this.display.addKeyListener(control);
	}
	
	/**
	 * Implements one iteration (time step) of the elevator simulation.
	 */
	public void iterate()
	{
		this.iteration++;

		if (this.state == PlayState.PLAY)
		{
			// added this private method to make it easier to iterate individually when the game is paused
			iterateInternal();
		}
		

		// pause for refresh
		try
		{
			Thread.sleep(ElevatorSimulation.pause);
		}
		catch (InterruptedException ie)
		{
			// do threads get insomnia?
			ie.printStackTrace();
		}
	}
	

	/**
	 * Implements one iteration of the elevator simulation. Private method to allow for single step iterations while
	 * the simulation is paused by the user.
	 */
	private void iterateInternal(){
		// dispatch new passengers
		Dispatch.instance().updateState();
		
		// update the landscape, display
		this.landscape.advance();
		this.display.repaint();
		
		// if the user wants to save images, then this will save every 10th iteration
		if( this.saveStatus == saveState.SAVE  &&  ( this.iteration % 10 == 0 ) ){
			String filename = String.format("image-%04d.png",this.iteration);
			this.display.saveImage(filename);
		}
			
		//prints statistics to the terminal
		this.printSimulationInformation();
	}
	
	/**
	 * This method will print out the current simulation statistics to the terminal.
	 */
	public void printSimulationInformation(){
		// print simulation information as well
		System.out.println("\n\n******");
		ElevatorBank bank = (ElevatorBank)this.landscape.getBank();
		System.out.println(bank);
		for (int i = 0; i < bank.getElevatorCount(); i++)
			System.out.printf("%3d    %s\n", i, bank.getElevator(i));
		System.out.println(Dispatch.instance().formatStatistics());
		
		this.textMessage.setText(Dispatch.instance().formatStatistics());
	}
	
	/**
	 * Runs an elevator simulation.
	 * @param args
	 */
	public static void main(String[] args)
	{
		// parse command line parameters
		String fileIn = null;
		String fileOut = null;
		for (int i = 0; i < args.length; i++)
		{
			// -h prints help information
			if (args[i].equalsIgnoreCase("-h"))
			{
				System.out.println("Usage:\n\tjava ElevatorSimulation {-o fileOut} {-i fileIn} {-h}\n" +
					"\t    -h          prints this help message\n" +
					"\t    -o fileOut  writes spawned passenger information to fileOut\n" +
					"\t    -i fileIn   reads spawned passenger information from fileIn\n" +
					"\t    fileIn and fileOut should not be the same file\n");
				System.exit(0);
			}

			// -o specifies an output file
			else if (args[i].equalsIgnoreCase("-o") && args.length > i+1)
				fileOut = args[i+1];

			// -i specifies an input file
			else if (args[i].equalsIgnoreCase("-i") && args.length > i+1)
				fileIn = args[i+1];
		}
		
		// initialize the simulation
		ElevatorSimulation sim = new ElevatorSimulation(8, 25, 8);
		

		// configure the dispatcher
		Dispatch.instance().setSpawnTries(8);
		Dispatch.instance().setGroundProbability(0.10);
		Dispatch.instance().setOtherProbability(0.08);

		if (fileIn != null)
			Dispatch.instance().readFromFile(fileIn);
		if (fileOut != null)
			Dispatch.instance().writeToFile(fileOut);

		System.out.println("Init => " + sim);
		
		// run simulation until terminated
		while (sim.state != PlayState.STOP)
		{
			sim.iterate();
		}
		
		// clean up and close the application
		Dispatch.instance().closeFiles();
		sim.display.dispose();
	}
	
	/**
	 * Provides simple keyboard control to the simulation by implementing
	 * the KeyListener interface.
	 * 
	 * The following keys have actions associated with them:
	 * <p>
	 * 	p : pause the game
	 * <p>
	 *  q : quit the simulation
	 *  <p>
	 *  w : increase the simulation speed by 100ms
	 *  <p>
	 *  s : decrease the simulation speed by 100ms
	 *  <p>
	 *  r : this will set the simulation to save an image every 10th iteration's display
	 *  <p>
	 *  e : this will print the current simulation statistics to the terminal
	 *  <p>
	 *  d : this will move the simulation forward by one iteration ( time step ) only if the game is paused
	 *  <p>
	 *  1 : this will set the Elevator strategy to INDIV
	 *  <p>
	 *  2 : this will set the Elevator strategy to INDIV_2
	 *  <p>
	 *  3 : this will set the Elevator strategy to GROUP
	 *  <p>
	 *  4 : this will set the Elevator strategy to GROUP_2
	 *  <p>
	 *  5 : this will set the Elevator strategy to GROUP_3 
	 *  
	 */
	private class Control extends KeyAdapter
	{
		/**
		 * Controls the simulation in response to key presses.
		 */
		public void keyTyped(KeyEvent e)
		{
			//pause the game
			if (("" + e.getKeyChar()).equalsIgnoreCase("p") && 
				state == PlayState.PLAY)
			{
				state = PlayState.PAUSE;
				System.out.println("*** Simulation paused ***");
			}
			// resume the game
			else if (("" + e.getKeyChar()).equalsIgnoreCase("p") && 
				state == PlayState.PAUSE)
			{
				state = PlayState.PLAY;
				System.out.println("*** Simulation resumed ***");
			}
			// quit the simulation
			else if (("" + e.getKeyChar()).equalsIgnoreCase("q"))
			{
				state = PlayState.STOP;
				System.out.println("*** Simulation ended ***");
			}
			
			// increase simulation speed
			else if ( ("" + e.getKeyChar()).equalsIgnoreCase("w")){
				// check that we dont go below 0
				if( (ElevatorSimulation.pause - 100) < 0){
					ElevatorSimulation.pause = 0;
					System.out.println("Simulation speed at max!");
				}
				else{
					ElevatorSimulation.pause -= 100;
					System.out.println("Simultion speed increased by 100 ms");
				}
			}
			// decrease the simulation speed
			else if( ("" + e.getKeyChar()).equalsIgnoreCase("s")){
				System.out.println("Simulation speed decreased by 100ms");
				ElevatorSimulation.pause += 100;
			}
			// change save state (save or not)
			else if (("" + e.getKeyChar()).equalsIgnoreCase("r")){
				// end saving of images
				if( saveStatus == saveState.SAVE){
					System.out.println("Saving of Simulation images terminated!");
					saveStatus = saveState.NO_SAVE;
				}
				// begin saving images
				else{
					System.out.println("Saving of Simulation has begun!");
					saveStatus = saveState.SAVE;
				}
			}
			// print the current simulation statistics
			else if (("" + e.getKeyChar()).equalsIgnoreCase("e")){
				System.out.println("Printing satistics");
				printSimulationInformation();
			}
			// this will advance by one iteration
			else if(("" + e.getKeyChar()).equalsIgnoreCase("d")){
				if( state ==  PlayState.PAUSE){
					iterateInternal();
				}
				else{
					System.out.println(" Will only iterate when paused!");
				}
				
			}
			// change strategy to INDIV
			else if(("" + e.getKeyChar()).equalsIgnoreCase("1")){
				if( state == PlayState.PAUSE){
					ElevatorBank.strategy = ElevatorBank.STRATEGY.INDIV;
					System.out.println(" Strategy changed to INDIV");
				}
				else{
					System.out.println(" Can only change strategies while paused");
				}
			}
			
			// change strategy to INDIV_2
			else if (("" + e.getKeyChar()).equalsIgnoreCase("2")){
				if( state == PlayState.PAUSE){
					ElevatorBank.strategy = ElevatorBank.STRATEGY.INDIV_2;
					System.out.println(" Strategy changed to INDIV_2");
				}
				else{
					System.out.println(" Can only change strategies while paused");
				}
			}
			// change strategy to GROUP
			else if (("" + e.getKeyChar()).equalsIgnoreCase("3")){
				if( state == PlayState.PAUSE){
					ElevatorBank.strategy = ElevatorBank.STRATEGY.GROUP;
					System.out.println(" Strategy changed to GROUP");
				}
				else{
					System.out.println(" Can only change strategies while paused");
				}
			}
			// change strategy to GROUP_2
			else if (("" + e.getKeyChar()).equalsIgnoreCase("4")){
				if( state == PlayState.PAUSE){
					ElevatorBank.strategy = ElevatorBank.STRATEGY.GROUP_2;
					System.out.println(" Strategy changed to GROUP_2");
				}
				else{
					System.out.println(" Can only change strategies while paused");
				}
			}
			
			// change strategy to GROUP_3
			else if (("" + e.getKeyChar()).equalsIgnoreCase("5")){
				if( state == PlayState.PAUSE){
					ElevatorBank.strategy = ElevatorBank.STRATEGY.GROUP_3;
					System.out.println(" Strategy changed to GROUP_3");
				}
				else{
					System.out.println(" Can only change strategies while paused");
				}
			}
		}	
	}
}
