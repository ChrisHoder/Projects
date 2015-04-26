/*
 * Author: Chris Hoder
 * Date: 9/19/11
 * Project 1
 * File: Hand.java
 */

import java.util.ArrayList;

// This class will work to hold all the information for a blackjack hand
public class Hand {

	// declarations
	private ArrayList hand;
	
	// creates a hand - - constructor
	public Hand(){
		this.hand = new ArrayList();
	
	}
	
	//This will reset the hand to empty. i.e. has no cards
	public void reset(){
		this.hand.clear();
		
		
	}
	
	// This function adds a card (input) to the hand
	public void add( Card card){
		this.hand.add(card);
	}
	
	
	//this function returns the number of cards in the hand
	public int size(){
		return hand.size();
	
	}
	
	//this function returns the Card with given index i.
	public Card getCard(int i){
		return (Card)hand.get(i);
	}
	
	//This function returns the sum of the values of the cards in the Hand
	// as an integer
	public int getValue(){
		int value = 0;
		// for each card add it to the total
		for(int i=0;i< hand.size();i++){
			Card c = (Card)hand.get(i);
			int value2 = c.getValue();
			value = value + value2;
		}
		return value;
	}
	
	// This function will test all the capabilities of the class
	public static void main( String[] args){
		//creates a new hand and card and then adds the card to the hand twice
		Hand h = new Hand();
		Card c = new Card();
		h.add(c);
		h.add(c);
		
		//print out the value
		System.out.println("value " + h.getValue());
		//now will get the card of index 1 and get the value
		System.out.println("value " + h.getCard(1).getValue());
	}
}