// FILE: SimObject.java
// AUTHOR: Chris Hoder
// DATE: 10/2/11
// PROJECT 03


/*
	abstract class that will be inherited by socialAgents
*/

public abstract class SimObject {
	
	// data declarations
	protected int row;
	protected int col;
	public static double changeProb = 0.05;
	
	public SimObject(int row, int col){
		this.row = row;
		this.col = col;
	}
	
	
	
	// methods
	
	// Will return the Row of the given SimObject
	public int getRow(){
		return this.row;
	}
	
	// this method will get the changeProbab double
	public double getChangeProb(){
		return this.changeProb;
	}
	
	// this method will set the changeProb double
	public void setChangeProb(double prob){
		this.changeProb = prob;
	}
	
	
	// Will return the column of the given SimObject
	public int getCol(){
		return this.col;
	}

	// Will set the position of the given SimObject
	public void setPosition(int row, int col){
		this.row = row;
		this.col = col;
	}

	// this is a method that all classes that inherit this class will have to have
	public abstract boolean updateState(Landscape scape);

}