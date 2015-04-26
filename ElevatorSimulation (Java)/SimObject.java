// FILE: SimObject.java
// AUTHOR: Brian Eastwood
// DATE: 11/16/2011
// PROJECT 08

import java.awt.Graphics;
import java.util.Random;

/**
 * Represents an object in a simulation.  This base class
 * provides features common to all agents and resources.
 * 
 * @author bseastwo
 */
public abstract class SimObject
{
	protected static Random rand = new Random();
	
	protected double x;
	protected double y;

	public SimObject(double x, double y)
	{
		this.x = x;
		this.y = y;
	}

	public double getX()
	{
		return this.x;
	}

	public double getY()
	{
		return this.y;
	}

	public void setPosition(double x, double y)
	{
		this.x = x;
		this.y = y;
	}

	/**
	 * Updates this object's state based on the local neighborhood
	 * of the Landscape.
	 * 
	 * @param scape		the Landscape the agent lives on
	 * @return	true if the object survives updating its state, false
	 * if it does not
	 */
	public abstract boolean updateState(Landscape scape);

	/**
	 * Draws this object on a Graphics object. The point (x, y) specifies
	 * the position of the object in screen coordinates. The scale 
	 * specifies the size of a single unit of land.
	 * 
	 * @param g			the Graphics object to draw to
	 * @param x			the x position in screen coordinates
	 * @param y			the y position in screen coordinates
	 * @param scale		the size in pixels of a single unit of land
	 */
	public abstract void draw(Graphics g, int x, int y, int scale);
}