/*
 * Author: Chris Hoder
 * Date: 9/19/11
 * Project 1
 * File: Deck.java
 */

import java.util.ArrayList;
import java.util.Random;


//This function has all of the functions necessary to have a deck. It functions as an ArrayList
public class Deck {

	// data declarations
	private ArrayList deck;
	//private ArrayList deck2;

	// This function creates a deck of 52 cards, 4 each of cards with values 1-9 and 16 cards with
	// value 10.
	public Deck(){
		this.deck = new ArrayList(52);
		build();
	}
	
	
	// This function rebuilds a deck of 52 cards, 4 each of cards with value 1-9 and 16 cards with
	// value 10.
	public void build(){
		this.deck.clear();
		Card c;
		//populate the deck with 4 of cards 1-9
		for( int i=1; i < 10; i++){
			for( int j=0 ; j<4; j++){
				c = new Card(i);
				this.deck.add(c);
			}
		}
		//populate deck with an additional 16 cards of value 10
		for( int i=0; i<16; i++){
			c = new Card(10);
			this.deck.add(c);
		}
	}
	
	//returns the top card (position 0) and removes it from the deck.
	public Card deal(){
		Card c = (Card)this.deck.get(0);
		this.deck.remove(0);
		return c;
	}
	
	
	// returns the card at position i and removes it from the deck.
	public Card pick( int i ){
		Card c = (Card)this.deck.get(i);
		this.deck.remove(i);
		return c;
	}
	
	// This function  shuffles the deck. This method should put hte deck in a random order.
	public void shuffle(){
		Random rand = new Random();
		Card c;
		int index;
		//create a new deck to put all the new values into
		ArrayList deck2 = new ArrayList();
		int i;
		//This loop will create a random number between 0-(num cards in deck) and then
		// remove the card at that index and add it to the new shuffled deck
		for(  i = 52; i > 0; i--){
			//get random index
			index = rand.nextInt(i);
			//picks the card from the deck and removes it from old deck
			c = pick(index);
			//add this to the new deck
			deck2.add(c);
		}
	//assign the shuffled deck to the old deck variable
		this.deck = deck2;
	}
	
	
	//prints out the deck in some reasonable way so that you can see the ordering of the card values
	public void print(){
		System.out.println("The cards in the deck are:");
		//for each card get the value and print it
		for( int i=0; i<52 ;i++){
			Card c = (Card)this.deck.get(i);
			if (i == 0){
				System.out.print( c.getValue());
			}
			else {
				System.out.print( ", " + c.getValue());
			}
		}
		//print a return at the end
		System.out.print("\n");
	}
	
	// This function will print the size of the decks
	public int size(){
		return deck.size();
	}
	
	// This function will test all of the capabilities that the class has
	public static void main( String[] args){
		Deck d = new Deck();
		//first it will print the deck before shuffling with the size
		// then it will shuffle and then print out the suffled deck
		d.print();
		System.out.println("The deck size is:" + d.size());
		System.out.print("\n");
		
		d.shuffle();
	
		System.out.println("The deck size is:" + d.size());
		d.print();
		
		// This will show that the deal function works
		Card c = d.deal();
		System.out.println("The dealer deals" + c.getValue());
		
		//This will show that the build function will rebuild the deck (printed out and delt again)
		d.build();
		d.print();
		c = d.deal();
		System.out.println("The dealer deals" + c.getValue());
	}





}