// scanner data from http://www.youtube.com/watch?v=5DdacOkrTgo
/*
 * Author: Chris Hoder
 * Date: 9/19/11
 * Project 1
 * File: GamePlay.java
 */

import java.util.Scanner;


//This class will play the game blackjack with interactive modes where the user can decide
//what they want to play.
public class GamePlay {

	//data declarations
	//private Simulation simu;
	private Blackjack b;
 	
 	//constructor just initializes the blackjack object
 	public GamePlay(){
 		b = new Blackjack();
 	
 	}
	
 	//This function will run the blackjack program. There are no inputs but the user will be prompted
 	// for a choice between simulation options, to play a game against the computer or to see the player's
 	// stats against the computer
	public void game(){
		//opening information to screen
		System.out.println("\n\n**************************************");
		System.out.println("Welcome to the Blackjack Player!");
		System.out.println("**************************************\n\n");
		int result;
		int wins = 0;
		int losses = 0;
		int pushes = 0;
		// infinite loop. will go until the user prompts the program to exit (press 5)
		while (true){
			//  print game menu
			System.out.print("\n\n\n");
			System.out.print(" This program has 5 options: \n Press 1 to play blackjack against the computer \n Press 2 to Simulate a game of blackjack against the computer \n Press 3 to simulate 1000 games against the computer \n Press 4 to display your stats against the computer \n Press 5 to exit \n\n");
			System.out.print("make Choice: \t");
			//read choice
			Scanner reader = new Scanner(System.in);
			int choice = Integer.parseInt(reader.nextLine());
			System.out.println(choice);
			//switch on the choice
			System.out.println("\n");
			switch (choice) {
				// interactive game against the computer
				case 1: 
					System.out.println("You chose to play against the computer");
					//plays the interactive game of blackjack
					result = b.play();
					// The following will take the output from the blackjack game and use it
					// to update the stats for the player
					if (result == 0){
						pushes += 1;
					}
					else if (result  == 1){
						wins += 1;
					}
					else{
						losses += 1;
					}
					break;
				//Simulate a number of games, it will prompt you for the choice of simulations
				case 2:
					System.out.println("You chose to simulate a game");
					System.out.println("How many games do you wish to simulate? \t");
					int choice2 = Integer.parseInt(reader.nextLine());
					b.sim(choice2);
					break;
				//Simulate 1000 games
				case 3:
					System.out.println("You chose to simulate 1000 games");
					b.sim(1000);
					break;
				// This will print the current stats that the player has against the computer
			   // in interactive mode only
				case 4:
					System.out.print("\n**************\nSTATS\n**************\n");
					System.out.print("Wins: " + wins + "\nLosses: " + losses + "\n Pushes: " + pushes + "\n\n");
					break;
				// this will exit the program
				case 5:
					return;
				// Prompts the user to input a correct value
				default:
					System.out.println("\nwrong input! Input a number between 1-5");
					break;
				}
			
			
		}
	
	
	}
	
	
	// This will just run the game function which does the game
	public static void main( String[] args){
		GamePlay gp = new GamePlay();
		gp.game();
		
		}	
	}


