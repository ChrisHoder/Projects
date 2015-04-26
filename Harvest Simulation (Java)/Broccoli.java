// FILE: Broccoli.java
// AUTHOR: Chris Hoder
// DATE: 10/16/2011
// PROJECT 04

/* 
 * this class is what creates the resources for the landscape, it extends the SimObject class
 */


import java.awt.Graphics;
import java.awt.Color;

public class Broccoli extends SimObject {
	
	// data declarations
	public static double MAX_QUANTITY = 64;
	
	private static int day = 0;
	private double quantity;
	
	// constructor
	public Broccoli(double x, double y, double quantity){
		super(x,y);
		this.quantity = quantity;
	}
	
	// this method returns the quantity of broccoli left in this plant
	public double getBroccoli(){
		return this.quantity;
		
	}
	
	// this method will return a copy of the Broccoli object
	public SimObject copyObject(){
		Broccoli temp = new Broccoli(this.x,this.y,this.quantity);
		return temp;
	}
	
	// This method will harvest up to amount units of broccoli, if there are more than
	// amount units of broccoli on this broccoli plant, the quantity will be decreased
	// by the quantity amount. If there are fewer than the amount unites of broccoli
	// it will decrease the amount to zero. with will return the broccolli units harvested
	public double harvest(double amount){
		double harvested;
		// if there is less broccoli than desired, return the amount left, and set
		// the plant's quantity to 0
		if (this.quantity < amount){
			harvested =  this.quantity;
			this.quantity = 0;
		}
		// otherwise harvest the amount desired, and decrement it from the plant stores
		else{
			harvested = amount;
			this.quantity = quantity - harvested;
		}
		//return the amount harvested
		return harvested;
	}

	
	// This method will grow the plant, if the plant has the MAX_QUANTITY already, it will 
	// not grow anymore. otherwise it will grow by the designated amount
	// INPUT: amount to grow
	// OUTPUT: nothing
	private void grow(double amount){
		if ( this.quantity >= this.MAX_QUANTITY ){
			return;
		}
		else if( (this.quantity + amount) >= this.MAX_QUANTITY ){
			this.quantity = this.MAX_QUANTITY;
		}
		else{
			this.quantity += amount;
		}
	}
	
	// This function will let the broccoli grow with each iteration, if the broccoli's quantity
	// is less than the MAX_QUANTITY
	// The amount tha tit grows by is dependant on its location and the season. There are 4 seasons simulated
	// it starts with all of the plants in a location where x<y grow way faster than those above. Then in the "sring and fall"
	// the plants in the middle grow faster than the outliers but all grow rather slow. Then in the next season the plants in a location where
	// x> y grow way faster than those not.
	public boolean updateState(Landscape scape){
		// get the day of the year
		int day = scape.getDay();
		// for the first 1/4 of the year
		if( day< 91){
			// if the plant is in a location with x< y it grows fast
			if( this.x < this.y ){
				grow(1);
			}
			//grow slow
			else{
				grow(.1);
			}
		}
		// "spring and fall (middle days of the year)"
		else if( ((day >= 91) && (day < 182)) || ((day >= 273) && (day < 366)) ) {
			//plants below the middle block diagonal will grow slow, likewise for plants above.
			// plants along the diagonal will grow fast
			if( this.y < ( this.x - scape.getHeight()/2 )){
				grow(.5);
			}
			else if( ( this.y > (this.x - scape.getHeight())) && ( this.y < this.x + scape.getHeight()/2)  ){
				grow(.75);
			}
			else{
				grow(.5);
			}
		}
		// for the "winter or summer " season the top diagonal will grow faster than the bottom
		else if ( (day >= 182) && (day < 273)){
			if( this.x < this.y){
				grow(.1);
			}
			else{
				grow(1);
			}
		}
		
		// unimportant for this particular Class extension of SimObject
		return true;
	}

	
	// this method will allow it to draw itself on the LandscapeDisplay. The shade of the
	// plant will be indicative of how "healthy" it is or how much broccoli it has stored
	public void draw(Graphics g, int x, int y, int scale){
		float saturate = (float) (this.quantity / (Broccoli.MAX_QUANTITY+1));
		saturate = (saturate < 0.1)? 0.1f : saturate;
		g.setColor(new Color(Color.HSBtoRGB(0.3f, saturate, 0.8f)));
		g.fillRect(x, y, scale, scale);
	}

	// this method tests the methods in the broccoli class with the exception of updateState and draw which 
	// require other classes
	public static void main( String[] args){
		Broccoli b = new Broccoli(10,20, 14);
		System.out.println(b.getBroccoli());
		System.out.println(b.harvest(10));
		System.out.println(b.getBroccoli());
	}
	
}