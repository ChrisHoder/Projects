/*
 * Author: Chris Hoder
 * Date: 9/19/11
 * Project 1
 * File: Card.java
 */

import java.util.Random;


// This class is used to store the value of a card in the blackjack game.
public class Card {



	//data declarations
	
	// card value
	private int value;
	

	/*
		A constructor, no inputs. This assigns a random number to the card
	*/
	public Card() {
		//initialize the value to a random value
		Random rand = new Random();
		this.value = rand.nextInt(10)+1;
	}
	
	/* 
		A constructor that sets the face value of the card, does range checking
	*/
	public Card(int v){
		if ( v > 10 || v < 1 ) {
			System.out.println("Value out of range! \n Value set to 0 \n");
			this.value = 0;
		}
		
		else {
			this.value = v;
		}
	}
	
	/* this function returns the numeric value of the card */
	public int getValue(){
		return this.value;
	}
	
	// This function will check the capabilities of the card class and make sure that they all work
	// namely will create a card object, and populate it with a random number and then print the value
	// it will then populate it with a 5 card and print that value
	public static void main( String[] args){
		Card c = new Card();
		System.out.println("the value of the card is " + c.getValue());	
		Card c2 = new Card(5);
		System.out.println("the card has been set to value 5 and its value is " + c2.getValue());
	}


}