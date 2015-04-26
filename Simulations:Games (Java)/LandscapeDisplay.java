// FILE: LandScapeDisplay.java
// Supplied by Brian Eastwood
// Modified by Chris Hoder
// DATE: 10/2/11
// PROJECT 03

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

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
				(int) this.scape.getCols() * this.scale,
				(int) this.scape.getRows() * this.scale);
		
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
		 * @param g		the Graphics object used for drawing
		 */
		public void paintComponent(Graphics g)
		{
			super.paintComponent(g);
			
			//colors!
			Color[] colors = {
					//Black RGB
					new Color(0, 0, 0),
					//medium Blue RGB
					new Color(0, 0, 205),
					// Yellow RGB
					new Color(255,255,0),
					//Green RGB
					new Color(0,100,0),
					//Orange
					new Color(255,165,0),
					//RED
					new Color(255,0,0)
					
					};
			
			
			
			// Type will depends on Color
			//g.setColor(colors[agent.getType() % colors.length ]);
			
			// draw all the live cells as circles on the landscape
			for (int row = 0; row < scape.getRows(); row++)
			{
				for (int col = 0; col < scape.getCols(); col++)
				{
					SimObject sO = scape.getAgent(row,col);
					if (sO != null)
					{
						g.setColor(colors[((SocialAgent)sO).getType() % colors.length ]);
						g.fillOval(col * scale, row * scale, scale - 1, scale - 1);
					}
				}
			}
		}
	}
	
	public static void main(String[] args) throws IOException
	{
		Landscape L = new Landscape(20,80);
		LandscapeDisplay LP = new LandscapeDisplay(L, 8);
		LP.repaint();
		
	}
}
