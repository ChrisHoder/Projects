// FILE: SimObject.java
// AUTHOR: Chris Hoder
// DATE: 10/23/11
// PROJECT 05

//imports
import java.awt.Graphics;

/*
 abstract class that will be inherited by socialAgents
*/

public abstract class SimObject {
 
 // data declarations
 protected double x;
 protected double y;
 
 
 // constructor, will set the x,y position
 public SimObject(double x, double y){
	 this.x = x;
	 this.y = y;
 }
 
 
 
 // methods
 
 // Will return the Row of the given SimObject
 public double getX(){
	 return this.x;
 }
 
 
 // Will return the column of the given SimObject
 public double getY(){
	 return this.y;
 }

 // Will set the position of the given SimObject
 public void setPosition(double x, double y){
	 this.x = x;
	 this.y = y;
 }
 

 // this is a method that all classes that inherit this class will have to have
 public abstract boolean updateState(Landscape scape);

 // this method will be used to draw the sim object on the landscape
 // g specifies the graphics at location x,y in screen coordinates (not landscape coordinates)
 // where the object should be drawn. 
 public abstract void draw(Graphics g, int x, int y, int scale);
}