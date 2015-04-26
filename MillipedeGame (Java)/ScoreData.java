import java.util.PriorityQueue;

/**
 * This class will create a class that holds the user name and the score achieved in it.
 * It implements Comparable so that it can be compared based on scores in a PriorityQueue
 * <p>
 * modified with help from: http://onjava.com/onjava/2003/03/12/java_comp.html
 * @author chris
 *
 */
public class ScoreData implements Comparable<ScoreData> {

	// data declarations
	/**
	 * Username of the user
	 */
	private String name;
	/**
	 *Score achieved
	 */
	private int score;
	
	/**
	 * constructor of a new instance of the class with the given user name
	 * and score
	 * @param name - user name 
	 * @param score - score achieved
	 */
	public ScoreData(String name, int score) {
		this.name = name;
		this.score = score;
	}
	
	/**
	 * Compare function that compares based on the score of
	 * the user
	 * @param sd - another ScoreData instance
	 * @return positive values if sd's score is greater than
	 * this instances' score
	 */
	public int compareTo(ScoreData sd){
		int oScore = sd.getScore();
		return  oScore - this.score;
	}
	
	/**
	 * This method returns the score in the instance
	 * @return - score achieved
	 */
	public int getScore(){
		return this.score;
	}
	
	/**
	 * This method returns the name associated
	 * with this score
	 * @return - name
	 */
	public String getName(){
		return this.name;
	}
	
	/**
	 * Tests this class
	 * @param args - not used
	 */
	public static void main(String[] args){
		PriorityQueue<ScoreData> pq = new PriorityQueue<ScoreData>();
		
		for(int i = 0 ; i < 10 ; i++){
			pq.add(new ScoreData("chris",i));
		}
		System.out.println(pq.peek().getScore() + "  " + pq.peek().getName());
	}

}
