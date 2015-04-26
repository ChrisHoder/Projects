// FILE: Defender.java
// AUTHOR: Chris Hoder
// DATE: 11/22/2011
// PROJECT 09

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.Polygon;
import java.util.ArrayList;

/**
 * This class will create the defender for the Millipede Game. It will be a triangle
 * @author Chris
 *
 */
public class Defender extends SimObject{

	//data declarations
	/**
	 * This boolean is true if the defender is alive, false if it is dead
	 */
	boolean isAlive;
	
	/**
	 * max Speed that the Defender can travel
	 */
	public static double D_SPEED = 1;
	
	/**
	 * Constructor for the Defender. Input position (x,y) where it will be initially
	 * @param x -  x Position
	 * @param y -  y Position
	 */
	public Defender(double x, double y) {
		super(x, y);
		// initially alive
		this.isAlive = true;
		
	}

	@Override
	/**
	 * This method will update the state of the defender. It will check to see if any 
	 * millipede elements are next to it, if they are it is dead (returns false)
	 * @param scape Landscape being played on
	 * @return true if the defender is still alive, false if it is dead
	 */
	public boolean updateState(Landscape scape) {
		// if it is dead, return false immediately
		if(!this.isAlive){
			return false;
		}
		// check to see if there is a millipede within killing distance of it
		ArrayList<SimObjectList> millipedes = scape.getResources();
		// for each millipede segment
		for (int i = 0 ; i < millipedes.size() ; i++){
			// for each segment in each millipede segment
			for ( int j = 0; j < millipedes.get(i).size() ; j++){
				SimObject temp = millipedes.get(i).get(j);
				// check to see if it is within +/- in both the x and y directions, if it is than we have a hit
				if( temp.getX() >= (this.x-1) && temp.getX() <= (this.x+1) &&
						temp.getY() >= (this.y-1) && temp.getY() <= (this.y+1)){
					// set isAlive to dead
					this.isAlive = false;
					return this.isAlive;
				}
			}
		}
		// return the alive status
		return this.isAlive;
	}
	
	
	/**
	 * This method will move the defender a given x, y amount. It will move the
	 *  defender only if there is not an Obstacle in its way or
	 * if it is not against the edge of the landscape. The defender is also only 
	 * allowed to go up 1/5 of the height of the landscape.
	 * <p>
	 * This method will return true if the Defender is still alive. False if it 
	 * ran into a millipede element. Then it has died
	 * @param x - amount to move in the x direction
	 * @param y - amount to move in the y direction
	 * @param scape - Landscape being played on
	 * @return returns true if the Defender is still alive. False otherwise
	 */
	public boolean move(double x, double y, Landscape scape ){
		// check to see if it is moving off the landscape in the x directions
		if( (this.x + x) > scape.getWidth() || (this.x + x) < 0 ){
			// it is on the edge, do nothing
			this.isAlive = true;
			return true;
		}
		// check to see if it is moving off of the landscape in the y direction. It cannot move more than 1/5 of the way up
		else if( (this.y + y) > scape.getHeight() || (this.y + y) < (4.0/5.0)*scape.getHeight() ){
			// it is on the edge in the y direction
			return true;
		}
		
		// check to see if there are any obstacles in the way of the motion of the Defender
		boolean check = checkObs(this.x +x , this.y + y,scape);
		// if this is false then we cannot move, but are still alive
		if(!check){
			// don't move, but return true (still alive)
			this.isAlive = true;
			return true;
		}
		// check to see if the defender is about to hit any of the millipede's
		check = checkMillipede(this.x+x, this.y+y , scape);
		// if it returns false, then the Defender has hit a millipede and died!
		if( !check){
			// user hit a millipede segment! It has died, return false
			this.isAlive = false;
			return false;
		}
		// Otherwise, the path is clear to move and it will do so
		this.x += x;
		this.y += y;
		// still alive
		this.isAlive = true;
		return true;
	}
	
	/**
	 *  This method will check the motion of travel (x,y) are amount moved in each direction 
	 *  to see if there are any Obstacles
	 *  in the way of the motion.
	 *  <p>
	 *  It will return false if there is an obstacle blocking the motion, otherwise true
	 * @param x - amount to move in the x direction
	 * @param y - amount to move in the y direction
	 * @param scape - The landscape the game is being played on
	 * @return true if the Defender is free to move, false otherwise
	 */
	public boolean checkObs(double x, double y, Landscape scape){
		ArrayList<SimObject> obs = (ArrayList<SimObject>)scape.getAgents();
		// for each Obstacle object
		for( int i = 0 ; i < obs.size() ; i++){
			SimObject obstacle = obs.get(i);
			// if the x and y positions are the same (+/- 1 or .5 is because the defender not a point element and it's width
			// and height need to be taken into account)
			if( obstacle.getX() >= (x-1) && obstacle.getX() <= (x+.5) 
					&& obstacle.getY() >= (y-1) && obstacle.getY() <=(y+.5) ){
				// this obstacle is in the way of the motion, return false and stop checking for other obstacles
				return false;
			}
		}
		// no obstacles in the way, the Defender is free to move with respect to the Obstacles
		return true;
	}
	
	/**
	 * This method will check to see if there are any Millipede elements in the path of the Defender
	 * when it tries to move. 
	 * <p>
	 * If the Defender is trying to move into a Millipede it will die.
	 * @param x - amount it wants to move in the x direction
	 * @param y - amount it wants to move in the y direction
	 * @param scape - Landscape the game is being played on
	 * @return true if the Defender is free to move, false otherwise
	 */
	public boolean checkMillipede( double x, double y, Landscape scape){
		ArrayList<SimObjectList> mill = (ArrayList<SimObjectList>)scape.getResources();
		// for each Millipede group
		for( int i = 0 ; i < mill.size() ; i++ ){
			// for each segment in each millipede group
			for ( int j = 0 ; j < mill.get(i).size() ; j++ ){
				SimObject millipedeSegment = mill.get(i).get(j);
				// check to see if there is any next to it. the +/- 1 or 0.5 are because the defender is not a point element
				// and it's width and height need to be taken into account
				if( millipedeSegment.getX() >= (x - 1) && millipedeSegment.getX() <= (x + 0.5)
						&& millipedeSegment.getY() >= (y - 1) && millipedeSegment.getY() <= (y + 0.5) ){
					// the Defender has hit a Millipede element, return false, it has died!
					return false;
				}
			}
		}
		// the path is clear for the defender to move with respect to all Millipede's on the board
		return true;
	}

	@Override
	/**
	 * This method will draw the Defender on the Display, it will be a triangle
	 * <p>
	 * Code for drawing the triangle adapted 
	 * from: http://www.programmersheaven.com/mb/java/247058/247058/draw-a-triangle/
	 * 
	 */
	public void draw(Graphics g, int x, int y, int scale) {
		// draw white triangle		
		g.setColor(Color.WHITE);
		// set up the verticies of the Triangle
		Point p1 = new Point(x,y-1*scale);
		Point p2 = new Point(x-1*scale,y+1*scale);
		Point p3 = new Point(x+1*scale,y+1*scale);
		
		// create an array of the points 
		int[] xPoints = {p1.x, p2.x, p3.x};
		int[] yPoints = {p1.y, p2.y, p3.y};
		// create a polygon triangle
		Polygon triangle = new Polygon(xPoints, yPoints, xPoints.length);
		// fill the polygon triangle
		g.fillPolygon(triangle);
		
		
	}
	
	/**
	 * checks the class, though most require the landscape
	 * @param args - not used
	 */
	public static void main(String[] args){
		Defender d = new Defender(5.0, 5.0);
		System.out.println(d.isAlive);
	}
}
