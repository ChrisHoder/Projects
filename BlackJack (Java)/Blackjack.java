/*
 * Author: Chris Hoder
 * Date: 9/19/11
 * Project 1
 * File: Blackjack.java
 */

import java.util.Scanner;

//This class contains the information to simulate/play a blackjack game including a deck,player hand
// and a dealer hand
public class Blackjack {


	//data declarations, includes a deck, a player's hand and the dealer's hand
	private Deck deck;
	private Hand player;
	private Hand dealer;
	
	
	// This function sets up and resets the game
	public Blackjack(){
		this.deck = new Deck();
		this.player = new Hand();
		this.dealer = new Hand();
		reset(0);
	}


	// This function sets up the game, the integer input is a boolean where 0 means that it is going to deal
	// two cards to both players (as if for a simulation). 1 means 2 cards to player, 1 to dealer
	public void reset(int i){
		this.deck.build();
		//reset both player and dealer's hands
		this.player.reset();
		this.dealer.reset();
		//shuffle the deck
		this.deck.shuffle();
		//Deal 2 cards to both players
		if ( i == 0){
			deal();
		}
		//deal 2 cards to player, 1 to dealer
		else {
			dealInteractive();
		}
	}
	
	
	// This function deals out 2 cards to both players. to set up the game of
	//blackjack
	public void deal(){
		//deals player, dealer,player,dealer as a actual game would
		for(int i=0;i<2;i++) {
			this.player.add(this.deck.deal());
			this.dealer.add(this.deck.deal());
		}
	}
	
	//This function deals out a game to be played interactively by the player
	//It will only deal 1 card to dealer so that the player can only see one card initially
	public void dealInteractive(){
		this.player.add(this.deck.deal());
		this.dealer.add(this.deck.deal());
		this.player.add(this.deck.deal());
	}
	
	//This function will give the player another card if he chooses to hit in the
	//interactive mode. It will also check to see if the player has gone bust
	// returns true if not bust. false if bust
	public boolean hit(){
		this.player.add(this.deck.deal());
		//checkt to see if it is bust
		if (this.player.getValue() > 21){
			return false;
		}
		return true;
	}
	
	//This function prints out the state of the being the cards each player has and the total of the cards
	public void print(){
		System.out.println("The state of the game is as follows:");
		System.out.println(" The player currently has " + player.size() + " cards for a total of " + player.getValue());
		System.out.println(" The dealer currently has " + dealer.size() + " cards for a total of " + dealer.getValue());
	}
	
	// This function will have the player draw cards until the total value of the players hand is
	// equal to or above 16. the function returns false if the player goes over 21 (busts)
	public boolean playerTurn(){
		//Infinite loop until one of the conditions exits it
		while(true) {
			//hand value for the player
			int handValue = this.player.getValue();
			//if the player is bust -- returns false and exits
			if (handValue > 21) {
				return false;
			}
			//if the player is between 16 and 21 then it returns true and exits
			else if (handValue >= 16){
				return true;
			}
			//if the player is less than 16 it will hit another card and repeat while loop
			else{
				Card c = this.deck.deal();
				this.player.add( c);
			}
		
		}
	}
	
	
	// This function will have the dealer draw cards until the total value of the dealer's hand
	// is equal to or above 17. The function returns false if the dealer goes over 21 (busts)
	public boolean dealerTurn(){
			// infinite loop until one of the conditions exits it
			while(true){
				//hand total for dealer
				int handValue = this.dealer.getValue();
				// if the hand value is more than 21, dealer is bust, return false
				if (handValue > 21) {
					return false;
				}
				// if the hand value is between 17-21, returns true, done hitting
				else if (handValue >= 17){
					return true;
				}
				// if the hand value is less than 17 the dealer hits and remains in loop
				else{
					Card c = this.deck.deal();
					this.dealer.add( c);
				}
		}
	}
	
	//this function compares the players hand and the dealers hand. If the return is negative the
	// dealer has won the hand. if the return is positive the player has won the hand.
	public int compareHand(){
		int value = this.player.getValue() -this.dealer.getValue();
		if (value < 0){
			return -1;
		}
		else if (value > 0){
			return 1;
		}
		else {
			return 0;
		}
	}
	
	// This function will simulate one game of blackjack. It will reset the game each time.
	//This function will return 1 if the player wins, 0 if the player and dealer push
	// -1 if the dealer wins
	public int playGame(){
		reset(0);
		//booleans to know whether either goes bust when hitting
		Boolean BooleanPlayer;
		Boolean BooleanDealer;
		
		//Player takes his turns hitting
		BooleanPlayer = playerTurn();
		//check to see if the player went bust
		if(BooleanPlayer == false){
			//player looses			
			return -1;
		}

		// dealer takes his turn hitting
		BooleanDealer = dealerTurn();
		//check to see if the dealer went bust
		if (BooleanDealer == false){
			// player wins
			return 1;
		}
		
		//compare the dealer and players hands to see who won
		int winner = compareHand();
		//Dealer wins
		if ( winner < 0 ){
			return -1;
			}
		//push
		else if ( winner == 0) {
			return 0;
		}
		//player wins
		else{
			return 1;
		}
	}
	
	
	//This function is for playing an interactive game of blackjack with the computer
	// It will set up the game and deal 2 cards to the player and only 1 to the dealer
	// the user will then be prompted for whether he wants to hit or to pass.
	// This function will return 0 if a push, 1 for player wins, -1 for dealer wins
	public int play(){
		Scanner reader = new Scanner(System.in);
		boolean check;
		//reset the blackjack game
		reset(1);
		int i =0;
		print();
		// While playing the game
		while( i==0 ){
			System.out.println(" \n\n Your move. \n\t Press 1 to hit \n\t Press 2 to pass ");
			//read in player chioce
			int choice = Integer.parseInt(reader.nextLine());
			// switch on the choice of the player
			switch(choice){
				//The player hits
				case 1:
					check = hit();
					print();
					// if the player goes bust -- game over
					if (check == false ){
						System.out.println("Player goes bust and looses");
						return -1;
					}
					break;
				// player chose to push, leave loop
				case 2:
					i = 1;
					break;
			}
		}
		// Dealer takes his turn to hit -- automatic
		check = dealerTurn();
		//print current state of the game
		print();
		// if the dealer went bust -- game over
		if ( check == false ){
			System.out.println("Dealer goes bust and player wins!");
			return 1;
		}
		// neither player nor dealer bust -- compare the card totals
		else{
			int winner = compareHand();
			if ( winner < 0 ){
				System.out.println("The Dealer wins. Player looses.");
				return -1;
				}
			else if ( winner == 0) {
				System.out.println("The Dealer and Player push");
				return 0;
			}
			else {
				System.out.println("The Player Wins!!");
				return 1;
			}		
		}
	
	}
	
	
	// This function sets up a simulation of several blackjack games.
	// The input is the number of trials that you want to be simulated
	// The output to the screen is going to be the number of wins,losses, pushes and the percentages of each
	public void sim(int trials){
		// error check
		if (trials < 1){
			System.out.println("Too few trials");
			return;
		}
		int win = 0;
		int loss = 0;
		int push = 0;
		int result;
		// Loop through each simulation and then update the data about wins/losses/pushes
		for(int i=0;i<trials;i++){
			result = playGame();
			if (result == 0){
				push += 1;
			}
			else if (result == -1){
				loss += 1;
			}
			else if (result == 1){
				win += 1;
			}
		}
		//Print out simulation data
		System.out.println("Wins " + win + ", Losses " + loss + ", Pushes " + push);
		
		// stats in percentages
		double winPercent = (((double)win)/((double)trials))*100;
		double lossPercent = (((double)loss)/((double)trials))*100;
		double pushPercent = (((double)push)/((double)trials))*100;	
		//print out percentages to the screen
		System.out.println("The win %: " + winPercent + ", Loss %: " + lossPercent + ", push %: " + pushPercent);
	
	
	}
	
	
	
	// This function will test all the functionality of the Blackjack class
	// including all of the functions and the simulation and interactive parts.
	// Takes no arguments
	static public void main( String[] args ){
		Blackjack blackjack = new Blackjack();
		blackjack.reset(0);
		Boolean BooleanPlayer;
		Boolean BooleanDealer;
		//Simulates the player turn functions
		BooleanPlayer = blackjack.playerTurn();
		if(BooleanPlayer == false){
			System.out.println("The player has gone bust and lost this round!");
		}
		else {
			//simulates the dealer turn functions. checks to see if there is a bust
			BooleanDealer = blackjack.dealerTurn();
			if (BooleanDealer == false){
				System.out.println("The dealer has gone bust and the player wins!");
			}
			//neither player busts, checks the compare hand function and determines who wins
			else{
				//integer returned can tell us about who wins: 1 = player, 0 push, -1 dealer
				int winner = blackjack.compareHand();
				if ( winner < 0 ){
					System.out.println("Dealer wins!");
					}
				else if ( winner == 0) {
					System.out.println("Push");
				}
				else if ( winner > 0 ){
					System.out.println("Player wins!");
				}
			}
		}
		//New game that shows that hit() works
		blackjack.reset(0);
		blackjack.print();
		System.out.println("the player hits");
		blackjack.hit();
		blackjack.print();
		
		
		System.out.println("new game\n\n");
		//This shows that the play function works as expected
		blackjack.reset(1);
		blackjack.play();
		
		//This will simulate 100 games, checks sim functions
		System.out.println("\n\n New game\n\n");
		blackjack.sim(100);
		
		System.out.println("\n\nnew game");
		//This will test the playgame function and show it outputs
		System.out.println("The output of one sim game is" + blackjack.playGame());;
	}

}
