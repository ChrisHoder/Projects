// FILE: Vertex.java
// AUTHOR: Chris Hoder
// DATE: 12/09/2011
// PROJECT 10

//imports
import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;

/**
 * This class holds the information for each Vertex in the graph for the WumpusHunt game. These Vertexes can be one of 5 types.
 * <p>
 * Type 0 : this Vertex is an "opening" in the cave system and is a place that the Hunter and/or Wumpus can sit
 * <p>
 * Type 1: North and East neighbors are connected via a path. As well as West and South neighbors
 * <p>
 * Type 2: North and West neighbors are connected via a path. As well as East and South neighbors
 * <p>
 * Type 3: North and South neighbors connected via a path only
 * <p>
 * Type 4: East and West neighbors connected via a path only
 * @author chris
 *
 */

public class Vertex extends SimObject implements Comparable<Vertex>{

	
	/**
	 * Enum that holds the Directions, this will be used for keys
	 * for each vertex's map of edges. The Directions are NORTH, SOUTH,EAST,WEST.
	 * There is also an opposite method to get the Direction directionally opposite
	 * @author chris
	 *
	 */
	public static enum Direction {
		NORTH , SOUTH, EAST, WEST;
		
		/**
		 * This method returns the Direction directionally opposite from the direction
		 * calling it. I.e. North returns South ; East returns West
		 * @return Returns the opposite direction
		 */
		public Direction opposite(){
			if( this == Direction.NORTH ){
				return Direction.SOUTH;
			}
			else if ( this == Direction.SOUTH){
				return Direction.NORTH;
			}
			else if( this == Direction.EAST){
				return Direction.WEST;
			}
			else{
				return Direction.EAST;
			}
			
		}
	
	
	};
	
	/**
	 * This holds a map of the paths this vertex holds between different neighbors. The key is a Vertex.Direction enum and the value is
	 * a vertex that is connected to this vertex in the given Vertex.direction
	 */
	private Map<Direction, Vertex> map;
	/**
	 * this field will hold the number of cave opnenings between this Vertex and the Wumpus. This field is irrelevant for Verticies of non zero type.
	 */
	private int cost;
	/**
	 * This boolean holds whether or not the Vertex should draw itself on the landscape display. True means that it will be drawn. Additionally it is used
	 * in the computation of the cost for each Vertex.
	 */
	private boolean marked;
	/**
	 * This is a string label for each vertex. This will be unique for every Vertex created for the graph
	 */
	private final String label;
	/**
	 * This static holds the number of Vertex's created and will be used to create the unique string label for each initialized Vertex
	 */
	private static int totalNum = 0;
	/**
	 * This holds the type of the Vertex
	 */
	private int type;
	
	/**
	 * This constructor creates a new Vertex object at the given (x,y) position. All verticies are initially type 0 and
	 * cave a cost of the max value and the marked is false.
	 * @param x - x coordinate in the landscape
	 * @param y - y coordinate in the landscape
	 */
	public Vertex(double x, double y) {
		super(x, y);
		this.map = new HashMap<Direction,Vertex>();
		// cost is initialy the max value it can be ( effectively infinity)
		this.cost = Integer.MAX_VALUE;
		// it has not been visited / calculated for the shortest path algorithm
		this.marked = false;
		// all Vertices are initial type 0.
		this.type = 0;
		
		// create a unique label, will assign a letter a-z (if there are more
		// than 26 elements it will double up letters)
		this.label = this.creatUniqueLabel();
	}
	
	/**
	 * This private method will create the unique string for the newly initialized Vertex. 
	 * This is based off of the totalNum static variable. The label will assign the Vertex
	 * to a character between a-z and then after every multiple of 26 Vertexes are created
	 * it will expand the label to include another character of the same letter.
	 * <p>
	 * For example: the first vertex is 'a' and the 27the Vertex is 'aa' and so on. 
	 * <p>
	 * This labeling can be bad for large cave systems as it does not take full advantage of the
	 * number of labels it can assign with each character
	 * @return Unique label for the Vertex
	 */
	private String creatUniqueLabel(){
			// this is the number of multiples of 26 there are already initialized
			int repeats = Vertex.totalNum/26 + 1;
			//letter we are in
			int letter = Vertex.totalNum % 26;
			String str = "";
			// for each multiple number of 26 we need to add another letter to our Vertex label
			for(int i = 0 ; i < repeats ; i++){
				// compute unicode number
				str += (char)(letter+65);
			}
			
			// increment the number of Vertex's
			Vertex.totalNum ++;
			
			// return this unique string
			return str;
	}
	
	/**
	 * This method will set the type of this Vertex
	 * @param type - type to set the Vertex to
	 */
	public void setType(int type){
		this.type = type;
	}
	
	/**
	 * This method will return the type of this Vertex
	 * @return - type of this vertex
	 */
	public int getType(){
		return this.type;
	}
	
	/**
	 * This returns the label that is associated with the given Vertex
	 * @return - unique label of the Vertex
	 */
	public String getLabel(){
		return this.label;
	}

	@Override
	/**
	 * This method updates the state of the Vertex, this does nothing because the Vertex is never deleted
	 * @return This will always return true, it is never deleted from the landscape
	 */
	public boolean updateState(Landscape scape) {
		return true;
	}

	/**
	 * This method will draw Vertex on the landscape. It will only draw the Vertex if the marked 
	 * data field is set to true. It will also draw differently for each of the different types of 
	 * Vertexes ( based on the type data field)
	 */
	public void draw(Graphics g, int x, int y, int scale)
	{
		//This is a reused boolean to tell if the Vertex has been visited by the Hunter
	    if (this.marked)
	    {
	    	
	    	int border = 2;
		    int half = scale / 2;
	    	// Type 0 is the normal cave openings
		    if( this.type == 0){
		       
		        
	
		        if (this.cost <= 2){
		            // wumpus is nearby
		            g.setColor(Color.red);   
		        }
		        else{
		            // wumpus is not nearby
		            g.setColor(Color.black);
		        }
		        
		        // draw rectangle for the walls of the cave
		        g.drawRect(x + border, y + border, scale - 2*border, scale - 2 * border);
		        
		        // draw doorways as boxes, based on whether there is a connection
		        g.setColor(Color.black);
		        if (this.getNeighbor(Direction.NORTH) != null)
		            g.fillRect(x + half - 4, y, 8, 12);
		        if (this.getNeighbor(Direction.SOUTH) != null)
		            g.fillRect(x + half - 4, y + scale - 12, 8, 12);
		        if (this.getNeighbor(Direction.WEST) != null)
		            g.fillRect(x, y + half - 4, 12, 8);
		        if (this.getNeighbor(Direction.EAST) != null)
		            g.fillRect(x + scale - 12, y + half - 4, 12, 8);
		        
		        // draw label
		        g.drawString(this.label, x + half - 4, y + half + 4);
		     
		       
		      
		     
		       
	    	}
		    // This is if the type is not == 0
	    	else{
	    		   // just a path from n/s
		        if(this.type == 4){
		        	g.fillRect(x,y+half-4,scale,8);
		        }
		        // just a path east / west
		        else if ( this.type == 3){
		        	g.fillRect(x+half-4, y, 8, scale);
		        }
		        // This is a connection between north/west and east/south
		        else if ( this.type == 2){
		        	// north/west connection exists, draw it
		        	if ( this.getNeighbor(Vertex.Direction.NORTH) != null){
		        		g.fillRect(x, y+half-4, scale/2+1, 8);
		 		        g.fillRect(x+half-4,y, 8, scale/2+1);
		        	}
		        	// east/south connection exists, draw it
		        	if( this.getNeighbor(Vertex.Direction.SOUTH) != null){
		        		g.setColor(Color.BLUE);
		        		g.fillRect(x+half,y+half-4, scale/2+1,8);
		 		        g.fillRect(x+half-4, y+half, 8, scale/2+1);
		 		        g.setColor(Color.BLACK);
		        	}
		        }
		        // this is a connection between norht/east ; south/west
		        else if ( this.type == 1){
		        	// north/east connection exists, draw it
		        	if( this.getNeighbor(Vertex.Direction.NORTH) != null ){
		        		g.fillRect(x+half-4, y, 8, scale/2+1);
		        		g.fillRect(x+half,y+half-4, scale/2+1,8);
		        	}
		        	
		        	// south/west connection exists, draw it
		        	if( this.getNeighbor(Vertex.Direction.SOUTH) != null){
		        		g.setColor(Color.BLUE);
		        		g.fillRect(x, y+half-4, scale/2+1, 8);
				        g.fillRect(x+half-4, y+half, 8, scale/2+1);
				        g.setColor(Color.BLACK);
		        		
		        	}
		        }
	    	}
	        
	    }
	}

	/**
	 * this resets the TotalNum static data field to 0.
	 */
	public static void resetTotalNum(){
		Vertex.totalNum = 0;
	}
	
	/**
	 * This method connects this Vertex to the other Vertex in the given direction. 
	 * This mehtod will ensure that we do not have 2 Vertices connected in the same Direction.
	 * @param other - Vertex to be connected to this one in the given Direction dir
	 * @param dir - Direction the edge is in
	 */
	public void connect(Vertex other, Direction dir){
		// this is a safety check to make sure that we only have 2 elements pointing in this direction
		this.map.remove(dir);
		// create the edge
		this.map.put(dir, other);
	}
	
	/**
	 * This method will return the Vertex that has an edge with this Vertex in the
	 * given direction dir. 
	 * @param dir - Direction the edge is in from this Vertex 
	 * @return - Vertex attached to this Vertex by the given edge direction. If there is no
	 * vertex, this method will return null.
	 */
	public Vertex getNeighbor(Direction dir){
		return this.map.get(dir);
		
	}
	
	/**
	 * This method will return a collection of the Vertices connected to this vertex
	 * @return - Collection of Vertices that are connected to this vertex
	 */
	public Collection<Vertex> getNeighbors(){
		return this.map.values();		
	}
	
	/**
	 * This returns the cost data field
	 * @return - Cost data field
	 */
	public int getCost(){
		return this.cost;
	}
	
	/**
	 * This method will set the cost data field
	 * @param c - integer value to set the cost data field to
	 */
	public void setCost(int c){
		this.cost = c;
	}
	
	/**
	 * This method returns the value of the boolean data field marked
	 * @return - boolean, corresponding to the data field marked
	 */
	public boolean getMarked(){
		return this.marked;
	}
	
	/**
	 * This sets the marked data field based on the input
	 * @param b - boolean to set the data field marked to
	 */
	public void setMarked(Boolean b){
		this.marked = b;
	}
	
	/**
	 * This method will get the direction that a Vertex is connected to 
	 * if it is connected to this Vertex by an edge.
	 * @param v - Vertex to find the direction of connection
	 * @return - Direction that the edge to the given vertex is in, null if the given
	 * Vertex is not connected to this Vertex
	 */
	public Vertex.Direction getDirection(Vertex v){
		// will check all of the 4 possible directions individually to be the
		// given vertex. it will return the right direction if it is present
		// otherwise returns null
		
		if( this.getNeighbor(Vertex.Direction.EAST) == v){
			return Vertex.Direction.EAST;
		}
		else if( this.getNeighbor(Vertex.Direction.WEST) == v){
			return Vertex.Direction.WEST;
		}
		else if ( this.getNeighbor(Vertex.Direction.NORTH) == v){
			return Vertex.Direction.NORTH;
		}
		else if ( this.getNeighbor(Vertex.Direction.SOUTH) == v){
			return Vertex.Direction.SOUTH;
		}
		// we need to track it back
		else{
			return null;
		}
	}
	
	/**
	 * This returns a string representation of the Vertex. Namely the label, number of neighbors, size, cost, and whether it is marked
	 * <p>
	 * An example:
	 * <p>
	 * (Label: A Number of Neighbors: 1 ; The cost: 10 ; Marked: false )
	 * @return String representation of the Vertex with important infromation
	 */
	public String toString(){
		String str = "(Label: " + this.label + " ; 	 Number of Neighbors: " + this.map.size() + " ; The cost: " +
				       this.cost + " ; Marked: " + this.marked + " )";
		return str;
	}

	
	/**
	 * This method is a comparatorClass that implements the Comparator interface. This can be used to compare
	 * 2 different vertexes based on their cost.
	 * @return v1's cost - v2's cost
	 */
	public static class CostComparator implements Comparator<Vertex> {

		@Override
		public int compare(Vertex v1, Vertex v2) {
			return(v1.cost - v2.cost);
		}
	
	}
	
	/**
	 * Tests the capabilities of the Vertex class
	 * @param args - not used
	 */
	public static void main(String[] args){
		System.out.println("Opposite of NORTH is " + Direction.NORTH.opposite());
		System.out.println("Opposite of SOUTH is " + Direction.SOUTH.opposite());
		System.out.println("Opposite of EAST is " + Direction.EAST.opposite());
		System.out.println("Opposite of WEST is " + Direction.WEST.opposite());
		Vertex v1 = new Vertex(10,10);
		v1.setCost(10);
		Vertex v2 = new Vertex(20,20);
		v2.setCost(0);
		CostComparator c = new CostComparator();
		System.out.println("Compare Vertex v1 and v2 and get the following " + c.compare(v1,v2) );
		System.out.println("String for v1 \n" + v1.toString());
		// connect v1 and v2
		v1.connect(v2, Direction.SOUTH);
		System.out.println("connected v1 and v2 \n" + v1.toString());
		//get v2 using the map
		Vertex temp = v1.getNeighbor(Direction.SOUTH);
		System.out.println("get v2 from v1's map and test versus v2 : " + temp.toString());
		
		
		System.out.println((char)(67));
		// connect several together
		
		// reset the total num.
		Vertex.resetTotalNum();
		// tests the labels
		ArrayList<Vertex> a = new ArrayList<Vertex>();
		for( int i = 0 ; i < 100 ; i++ ){
			a.add(new Vertex(0,0));
			System.out.println(a.get(i).getLabel());
		}
		
	}

	@Override
	/**
	 * This method compares 2 vertices based on their cost.
	 * @return this Vertex's cost - v's cost
	 */
	public int compareTo(Vertex v) {
		return  this.cost - v.cost;
	}
}
