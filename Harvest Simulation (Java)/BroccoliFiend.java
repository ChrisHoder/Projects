// FILE: BroccoliFiend.java
// AUTHOR: Chris Hoder
// DATE: 10/16/2011
// PROJECT 04

// imports
import java.util.ArrayList;
import java.awt.Graphics;
import java.awt.Color;
 
/* this class stores all the information and methods for the broccoli fiends in the harvest
 * simulation
 */


public class BroccoliFiend extends SimObject {
	
	
	
	// data declarations
	//broccoli is the stored amount of broccoli that the fiend has
	private double broccoli;
	
	//constructor, saves locaiton and stored food
	public BroccoliFiend(double x, double y, double broccoli){
		super(x,y);
		this.broccoli = broccoli;
	}
	
	// adds food to the fiends stores
	public void addBroccoli(double amount){
		this.broccoli += amount;
	}
	
	// returns the broccoli the fiend has
	public double returnBroccoli(){
		return this.broccoli;
	}
	
	// eats the daily amount of 8 broccoli. If the fiend does not have 8 broccoli to eat
	// it will die and the method returns false
	public boolean eat(){
		// if there is more than 8 broccoli stored
		if(this.broccoli >= 8){
			this.broccoli = this.broccoli-8;
			return true;
		}
		// not more than 8 broccoli
		else{
			this.broccoli = 0;
			return false;
		}
	}
	
	
	// This method will copy the BroccoliFiend and return the copy 
	public SimObject copyObject(){
		BroccoliFiend temp = new BroccoliFiend(this.x,this.y,this.broccoli);
		return temp;
	}
	
	
	// This method will update the state of the broccoli fiend on the given landscape
	// by first getting the resources near and finding the plant with the most broccoli
	// within a 3 unit radius. the fiend will then move to this plant and harvest. Also if there
	// are 2 or 3 fiends near this fiend it will reproduce a new broccoli fiend and supply it with enough food to eat for 1 day
	// this food will be subtracted from its own food stores.
	// INPUT: Landscape
	// OUTPUT:  returns true if the fiends is still alive. false if it dies
	/* PSEUDOCODE
	 * 	1. eat
	 * 	2. if (not enough food to eat) 
	 * 		return false
	 *     END
	 *  3. Find resource neighbors
	 *  4. Find the resource in the neighbors that has the most broccoli
	 *  5. move to this position and harvest up to 10 broccoli
	 *  6. get list of BroccoliFiends within 1 unit
	 *  7. IF( there are either 2 or 3 fiends near by) THEN
	 *  	- create a new Broccoli fiend and supply it with 8 food
	 *     END
	 *  8. If this fiend does not have any food left in its store, its dead -- return false
	 *  9. return true
	 */
	public boolean updateState(Landscape scape){
		// if it has enough to eat
		if(this.eat() ==  false){
			return false;
		}
		
		// plants within a 3 unit radius
		ArrayList nhbs = ( ArrayList )scape.getResourcesNear(this.x,this.y,3);
		Broccoli b = null, temp;
		// if there are no plants near this fiend
		if( nhbs.size() == 0){
			return true;
		}
		// for all the plants in the area
		for(int i=0 ; i< nhbs.size(); i++){
			// if this is the first element, store it in the temp b
			if(b == null){
				b =(Broccoli) nhbs.get(i);
			}
			// if this plant has more broccoli than the temp b plant has, assign the temp b to it
			else{
				temp  = (Broccoli) nhbs.get(i);
				if(b.getBroccoli() < temp.getBroccoli() ){
					b = temp;
				}
			}
		} // end for loop
		
		// move to the location of b (the resource with most broccoli)
		this.setPosition(b.getX(),b.getY());
		this.broccoli += b.harvest(10);
		
		// This part deals with the BroccoliFiend interacting with its nhbs to reproduce
		// the rules for reproduction are the same as in the Game of Life, except they need to be
		// within 1 unit away to reproduce (pretty close)
		ArrayList nhbAgents = ( ArrayList )scape.getAgentsNear(this.x,this.y,1);
		// if there are 2 or 3 neighbors they will reproduce
		if( (nhbAgents.size() == 2) || (nhbAgents.size() == 3) ){
			// it will use up some of its own resources to reproduce and give it to the
			// child
			scape.addAgent(new BroccoliFiend(this.x,this.y,8));
			this.broccoli = this.broccoli - 8;
			// it can die in reproduction -- does not have the resources to keep alive
			if(this.broccoli < 0){
				return false;
			}
		}
		
		
		// it is still alive -- returns true
		return true;
	}
	
	// This method is used for the fiend to draw itself on the landscape. The brightness of the fiend is dependant on 
	// how much foot it has stored in it.
	public void draw(Graphics g, int x, int y, int scale){
	    float saturate = (float) (this.broccoli / 20);
	    // if thre is more than 20 broccoli stored in it it will be fully bright
	    saturate = saturate >= 1 ? 0.9f : saturate;
	    saturate = saturate < 0.1 ? 0.1f : saturate;
	    g.setColor(new Color(Color.HSBtoRGB(saturate ,0.3f, 0.3f)));
	    g.fillOval(x, y, scale, scale);
	}
	
	// this tests the capabilities of the class
	public static void main(String[] args){
		BroccoliFiend bf = new BroccoliFiend(10,10,10);
		System.out.println(bf.returnBroccoli());
		System.out.println(bf.eat());
		System.out.println(bf.returnBroccoli());
		bf.addBroccoli(200);
		System.out.println(bf.returnBroccoli());	
	}
	
	
}