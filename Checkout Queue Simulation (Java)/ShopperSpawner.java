// FILE: ShopperSpawner.java
// AUTHOR: Chris Hoder
// DATE: 10/23/2011
// Project 05

import java.awt.Graphics;
import java.util.Random;


/* this class will spawn new shoppers in the store. it will create SHOPPERS_CREATED more 
 * shoppers with each adance.
 */


public class ShopperSpawner extends SimObject {

	
	//data declarations
	// number of shoppers created per iteration
	private static int SHOPPERS_CREATED = 1;
	
	
	public ShopperSpawner(int x, int y){
		super(x,y);
	}
	
	// This method will set the number of shoppers created with each advance call
	// INPUT: shoppers to be created with each updateState call
	public static void setShoppersCreated(int shoppers){
		ShopperSpawner.SHOPPERS_CREATED = shoppers;
	}
	
	// this method will return the number of shoppers to be created with each updateState call
	// INPUT: nothing
	// OUTPUT: SHOPPERS_CREATED static variable
	public static int getShoppersCreated(){
		return ShopperSpawner.SHOPPERS_CREATED;
	}
		
	// This method will create SHOPPERS_CREATED number of new shoppers in the store, they will have
	// a random position in the top 1/4 of the landscape and have a random amount of items to be
	// scanned between 1 and ITEMS_MAX. 
	public  boolean updateState(Landscape scape){
		double x,y;
		int items;
		Random rand = new Random();
		// for each new shopper
		for (int i = 0 ; i < ShopperSpawner.SHOPPERS_CREATED ; i++){
			// position in the x, anywhere
			x = Math.random()*scape.getWidth();
			// position in the y is only the top quarter
			y = Math.random()*scape.getHeight()/4;
			// number of items the shopper has is between 1 and ITEMS_MAX
			items = rand.nextInt(Shopper.ITEMS_MAX)+1;
			// create a new shopper and add them
			Shopper s = new Shopper(x,y,items);
			scape.addAgent(s);
		}
		// this method will always return true 
		return true;
	}
	
	
	// this will not appear on the landscape, therefore its draw method is empty
	public void draw(Graphics g, int x, int y, int scale){
		return;
	}
	
	// This method will test the capabilities of the shopper Spawner class ( i.e. the 2 static methods)
	public static void main( String[] args){
		ShopperSpawner spawner = new ShopperSpawner(10,11);
		System.out.println(" Shoppers spawned " + ShopperSpawner.getShoppersCreated());
		ShopperSpawner.setShoppersCreated(15);
		System.out.println(" Shoppers spawned " + ShopperSpawner.getShoppersCreated());
	}
}