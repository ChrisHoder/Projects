// FILE: MillipedeGame.java
// AUTHOR: Chris Hoder
// DATE: 11/22/2011
// PROJECT 09

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.PriorityQueue;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

/**
 * This class will play the Millipede arcade game.
 * @author chris
 *
 */
public class MillipedeGame {

	//data declarations
	/** 
	 * Landscape upon which the game is played
	 */
	private Landscape scape;
	/**
	 * Display for the game
	 */
	private LandscapeDisplay display;
	/**
	 * Text display at bottom
	 */
	private JLabel textMessage;
	/** 
	 * displays the level that we are currently on
	 */
	private JLabel level;
	/**
	 * displays the number of lives left
	 */
	private JLabel livesLeft;
	/**
	 * Pause/Play Button
	 */
	private JButton pauseButton;
	/**
	 * Quit Button
	 */
	private JButton quitButton;
	
	/** 
	 * starting x position of the Defender
	 */
	private  final double X_START;
	/**
	 * starting y position of the Defender
	 */
	private  final double Y_START;
	
	/**
	 * iterations between saves, if the saveState is set to Save
	 */
	private static int SAVE_ITERATIONS = 50;
	/**
	 * enum which controls whether the simulation is playing, paused, or exiting
	 * @author chris
	 *
	 */
	public static enum PlayState { PLAY, PAUSE, STOP, START }
	/**
	 * Current state of the game
	 */
	public static PlayState state;
	/**
	 *  controls whether or not the to save the images every 50 iterations or not
	 * @author chris
	 *
	 */
	private enum saveState {SAVE, NO_SAVE}
	/**
	 * Current save state of the game
	 */
	private saveState saveStatus;
	/**
	 * Pause time
	 */
	private static long pause;
	
	
	/**
	 * This keeps track of the score in the game
	 */
	public static int score;
	
	/** 
	 * current level
	 */
	private int levelNum;
	
	/**
	 * number of lives left
	 */
	private int lifes;
	
	/**
	 * number of lives you start with
	 */
	public static int START_LIVES = 4;
	/**
	 * Starting size of Millipedes. This number will increase fast with each additional
	 * level
	 */
	public static int MillipedeStartSize = 20;
	/**
	 * Number of Obstacles to start with
	 */
	public static int OBSTACLES_START = 20;
	
	/**
	 * Iteration counter
	 */
	private int iteration;
	
	/**
	 * This maintains the list of the highscores that are
	 * displayed
	 */
	private JList highscores;
	
	/**
	 * This PriorityQueue holds all of the scores  on the game that
	 * have been saved. It is sorted based on score from high to low
	 */
	private PriorityQueue<ScoreData> allScores;
	
	/**
	 * This is the path to the file where the HighScores are saved
	 */
	private static final String path = "HighScores.txt";
	
	
	/**
	 * Constructor for the Millipede game. This will start the game with a landscape
	 * of the given width, height. It will also start the game initially paused and not
	 * saving images. The user starts with START_LIVES number of lives and with MillipedeStartSize number
	 * of Millipedes
	 * @param width - width of the landscape
	 * @param height - height of the landscape
	 */
	public MillipedeGame(int width, int height){
		// initialize new landscape at given width,height
		this.scape = new Landscape( width, height );
		// new display
		this.display = new LandscapeDisplay(scape, 8);
		//determine the start points of the defender
		this.X_START = (int)(width/2);
		this.Y_START = (int)((9.0/10.0)*height);
		
		//initial states of enums, the game is paused and we are not saving 
		MillipedeGame.state = PlayState.PAUSE;
		this.saveStatus = saveState.NO_SAVE;
		// initial pause time
		MillipedeGame.pause = 100;
		// initially no iterations
		this.iteration = 0;
		// initially start at level 1
		this.levelNum = 1;
		//start with START_Lives number of lives
		this.lifes = MillipedeGame.START_LIVES;
		// score is initially 0
		MillipedeGame.score = 0;
		// this sets up the key commands and the display customization
		setupUI();
		
		
		this.display.repaint();
	}
	
	/**
	 * This method initializes the obstacles onto the landscape, they will spawn in random, integer locations across the board
	 * they do not span in the bottom 1/5 of the board (where the defender is). They will also not spawn near the Defenders start location
	 * @param numObstacles -  number of obstacles to create
	 */
	public void initializeObstacles( int numObstacles ) {
		// add new obstacles
		for ( int i = 0 ; i < numObstacles ; i++){
			// find a random x,y position (as integers)
			double xPos = (int)(Math.random()*scape.getWidth());
			double yPos = (int)(Math.random()*(4.0/5.0)*(scape.getHeight()-1) + 1);
			// avoid the starting position ( don't want to start on an obstacle)
			if( ( xPos+3 >= this.X_START && xPos <= this.X_START ) &&  ( yPos+3 >= this.Y_START && yPos <= this.Y_START ) ){
				//shift to not be starting next to the defender
				xPos += 10;
			}
			// add this agent to the landscape
			this.scape.addAgent(new Obstacle(xPos, yPos ) );	
		}
	}
	
	/**
	 * This method will initialize the Millipede onto the landscape. Initially it will be entirely off of 
	 * the landscape and then come on the top left row.
	 * @param size - size of the Initial millipede to create
	 */
	public void initializeMillipede( int size ) {
		SimObjectList mill = new SimObjectList();
		// for each new millipede
		for ( int i = 0 ; i < size ; i++){
			// create them next to each other, starting off the screen in the top left
			mill.add(new Millipede(-1 - i, 0));
		}
		//add this string of Millipedes to the landscape
		this.scape.addResource(mill);	
	}
	
	/**
	 * This method will initialize a new defender on the landscape at the given X_START, Y_START
	 * positions
	 */
	public void initializeDefender(){
		Defender df = new Defender(this.X_START, this.Y_START);
		scape.setDefender(df);
		
	}
	
	/**
	 * This method sets up the User interface with the buttons
	 * and the text that is displayed outside of the landscape in
	 * the display
	 */
	private void setupUI(){
		
		// add the score element
		this.textMessage = new JLabel("Score: -");
		JPanel panel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
		panel.add(this.textMessage);
		
		
		
		//adds a title
		JLabel title = new JLabel("Millipede Game");
		JPanel panel2 = new JPanel(new FlowLayout(FlowLayout.CENTER));
		panel2.add(title);
		
		
		JPanel panel3 = new JPanel(new FlowLayout(FlowLayout.CENTER));
		String scores[] = updateScores(MillipedeGame.path);
		this.highscores = new JList(scores);
		panel3.add(highscores);
		
		
		//adds the level
		this.level = new JLabel("Level: 1");
		panel2.add(this.level);
		
		//adds the number of lives left
		this.livesLeft = new JLabel("Lives: " + this.lifes);
		panel2.add(this.livesLeft);
	
		

		
		
		
		//creates the Pause and Quit buttons
		this.pauseButton = new JButton("Play");
		this.quitButton  = new JButton("Quit");
		
		// listen for keystrokes
		Control control = new Control();
		//adds listener
		this.display.addKeyListener(control);
		// pause and quit button listeners
		this.pauseButton.addActionListener(control);
		this.quitButton.addActionListener(control);
		// allows us to refocus on the display
		display.setFocusable(true);
		display.requestFocus();
		// add buttons to the display
		panel.add(this.pauseButton);
		panel.add(this.quitButton);
		
		// add our panels to the board
		this.display.add(panel, BorderLayout.SOUTH);
		this.display.add(panel2,BorderLayout.NORTH);
		this.display.add(panel3,BorderLayout.EAST);
		
		this.display.pack();
	
	
	}
	
	
	/**
	 * This method will update the score display in the display
	 */
	public void updateTotals(){
		// reset text
		this.textMessage.setText("Score: " + MillipedeGame.score);;
	}
	
	/**
	 * This method will get the new top 6 high scores and return them
	 * as an array of Strings. The first string will be "HighScores"
	 * @param path - full path to the HighScores data txt file
	 * @return returns an array of the top 5 scores, length 6, with the
	 * first element being the string "HighScores"
	 */
	public String[] updateScores(String path){
		// loads a fresh set of high scores
		loadScores(path);
		String topScores[] = new String[6];
		// first line is the header
		topScores[0] = "HighScores";
		ScoreData temp;
		// for the top 5 scores, get them and add them to our array
		for( int i = 1 ; i < topScores.length ; i++){
			temp = this.allScores.poll();
			// not that many scores yet
			if(temp == null){
				break;
			}
			// add it to the topScores array
			topScores[i] = "" + i + ". " + temp.getName() + " " + temp.getScore(); 
		}
		// return array
		return topScores;
	}
	
	/**
	 * This method will create  new source file for the highScores data.
	 * If the file already exists and this method is called it will be 
	 * overwritten
	 * @param path - full pathname to the file to be created
	 */
	public void createNewScoreFile(String path){
		//try to create a file and initialize it with one default value
		try{
			FileWriter fw;
			//create a new file
			fw = new FileWriter(path);
			PrintWriter text = new PrintWriter( fw );
			// add new line
			text.println("Chris;100");
			//close it
			text.flush();
			fw.close();
		}
		// can't create the file, exit program
		catch (IOException ie){
			System.out.println(ie.getMessage());
			System.exit(-1);
		}
		
		
	}
	
	/**
	 * This method will save a new High score to the file
	 * @param path - full pathname to the highscore path file
	 * @param user - string that is the user's name
	 * @param score - score that the user got
	 */
	public void addScore(String path, String user, int score){
		//try to create a file and initialize it with one default value
		try{
			FileWriter fw;
			fw = new FileWriter(path, true);
			PrintWriter text = new PrintWriter( fw );
			// print new line of a score
			text.println(user + ";" + score );
			text.flush();
			fw.close();
		}
		// can't create the file, exit program
		catch (IOException ie){
			System.out.println(ie.getMessage());
			System.exit(-1);
		}
	}
	
	/**
	 * This method will load all of the scores in the
	 * text file into a sorted PriorityQueue. each score
	 * will be saved as a SaveData class which holds the name
	 * and the score.
	 * @param path - full pathname to the txt file holding the
	 * high scores
	 */
	public void loadScores(String path){
		this.allScores = new PriorityQueue<ScoreData>();
		ReadFile rf = new ReadFile(path);
		// returns a string array with each element corresponding
		// to a line in the file
		String[] fileData = new String[0];
		// see if we can open the file
		try{
			fileData = rf.openFile();
		}
		// file does not exist
		catch(IOException e){
			//create file this will exit if we cannot create a file 
			// the exception will be thrown in this method (caught and exited in the 
			// method also)
			createNewScoreFile(path);
			//recursively call itself to get the data loaded
			loadScores(MillipedeGame.path);
		}
		// for each line in the file
		for( int i = 0 ; i < fileData.length ; i++){
			String[] line = fileData[i].split(";");
			// if the line is less than 2 sections, it is corrupt and not
			// of the format this program saves it to. exit the program
			if(line.length < 2){
				System.out.println("File currupt!");
				System.exit(-1);
			}
			// create a new score node
			ScoreData newScore = new ScoreData(line[0],Integer.parseInt(line[1]));
			// add it to the PrioroityQueue
			this.allScores.add(newScore);
		}
		
		
	}
	
	
	/**
	 * This method will iterate the game by one iteration. It will
	 * handle what to do if the game ends, a defender dies, and if
	 * the level is complete.
	 */
	public void iterate() {
		// if the game is playing
		if( MillipedeGame.state == PlayState.PLAY){
			//incremement our iteration count
			this.iteration++;
			// check the advance method to be able to check if the defender died
			boolean check = scape.advance();
			// the Defender has died
			if(!check){
				// call the method to handle the defender death
				defenderDied();
			}
			// update the display
			display.repaint();
			// update the score
			updateTotals();
			// if all of the millipede's are dead, next level
			if( scape.getResources().size() == 0 ){
				this.levelNum++;
				this.level.setText("Level: " + this.levelNum);
				//doubles the start size of the Millipede for the next level
				MillipedeGame.MillipedeStartSize = MillipedeGame.MillipedeStartSize*2;
				//creates new level
				this.reset();
			} 
			
			// if we want to save images of the game and we are on the right iteration multiple
			if(this.saveStatus == saveState.SAVE &&  ( this.iteration % MillipedeGame.SAVE_ITERATIONS == 0 ) ){
				// create appropriate filename
				String filename = String.format("image-%04d.png",this.iteration);
				// save the image
				this.display.saveImage(filename);
				
			}
		}
		//sleep/pause
		try{
			Thread.sleep(MillipedeGame.pause);
		}
		catch (InterruptedException ie){
			ie.printStackTrace();
		}
	}
	
	/**
	 * This method handles the case where the defender has died during play
	 * If the user has lives left, it will decrement the lives and reset the Defender
	 * to the starting position.
	 * <p>
	 * If the user does not have lives left it will pause the game so that the user can look at his score/level and so on.
	 * It will also turn the pauseButton into a Restart button. The user can then restart the game from level 0 with a score of 0
	 */
	public void defenderDied() {
		// decrement number of lives
		this.lifes--;
		// if there was at least 1 life when the Defender died
		if( this.lifes >= 0){
			// update lives left display
			this.livesLeft.setText("Lives: " + this.lifes);
			//create a new Defender
			this.initializeDefender();
		}
		// out of lives, the game is over
		else{
			MillipedeGame.state = PlayState.PAUSE;
			// let the user have the option of restarting
			this.pauseButton.setText("Restart");
			
			// get a name for a high score input box
			String str = JOptionPane.showInputDialog(null, "Enter a name for a high score:","CWH");
			if( str != null){
				this.addScore(MillipedeGame.path, str, MillipedeGame.score);
				this.highscores.setListData(updateScores(MillipedeGame.path));
			}
		}
	}
	
	/**
	 * This method will reset the game. It will not reset the level or number of lives left. This method is used for
	 * starting the next level 
	 */
	public void reset(){
		// clear the Landscape (of everything but the defender)
		this.scape.clear();
		// initialize new obstacles and Millipede
		this.initializeObstacles(MillipedeGame.OBSTACLES_START);
		this.initializeMillipede(MillipedeGame.MillipedeStartSize);
		//set the iteration to 0
		this.iteration = 0;
	}
	
	/**
	 * This method will restart the game from the begining
	 */
	public void reStart() {
		// set arbitrary start size for the millipede
		MillipedeGame.MillipedeStartSize = 20;
		//empty landscape, reset objects etc
		reset();
		//reinitialize lives
		lifes = MillipedeGame.START_LIVES;
		// set score to 0
		MillipedeGame.score = 0;
		// reset level
		levelNum = 1;
		//update display
		livesLeft.setText("Lives: " + lifes);
		//update the level
		level.setText("Level: " + levelNum);
		//create new defender
		initializeDefender();
		// pause the game
		pauseButton.setText("Start");
		state = PlayState.START;
	}
	
	/**
	 * This method repaints the display
	 */
	public void repaint(){
		display.repaint();
	}
	

	/**
	 * This method will print the usage of the MillipedeGame main function to the terminal.
	 * The usage looks as follows:
	 * <p>
	 * Usage: MillipedeGame [-w,--width] [-h, --height] [-l, --lives] 
     * [-m, --millipede] [-o, --obstacles]
	 */
	private static void printUsage() {
        System.err.println(
        		"Usage: MillipedeGame [-w,--width] [-h, --height] [-l, --lives] " +
        		                        "[-m, --millipede] [-o, --obstacles]");
		}

	
	
	/**
	 * This method runs the Millipede Game
	 * @param args - optional input of the width(w), height(w), number of lives (l), 
	 * size of initial millipede (m), and the number of obstacles on the landscape (o). See printUsage method
	 * for usage of this method
	 */
	public static void main(String[] args)  {
		
		
		CmdLineParser parser = new CmdLineParser();
		// set up the command line options
		CmdLineParser.Option widthSize      = parser.addIntegerOption('w',"width");
		CmdLineParser.Option heightSize     = parser.addIntegerOption('h',"height");
		CmdLineParser.Option livesStart     = parser.addIntegerOption('l',"lives");
		CmdLineParser.Option MillipedeSize  = parser.addIntegerOption('m',"millipede");
		CmdLineParser.Option ObstaclesStart = parser.addIntegerOption('o',"obstacles");
		
		// Try to parse the command line, if there is an error it will catch it, print out the syntax and exit the program
		try{
			parser.parse(args);
		}
		catch( CmdLineParser.OptionException e){
			System.err.println(e.getMessage());
			MillipedeGame.printUsage();
			System.exit(-1);
		}
		
		// get the input options, if they are not input, a reasonable default has been chosen
		int width       = (Integer)parser.getOptionValue( widthSize ,    new Integer(50));
		int height      = (Integer)parser.getOptionValue( heightSize,    new Integer(30));
		int livesstrt   = (Integer)parser.getOptionValue( livesStart,    new Integer(4));
		int millSize    = (Integer)parser.getOptionValue( MillipedeSize, new Integer(20));
		int obsStart    = (Integer)parser.getOptionValue( ObstaclesStart,new Integer(20));
		
		
		//set defaults
		MillipedeGame.START_LIVES = livesstrt;
		MillipedeGame.MillipedeStartSize = millSize;
		MillipedeGame.OBSTACLES_START = obsStart;
				
		// create a new game
		MillipedeGame mg  = new MillipedeGame(width,height);
		mg.loadScores("data.txt");
		mg.reStart();
		
		// While we are still playing, iterate the game forever
		while(MillipedeGame.state != PlayState.STOP){
			mg.iterate();
		}
		//close/exit
		mg.display.dispose();
		System.exit(1);
	}
	
	/**
	 * This class is the control class for all of the user input via the keyboard
	 * @author chris
	 *
	 */
	private class Control extends KeyAdapter implements ActionListener{
		
		/**
		 * This method handles the keypressed events (namely the arrow keys and the space bar).
		 * Also known as the motion and fireing
		 */
		public void keyPressed(KeyEvent e){
			if( state == PlayState.PLAY){
				// initialize move numbers
				double xMove = 0;
				double yMove = 0;
				// hit the up key, move up
				if( e.getKeyCode() == KeyEvent.VK_UP || e.getKeyCode() == KeyEvent.VK_KP_UP){
					xMove = 0;
					// by move up you are actually moving to smaller y values
					yMove = -Defender.D_SPEED;
				}
				// hit the down key, move down
				else if( e.getKeyCode() == KeyEvent.VK_DOWN ||  e.getKeyCode() == KeyEvent.VK_KP_DOWN){
					xMove = 0;
					// move down is actually greater y values
					yMove = Defender.D_SPEED;
					
				}
				// hit the right key, move right
				else if( e.getKeyCode() == KeyEvent.VK_RIGHT || e.getKeyCode() == KeyEvent.VK_KP_RIGHT){
					xMove = Defender.D_SPEED;
					yMove = 0;
				}
				// hit the left key, move left
				else if( e.getKeyCode() == KeyEvent.VK_LEFT || e.getKeyCode() == KeyEvent.VK_KP_LEFT){
					xMove = -Defender.D_SPEED;
					yMove = 0;
				}
				// hit the space key, fire a bullet (if one isn't already on the landscape)
				else if( e.getKeyCode() == KeyEvent.VK_SPACE){
					// if there is no bullet on the landscape
					if( scape.getBullet() == null ){
						// fire a bullet from the defender's location
						Defender d = (Defender)scape.getDefender();
						scape.setBullet(new Bullet(d.getX(),d.getY()));
					}
				}
				
				Defender def = (Defender)scape.getDefender();
				// check to see if the defender can move
				boolean check = def.move(xMove, yMove, scape);
				// the defender has died by moving into a millipede
				if( check == false){
					// call the defenderDied method to handle it appropriately
					defenderDied();
				}
			}
		}
		
		/**
		 * This method handles key types. This is the pause, quit, speed up, slow down
		 * save and stop saving key buttons that can be pressed.
		 * <p>
		 * You can press p to pause/play the game. q to quit the game. w to increase the speed. s to 
		 * decrease the speed. r to save/stop saving images
		 */
		public void keyTyped(KeyEvent e){
			//pause the game
			if (("" + e.getKeyChar()).equalsIgnoreCase("p") && 
				state == PlayState.PLAY)
			{
				state = PlayState.PAUSE;
				display.repaint();
				pauseButton.setText("Play");
				System.out.println("*** Simulation paused ***");
			}
			// resume the game
			else if (("" + e.getKeyChar()).equalsIgnoreCase("p") && 
				state == PlayState.PAUSE && lifes >= 0)
			{
			
				state = PlayState.PLAY;
				pauseButton.setText("Pause");
				System.out.println("*** Simulation resumed ***");
				
			}
			else if (("" + e.getKeyChar()).equalsIgnoreCase("p") &&
				state == PlayState.PAUSE){
					reStart();
					display.repaint();
				}
			else if ((""+e.getKeyChar()).equalsIgnoreCase("p") &&
					state == PlayState.START ){
				state = PlayState.PLAY;
				pauseButton.setText("Pause");
				display.repaint();
				System.out.println("*** Simulation Started ***");
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
				if( (MillipedeGame.pause - 20) < 0){
					MillipedeGame.pause = 0;
					System.out.println("Simulation speed at max!");
				}
				else{
					MillipedeGame.pause -= 20;
					System.out.println("Simultion speed increased by 20 ms");
				}
			}
			// decrease the simulation speed
			else if( ("" + e.getKeyChar()).equalsIgnoreCase("s")){
				System.out.println("Simulation speed decreased by 20ms");
				MillipedeGame.pause += 20;
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
		
		}	
		

		@Override
		/**
		 * This method will handle the button pushes for the pauseButton and the
		 * quitButton
		 */
		public void actionPerformed(ActionEvent e) {
			// if the game is playing and the user hits pause
			if( ("" + e.getActionCommand()).equalsIgnoreCase("Pause")){
				state = PlayState.PAUSE;
				// change the Button to display Play, so the user can start the game again
				pauseButton.setText("Play");
				display.repaint();
			}
			// if the game is playing and the user hits the play button
			else if( (""+ e.getActionCommand()).equalsIgnoreCase("Play")){
				state = PlayState.PLAY;
				pauseButton.setText("Pause");
			}
			else if ( ("" + e.getActionCommand()).equalsIgnoreCase("Start")){
				state = PlayState.PLAY;
				//change Button to display Pause
				pauseButton.setText("Pause");
			}
			// if the user hits the quit button, ends game
			else if( ("" + e.getActionCommand()).equalsIgnoreCase("Quit")){
				state = PlayState.STOP;
			}
			// if the user hits the restart button it resets the game to the very beginning
			else if( ("" + e.getActionCommand()).equalsIgnoreCase("Restart")){
				reStart();
			}
			//reset focus on the display
			display.requestFocus();
		}
		
		
	}
}
