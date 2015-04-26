// FILE: Castle.java
// AUTHOR: Chris Hoder
// DATE: 11/06/2011
// PROJECT 7

/* This class holds the data for the castle in the BattleSimulation */

// imports
import java.awt.Color;
import java.awt.Graphics;


public class Castle extends SimObject {
	
	//data declarations
	
	// max health of the Castle
	public static double MAX_HEALTH = 100;
	// amount the castle will rebuild itself with each iteration
	public static final double REBUILD = 0.1;
	// the current health of the castle
	private double health;
	
	
	// Constructor that takes the position of the castle
	public Castle(double x, double y){
		super(x,y);
		// initially the castle is at max health
		this.health = Castle.MAX_HEALTH;
		
	}
	
	
	// This method will return the current health of the castle
	// INPUT: nothing
	// OUTPUT: double health
	public double getHealth(){
		return this.health;
	}
	
	
	// This static method will set the maximum health of the Castle
	// INPUT: new max Health (double)
	// OUTPUT: nothing
	public static void setMaxHealth( double newMax){
		Castle.MAX_HEALTH = newMax;
	}
	
	
	// This method will decrement the current health of the Castle by the given amount (double) 
	// it will check to make sure that the health doesn't go below 0 (that would not make sense)
	// INPUT: damage amount
	// OUTPUT: nothing
	public void attack(double amount){
		// if the damage is not more than the health, decrement the health by damage
		if( (this.health - amount) > 0 ){
			this.health = this.health - amount;
		}
		// otherwise set the health to 0
		else{
			this.health = 0;
		}
	}
	
	
	// This method will update the State of the Castle. First it will check to see if the castle is still alive. If it is not, this will return false
	// otherwise it will rebuild the castle by the given REBUILD data field and return true
	 public  boolean updateState(Landscape scape){
		 // check to see if the castle still has health left, if not return false (dead)
		 if( this.health <= 0 ){
			 return false;
		 }
		 // otherwise check to see if the castle needs to rebuild itself a bit ( if it's health is not the MAX_HEALTH )
		 else if( ( this.health + Castle.REBUILD ) < Castle.MAX_HEALTH){
			 this.health += Castle.REBUILD;
		 }
		 else{
			 this.health = Castle.MAX_HEALTH;
		 }
		 
		 // this method will always return true  unless it is dead
		 return true; 
	 }

	 //  This method will draw the castle on the display. The castle is a long gray rectangle
	 //  across the landscape. The transparency of the castle depends on the health of hte castle
	 //  compared to the MAX_HEALTH that the castle could have. Additionally the Castle will draw
	 //  in a health bar in the upper right (beyond the edge of the landscape) to show us the current health
	 //  the health will be written in this red bar as a double rounded to 5 digits
	 public void draw(Graphics g, int x, int y, int scale){
		 // find out how transparent the color will be
		 double saturate = ( this.health / Castle.MAX_HEALTH )* (double)255;
		 saturate = saturate < 25 ? (double)25 : saturate;
		 // set the new color based on the saturate which will determine it's alpha value (transparency)
		 g.setColor(new Color(139 , 137 , 137 , (int)saturate));
		 int boardHeight = Landscape.getHeight();
		 int boardWidth = Landscape.getWidth();
		 g.fillRect(x, y, scale*4, scale*boardHeight);
		 
		// this draws the health bar, a nonfilled red rectangle that will always be
		 // the full length of the health (that way we can tell how low it is)
		 g.setColor(Color.RED);
		 g.drawRect((int)(boardWidth+1)*scale, 3*scale,20*scale , scale*2);
		 double healthWidth = this.health/Castle.MAX_HEALTH;
		 g.fillRect((int)(boardWidth+1)*scale, 3*scale, (int)(healthWidth*20*scale), scale*2);
		 // this draws the Castle Health string above the health bar
		 String str = "Castle Health";
		 char[] strChr  = str.toCharArray();
		 g.drawChars(strChr,0,strChr.length,(int)(boardWidth+1)*scale,2*scale);
		 
		 // this draws the health in the health bar
		 g.setColor(Color.BLACK);
		 str = String.format("%.5g%n", this.health);
		 strChr = str.toCharArray();
		 g.drawChars(strChr, 0, strChr.length,(int)(boardWidth+1)*scale, 5*scale);
		 
		 
		 
	}
	
}
