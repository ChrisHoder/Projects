// FILE: LandscapeDisplay.java
// AUTHOR: provided, modified by Chris Hoder
// DATE: 10/30/2011
// PROJECT 06

// Mostly reused from previous projects

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.imageio.ImageIO;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;

/**
 * Displays a Landscape graphically using Swing.  The Landscape
 * can be displayed at any scale factor.
 * @author bseastwo
 */
public class LandscapeDisplay extends JFrame
{
	protected Landscape scape;
	private LandscapePanel canvas;
	private int scale;
	
	/**
	 * Initializes a display window for a Landscape.
	 * @param scape	the Landscape to display
	 * @param scale	controls the relative size of the display
	 */
	public LandscapeDisplay(Landscape scape, int scale)
	{
		// setup the window
		super("Landscape Display");
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		

		this.scape = scape;
		this.scale = scale;

		// create a panel in which to display the Landscape
		this.canvas = new LandscapePanel(
				(int) (Landscape.getWidth() + 25) * this.scale,
				(int) Landscape.getHeight() * this.scale);
		
		// add the panel to the window, layout, and display
		this.add(this.canvas, BorderLayout.CENTER);
		this.pack();
		this.setVisible(true);
	}
	
	/**
	 * Saves an image of the display contents to a file.  The supplied
	 * filename should have an extension supported by javax.imageio, e.g.
	 * "png" or "jpg".
	 *
	 * @param filename	the name of the file to save
	 */
	public void saveImage(String filename)
	{
		// get the file extension from the filename
		String ext = filename.substring(
				filename.lastIndexOf('.') + 1, filename.length());
		
		// create an image buffer to save this component
		Component tosave = this.getRootPane();
		BufferedImage image = new BufferedImage(
				tosave.getWidth(), 
				tosave.getHeight(), 
				BufferedImage.TYPE_INT_RGB);
		
		// paint the component to the image buffer
		Graphics g = image.createGraphics();
		tosave.paint(g);
		g.dispose();
		
		// save the image
		try
		{
			ImageIO.write(image, ext, new File(filename));
		}
		catch (IOException ioe)
		{
			System.out.println(ioe.getMessage());
		}
	}
	
	/**
	 * This inner class provides the panel on which Landscape elements
	 * are drawn.
	 */
	private class LandscapePanel extends JPanel
	{
		/**
		 * Creates the panel.
		 * @param width		the width of the panel in pixels
		 * @param height		the height of the panel in pixels
		 */
		public LandscapePanel(int width, int height)
		{
			super();
			this.setPreferredSize(new Dimension(width, height));
			this.setBackground(Color.white);
		}
		
		/**
		 * Method overridden from JComponent that is responsible for
		 * drawing components on the screen.  The supplied Graphics
		 * object is used to draw.
		 * 
		 * @param g		the Graphics object used for drawing
		 */
		public void paintComponent(Graphics g)
		{
			super.paintComponent(g);
			// MODIFIED CODE
			// if we have a one queue line simulation then draw it.
			// draw all the resources
			SimObject agent;			
			
			//draw the castle
			agent = scape.getCastle();
			if(agent != null){
				agent.draw(g, (int) (agent.getX() * scale), (int) (agent.getY() * scale), scale);
			}
				
			// draw all the agents
			List<SimObject> agents = scape.getAgents();	
			for (int i = 0; i < agents.size(); i++)
			{
				agent = (SimObject) agents.get(i);
				agent.draw(g, (int) (agent.getX() * scale), (int) (agent.getY() * scale), scale);
			}
			
			//draw all of the resources
			List<SimObject> resources = scape.getResources();
			for( int i = 0; i < resources.size() ; i ++){
				agent = resources.get(i);
				agent.draw(g, (int) (agent.getX() * scale), (int) (agent.getY() * scale), scale);
			}
			
			
			//draw in the bullets
			List<SimObject> bullets = scape.getBullets();
			for ( int i = 0; i < bullets.size(); i++){
				agent = bullets.get(i);
				agent.draw(g, (int) (agent.getX() * scale), (int) (agent.getY() * scale), scale);
			}
			
			scape.draw(g, scale);
			
		}
	}
	
	public static void main(String[] args)
	{
		
	}
}
