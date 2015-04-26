// FILE: Graph.java
// AUTHOR: Chris Hoder
// DATE: 12/09/2011
// PROJECT 10

//imports
import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;

/**
 * This class will hold the graph that will be made up of nodes, which are Vertex Objects. This graph
 * will have Vertices connected to each other which are edges that go off in the NORTH, SOUTH, EAST
 * WEST directions. 
 * @author chris
 *
 */

public class Graph {

	//data declarations
	/**
	 * this will hold a list of all vertices in the graph
	 */
	List<Vertex> vertices;
	
	/**
	 * Constructor that initializes a new graph.
	 */
	public Graph(){
		this.vertices = new ArrayList<Vertex>();
		
	}
	
	/**
	 * This clears the graph
	 */
	public void clear(){
		this.vertices.clear();
	}
	
	/**
	 * This method adds a new Vertex to the graph.
	 * @param v - Vertex to add to the graph
	 */
	public void addVertex(Vertex v){
		this.vertices.add(v);
	}
	
	/**
	 * This method will get Vertices that are positioned close to the input
	 * Vertex v. This will return a list of Vertices that will be the Vertices whose
	 * positions are either directly vertical +/- 1 unit or directly horizontal +/- 1 unit. 
	 * The list will not include diagonal neighbors. This method will include wrap arounds if the 
	 * Vertex v sits on one of the edges of the Landscape.
	 * @param v - Vertex with which you want to find the neighbors
	 * @param scape - Landscape we are playing on
	 * @return a List of Vertices which are neighbors with v (not including diagonal neighbors).
	 */
	public List<Vertex> getClose(Vertex v, Landscape scape){
		// creata  new list
		ArrayList<Vertex> nhbs = new ArrayList<Vertex>();
		
		//x, y position of v
		double  x = v.getX();
		double  y = v.getY();
		
		// For each vertex in the graph (we need to check them all here)
		for( Vertex w : this.vertices){
			// if the vertix w is v, ignore this case)
			if( w.getX() == x && w.getY() == y){
				continue;
			}
			
			//If they both sit on the same column
			else if ( w.getX() == x){
				// if it is +/- 1 unit from v
				if ( w.getY() == (y+1) || w.getY() == (y-1)){
					nhbs.add(w);
				}
				// if v sits on the top and w is the element on the bottom , add it as a neighbor
				else if ( y == 0 && w.getY() == (scape.getHeight()-1) ){
					nhbs.add(w);
				}
				// if v sits on the bottom and w is the element at the top of the landscape
				// add it
				else if ( y == (scape.getHeight() -1 ) && w.getY() == 0 ){
					nhbs.add(w);
				}
			}
			// if they both sit on the same row.
			else if ( w.getY() == y){
				// if w is +/- 1 unit from v
				if( w.getX() == (x+1) || w.getX() == (x-1)){
					nhbs.add(w);
				}
				// if v sits at the left edge of the landscape and w sits on the right edge, they are
				// neighbors by the wrap around, add it
				else if ( x == 0 && w.getX() == (scape.getWidth() -1)){
					nhbs.add(w);
				}
				// if v sits on the right edge of the landscape and w sits on the left edge, they
				// are neighbors and add it to the list
				else if ( x == (scape.getWidth() -1 ) && w.getX() == 0){
					nhbs.add(w);
				}
			}
		}
		//return the list of neighbors
		return (List<Vertex>)nhbs;	
	}
	
	
	/**
	 * This returns a list of the Vertices in the graph
	 * @return list of all the vertices in the graph
	 */
	public List<Vertex> getVertices(){
		return this.vertices;
	}
	
	/**
	 * This returns the number of Vertices in the graph
	 * @return number of vertices in the graph
	 */
	public int vertexCount(){
		return this.vertices.size();
	}
	
	/**
	 * This method adds v1 and v2 to the graph ( if necessary ) and
	 * adds edges connecting v1 to v2 via direction dir and connecting v2 to
	 * v1 via the opposite direction
	 * @param v1 - Vertex to make a connection to v2 in the direction dir
	 * @param dir - direction to make the connection from v1 to v2
	 * @param v2 - Vertex to make a connection with to v1 in the opposite direction of dir
	 */
	public void addEdge(Vertex v1, Vertex.Direction dir, Vertex v2){
		// if there was no value for any of the inputs, we have a problem, just return and exit
		// out of this method
		if( dir == null || v1 == null || v2 == null){return;}
		
		// check to see if either v1 or v2 is in the graph
		if ( this.vertices.contains(v1) == false ){
			this.vertices.add(v1);
		}
		
		if( this.vertices.contains(v2) == false){
			this.vertices.add(v2);
		}
		
		// connect the 2 vertices
		v1.connect(v2, dir);
		v2.connect(v1,dir.opposite());
	}
	
	
	/**
	 * This method will get the vertex at the index i
	 * in the list of Vertices, since this is a graph
	 * the index i is going to be used to get a random Vertex from 
	 * the list (i.e. for placement of the Hunter and Wumpus in the game).
	 * <p>
	 * If the method of storing the list of vertices is changed from a List to 
	 * another data structure this method would have to be changed
	 * @param i - index of the Vertex to get
	 * @return Vertex at the ith index
	 */
	public Vertex getVertex(int i){
		return this.vertices.get(i);
	}
	
	/**
	 * This method will set all of the Vertices to not draw themselves
	 * <p>
	 * This will set all of the marked data fields to false
	 */
	public void setInvisible(){
		// for every vertex set the data field marked to false
		for( Vertex v : this.vertices){
			v.setMarked(false);
		}
	}
	
	/**
	 * this method will set all of the vertices to draw themselves
	 * <p>
	 * This will set all of the marked data fields to true
	 */
	public void setVisible(){
		for( Vertex v : this.vertices){
			v.setMarked(true);
		}
	}
	
	/**
	 * This method adds v1 and v2 to the graph (if necessary) and adds edges connecting
	 * v1 to v2 via direction dir and v2 to v1 via direction d2. Note that d1 and d2 need not be
	 * opposites.
	 * @param v1 - Vertex to add an edge that connects it to v2 in the direction dir
	 * @param dir - direction with which to connect v1 to v2
	 * @param v2 - Vertex to add an edge to that connects it to v1 in the direction dir2
	 * @param dir2 - Direction with which to connect v2 to v1
	 */
	public void addEdge(Vertex v1, Vertex.Direction dir, Vertex v2, Vertex.Direction dir2){
		
		// check to see if either v1 or v2 is in the graph
		if ( this.vertices.contains(v1) == false ){
			this.vertices.add(v1);
		}
		
		if( this.vertices.contains(v2) == false){
			this.vertices.add(v2);
		}
		
		// connect them
		v1.connect(v2, dir);
		v2.connect(v1, dir2);
	}
	
	
	/**
	 * This method will check to see whether the graph is connected. I.e. can every Vertex be reached
	 * from every other vertex. It does this by computing the shortestPath algorithm for the first Vertex
	 * in the list of vertices. It will then check to see if any of the costs are still at the max value.
	 * if they are still at the max value, then it cannot reach the vertex, meaning our graph isn't connected.
	 * @return - true if the graph is connected, false otherwise.
	 */
	public boolean isConnected(){
		// there are no Vertices in this graph, then it is still connected
		if( this.vertices.size() == 0 ){ return true;}
		// check with the first vertex in the list
		Vertex v0 = this.vertices.get(0);
		// compute the shortest path algorithm
		shortestPath(v0);
		for( Vertex w : this.vertices){
			// if it isn't connected it's cost will still be the max value
			if( w.getType() == 0 && w.getCost() == Integer.MAX_VALUE ) {
				return false;
			}
		}
		// the graph is connected
		return true;
		
	}
	

	
	/**
	 * This method implements a single-source shortest-path algorithm for the Graph. This method finds
	 * the cost of the shortest path between v0 and every other connected vertex in the graph, counting
	 *  edge as having a unit cost except for vertices with type not equal to 0 are not counted as being
	 *  a place the hunter can stop so they will effectively have an edge weight of 0. This method is modelled off
	 *  of the Dijkstra's algorithm. 
	 *
	 * @param v0 - Vertex with which to calculate the shortest path length between v0 and every other Vertex it is 
	 * connected to.
	 */
	public void shortestPath(Vertex v0){
		// set cost to the max for all vertices in the graph, as well as
		// initialize the marked data field to false
		for( Vertex w : this.vertices){
			w.setCost(Integer.MAX_VALUE);
			w.setMarked(false);
		}
		
		// create a priority queue
		PriorityQueue<Vertex> shortPath = new PriorityQueue<Vertex>();
		// the cost of the vertex v0 is 0
		v0.setCost(0);
		// add it to the Priority Queue
		shortPath.add(v0);
		
		Vertex v;
		//While we have not visited every node
		while( shortPath.size() != 0 ){
			// get the next element from the priority queue
			v = shortPath.poll();
			// set it as marked( we have been here before)
			v.setMarked(true);
			
			
			// we need to go through this by explicitly knowing the key for each edge
			// because we will need to know from which direction we came from inorder
			// to know where to move if the edge is a Vertex of type 1,2,3,or 4 and not type 0. (i.e.
			// when we are in a tunnel and not a cave opening).
			// 
			// Notice that instead of calling w.getNeighbor(Direction) we are calling
			// w.findActualNeighbor, this will skip over all of the Vertices that are of type != 0
			// and return the Vertex of type 0 that this vertex is connected to. This effectively sets
			// the edge weights of these connections to 0.
			for ( int i = 0 ; i < 4 ; i++){ 
				Vertex w = null;
				// check the NORTH edge
				if( i == 0){
					w = findActualNeighbor(Vertex.Direction.NORTH, v);
				}
				// check the EAST edge
				else if( i == 1){
					w = findActualNeighbor(Vertex.Direction.EAST, v);
				}
				// check the WEST edge
				else if( i == 2){
					w = findActualNeighbor(Vertex.Direction.WEST, v);
				}
				// check the SOUTH edge
				else if( i == 3){
					w = findActualNeighbor(Vertex.Direction.SOUTH, v);
				}
				// if there are no edges, continue 
				if( w == null){
					continue;
				}
				
				// if we have not already visited this vertex, and we are getting to it from a shortest
				// path
				if( w.getMarked() == false && 
						( v.getCost() +1 ) < w.getCost() ) {
					// update the path cost
					w.setCost(v.getCost() + 1);
					
					//first remove w then add it again to take into account that it may already be in the priority queue
					shortPath.remove(w);
					shortPath.add(w);
				}
					
				
			}
		}
		
		
	}
	
	/**
	 * This method will find the neighbor of Vertex v in the direction dir. What is being considered a neighbor here
	 * is a Vertex that is of type 0. if the edge of v in the Direction dir is a Vertex of type that is not
	 * 0 we will keep moving in the appropriate directions (based on the type of the vertex) until we reach a
	 * Vertex that is of type 0 (via recursive calls). This Vertex will be returned.
	 * @param dir - Direction of the edge for Vertex v that we want to find the neighbor of
	 * @param v - Vertex we are finding the neighbor of
	 * @return - Vertex of type 0 that neighbors v in the direction dir. Null if there is no neighbor
	 */
	public Vertex findActualNeighbor(Vertex.Direction dir, Vertex v){
		Vertex w = v.getNeighbor(dir);
		
		// If there is no edge in that direction, return now with null
		if( w == null){
			return null;
		}
		// if the type of the neighbor in this direction is 0, we are good
		// return this vertex (i.e. base base of the recursion
		if( w.getType() == 0){
			return w;
		}
		// we are in a Vertex of type != 0 , we need to recursively call ourselves and go to the 
		// neighbor in the appropriate direction, until we reach a Vertex of type 0
		else{
			// find out the type of Vertex we are in
			int type =  w.getType();
			// this finds the direction we need to travel in (based on the type)
			Vertex.Direction dir2 = findDir(type, dir);
			// this is the recursive call to go to the next Vertex
			return w = findActualNeighbor(dir2, w);
		}
		
	}
	
	/**
	 * This method finds the direction that we need to move in, based on the type of 
	 * Vertex that we are in and the Direction dir that we entered into a Vertex from.
	 * @param type - The type of the vertex you are in
	 * @param dir - Direction from which you entered into the Vertex
	 * @return Direction to head out of the Vertex
	 */
	public Vertex.Direction findDir(int type, Vertex.Direction dir){
		Vertex.Direction returnDir = null;
		// remember that dir is the direction you took to enter the
		// Vertex so it means you came from the opposite direction
		// if we are in a type 1 Vertex
		if( type == 1){
			// entered from the south - go west
			if( dir == Vertex.Direction.NORTH){
				returnDir = Vertex.Direction.WEST;
			}
			// entered from the north -- go east
			else if ( dir == Vertex.Direction.SOUTH){
				returnDir = Vertex.Direction.EAST;
			}
			// entered from the west -- go south
			else if ( dir == Vertex.Direction.EAST){
				returnDir = Vertex.Direction.SOUTH;
			}
			// entered from teh east -- go north
			else if ( dir == Vertex.Direction.WEST){
				returnDir = Vertex.Direction.NORTH;
			}
		}
		// type 2 vertex
		else if( type ==2 ){
			// entered from teh south go east
			if( dir == Vertex.Direction.NORTH){
				returnDir = Vertex.Direction.EAST;
			}
			// entered from the north -- go west
			else if ( dir == Vertex.Direction.SOUTH){
				returnDir = Vertex.Direction.WEST;
			}
			// entered from the west -- go north
			else if ( dir == Vertex.Direction.EAST){
				returnDir = Vertex.Direction.NORTH;
			}
			// entered from the east-- go south
			else if ( dir == Vertex.Direction.WEST){
				returnDir = Vertex.Direction.SOUTH;
			}
		}
		// type 3 vertex
		else if ( type == 3){
			// entered from the south, go north
			if( dir == Vertex.Direction.NORTH){
				returnDir = Vertex.Direction.NORTH;
			}
			// entered from the north -- go south
			else if ( dir == Vertex.Direction.SOUTH){
				returnDir = Vertex.Direction.SOUTH;
			}
		}
		// type 4 vertex
		else if ( type == 4 ) {
			// entered from the west -- go east
			if ( dir == Vertex.Direction.EAST ){
				returnDir = Vertex.Direction.EAST;
			}
			// entered from the east go west
			else if ( dir == Vertex.Direction.WEST){
				returnDir = Vertex.Direction.WEST;
			}
		}
		
		// return the direction that you should travel in to continue along the correct path
		return returnDir;
	}
	
	
}
