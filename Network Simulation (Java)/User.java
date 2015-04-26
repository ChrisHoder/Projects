// FILE: User.java
// AUTHOR: Chris Hoder
// DATE: 10/31/2011
// PROJECT 06

/* This class will hold the data and method for a User which will be used for the NetworkSimulation and extends the SimObject abstract class */

// imports
import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;
import java.util.Random;


public class User extends SimObject {

	// data declarations
	// personal id number, final so it cannot be changed
	private final int id;
	// this holds the next id to be created for the next new User
	private static int NEXT_ID;
	// This holds the list of friends that this particular User has
	private List friends;
	// This is the list of all users on the landscape in sorted order by the id number
	private static List SORTED_USERS;
	
	// this is the id number of the target User for this user
	private int targetID;
	// this holds a reference for the User that the User is after
	private SimObject targetUser;
	
	// this will determine whether the user moves randomly after friending someone
	private static boolean randMove = true;
	
	// Constructor that takes in the position of this user (x,y), it will also initialize all other data fields saved by the user
	public User(double x, double y){
		// set position
		super(x,y);
		// get the id from the NEXT_ID static
		this.id = User.NEXT_ID;
		//update the nextid
		User.NEXT_ID++;
		this.friends = new ArrayList();
		// this is -1 because it hasn't yet chosen which friend to go after
		this.targetID = -1;
		this.targetUser = null;
		
	}
	
	// This method will set the static variable randMove that when true will have the Users move to a random position after
	// friending another user
	public static void setRandMove(boolean rand){
		User.randMove = rand;
	}
	
	// This method will create an array of ints that stores all of the ids that the user has as friends. it will return this array
	// INPUT: nothing
	// OUTPUT: array of integers corresponding to id of friends
	/* PSEUDOCODE
	 *   1. FOR ( each friend ) DO
	 *   	- add this friend id to an integer array
	 *   	END
	 *   2. return array of integers
	 */
	public int[] getFriendIds(){
		int size = this.friends.size();
		int[] intFriends = new int[ size ];
		// for each friend, get the id and add it to the array of integers
		for( int i=0 ; i< size ; i++){
			intFriends[i]  = ((User)this.friends.get(i)).getId();
		}
		return intFriends;
	}
	
	
	// This method will return the number of friends that this user has
	// INPUT: nothing
	// OUTPUT: number of friends (int)
	public int getFriendSize(){
		return friends.size();
	}
	
	
	// This static method will take the input users and sort the list and then set this sorted list to the static
	// data field SORTED_USERS in the User class
	// INPUT: list of users
	// OUTPUT: nothing
	/* PSEUODOCODE
	 * 	1. call quicksort on the list
	 * 	2. save the list to the User.SORTED_USERS data field
	 */
	public static void setAllUsers(List users){
		User.quicksort(users);
		User.SORTED_USERS = users;
	}
	
	
	// This method will return the id of this user
	// INTPUT: nothing
	// OUTPUT: int corresponding to the user's id
	public int getId(){
		return this.id;
	}
	

	// This method will return a string version of the user's id
	// INPTUT: nothing
	// OUTPUT: integer of the user's id
	public String toString(){
		return Integer.toString(this.id);
	
	}
	
	// This method will search the input list for the target id using recursion
	public static User search( List users, int target){
		// this aux method does all the work
		return User.searchAux(users, target, 0, users.size()-1);
	
	}
	
	//  This method will perform a binary search on the input list, looking for the given target. The list is assumed to be sorted from lowest number to highest number
	// it will look in the middle and then if the middle number is bigger than the target it will repeat the process on the lower half, likewise if the middle number is smaller
	// than the target it will repeat the process on the upper half. This method works with time compleity O(log n).
	/* PSEUDOCODE
	 *   1. If ( low inde  > high index) THEN
	 *   	- no target in the list (return null) 
	 *      END
	 *   2. get the middle index
	 *   3. get the middle id value
	 *   4. IF ( the middle id is the target id)  THEN
	 *   		- return this user
	 *  	ELSE if ( the middle id is greater than the target id) THEN
	 *  		- recursively call searchAux with the lower half of the section of the array
	 *  	ELSE IF ( the middle id is less than the target id) THEN
	 *  		- recursively call searchAu with the upper half of the section of the array
	 *  	END
	 */
	private static User searchAux( List users, int target, int low, int high){
		// base case, if we have divided the list as far as possible, in this case the number we are looking for is not in the list
		if( low > high ) {
			return null;
		}
		// middle number
		int mid = (low+high)/2;
		
		// get the middle id number
		int temp = ( (User) users.get(mid)).getId();
		// if the temp is the target, return this user
		if ( temp == target) {
			return ( User ) users.get(mid);
		}
		// if the temp is greater than the target, return the lower half of the list
		else if ( temp > target ){
			return searchAux(users,target, low, mid-1);
		
		}
		// i.e. temp < target , return the upper half of the list
		else{
			return searchAux(users,target, mid+1,high);
		
		}
	}



/* selection sort algorithm (order n^2)

	for ( int i =0 ; i < arr.size() ; i++){
		int lowid = i;
		for( int j = i+1; j< arr.size() ; j++ ){
			if( arr[j] < arr[lowId] ){
				lowId = j;
			}
		}
		swap(arr[i],arr[lowId]);
	
	
	}


*/


// designed based on quicksort wikipedia article, http://en.wikipedia.org/wiki/Quicksort
// this will call the private quicksort algorithms if the list is greater than 0.
// The average time complexity of this case is O(n log n)
	public static void quicksort(List users){
		if ( users.size() != 0 ){
			quicksortPart1(users,0,users.size()-1);
		}
		
	}
	
	
	// This method will perform part of the quicksort alogrithm
	// INPUT: list to sort in place, low index, high index
	// OUTPUT: nothing (sorts the list in place)
	/* PSEUDOCODE
	 *   1. if (there are more than 2 elements in the list) THEN
	 *   		- find a pivot index (middle index)
	 *   		- sort the list so that all elements lower than the pivot index's id is below
	 *   		- recursively sort the elements that are smaller than the pivot index and elements that are larger than the pivot index
	 *      END
	 */
	private static void quicksortPart1(List users, int low, int high){
		// makes sure we havn't divided too far, the list has more than 2 items
		if( low < high ){
			// choose pivot index
			int pivotIndex = (low+high)/2;
			// this will move all of the items below the pivot to below the pivotNewIndex and all the items
			// above the pivot to indexes above the pivotNewIndex
			int pivotNewIndex = quicksortPart2(users,low,high,pivotIndex);
			
			// recursively sorts smaller elements than the pivot, this is on the smaller elements (sort these)
			quicksortPart1(users, low, pivotNewIndex-1);
			
			//recursively sorts the larger elements than the pivot (at least as big) and sort these
			quicksortPart1(users,pivotNewIndex + 1,high);
		}
		
	}

	
	// This method will move all of the id's that are less than the one in the pivot index to the left side of the tempIndex (newPivot Index), likewise all
	// id's that are greater than the one in the pivot index to the right side of the array (indexes above tempIndex)
	/* PSEUDOCODE
	 *  1. get id value of element at the pivot point index
	 *  2. swap the high spot with the user at the pivot point
	 *  3. start at the lowest index (low) as newPivotpoint index
	 *  4. FOR ( each index from low to high) DO
	 *  	- if the id at this index is less than the pivot point
	 *  	- swap it with the element at the newPivotpoint index
	 *  	- increment the newPivotpoint index
	 *      END
	 *  5. swap the element in the last (high) index with the pivot point index
	 *  6. return the newPivotpoint index
	 */
	private static int quicksortPart2(List users, int low, int high, int pivPt){
		// get the id at the pivot point
		int pivotIdValue = ( (User) users.get(pivPt)).getId();
		
		// swap the high spot with the user at pivPt index
		Object o = users.set(high,users.get(pivPt));
		// set the pivPt location to the user that was at the high point
		users.set(pivPt,o);
		
		// stat at the lowest index 
		int tempIndex = low;
		
		// for each index from low to high
		for( int i = low ; i < high ; i++ ){
			// if the id at the ith index is lexx than the pivot value
			if( (( User )users.get(i)).getId() < pivotIdValue ){
				//swap users[i] and users[tempIndex]
				Object o2 = users.set(i,users.get(tempIndex));
				users.set(tempIndex,o2);
				// move the newPivotIndex up
				tempIndex++;
			}
		}
		
		
		//swapping users[tempIndex] and users[high] brings pivot to final place
		Object o3 = users.set(tempIndex,users.get(high));
		users.set(high,o3);
		
		// return the newPivotIndex
		return tempIndex;
	
	}



	// This method will compute the distance this user is from its target User and returns this distance as a double
	// INPUT: nothing
	// OUTPUT: nothing
	/* PSEUDOCODE
	 * 	1. get the x distance between the two users
	 *	2. get the y distance between the two users
	 *	3. find the distance between the two users ( x^2+y^2  = r^2 )
	 *	4. return this distance
	 */
	public double distanceFromTarget(){
		double x = this.targetUser.getX();
		double y = this.targetUser.getY();
		double xDistance = this.x - x;
		double yDistance = this.y - y;
		// r^2 = x^2 + y^2 
		double radius = xDistance*xDistance + yDistance*yDistance;
		return Math.sqrt(radius);
	}
	
	
	// This method will "visit" the targetUser and it will get the list of friends that the targetUser has
	// it will then search down this list looking for a friend that this user is not yet frineds with. If it finds a user it isn't a friend with
	// it will set this friend as its targetUser and then stop searching. if it does not find a user it is not find a user it isn't a friend with it will
	// pick a random friend in its own list to head to.
	// INPUT: User to visit
	// OUTPUT: nothing
	/* PSUEDOCODE
	 * 	1. get the other friends list
	 *  2. FOR ( each id in the other friends list) DO
	 *  		- search this users friend list for the id
	 *  		- IF( this user is not friends with this id) THEN
	 *  			- set it as this users new target ID
	 *  			- exit method
	 *  		  END
	 *  	END
	 *  3. Find a random id from this users own friends list
	 *  4. set this random id as its new targetID
	 */
	public void visit( User other){
		User u = null;
		// int array of the ids of the other user's friends
		int[] newFriends = other.getFriendIds();
		// for each id in this array
		for( int i = 0 ; i< newFriends.length ; i++){
			// if the id is this user, skip it
			if ( newFriends[i] == this.id){
				continue;
			}
			// search this users friends for the friend at the ith index of the array
			u = User.search(this.friends, newFriends[i]);
			// if this id isn't in this user's friend list
			if( u == null){
				// set the ith id as this users new target id/user
				this.targetID = newFriends[i];
				// so that this user's updatestate method will know to find the target user
				this.targetUser = null;
				// exit
				return;
			}
		}
		// finds no new friends, picks a random one from its own list and tries to meet up with that one
		newFriends = this.getFriendIds();
		Random rand = new Random();
		this.targetID = newFriends[rand.nextInt(newFriends.length)];
		this.targetUser = null;
	}
	
	
	
	// this method adds a friend to this users friends list. this will keep a sorted friends list based on id based on a linear search
	// INPUT: user to add as friend
	// OUTPUT: nothing
	/* PSEUDOCODE
	 *  1. FOR ( each element in this users friends list) DO
	 *  	- IF (the id of this friend is greater than the id of the user to add ) THEN
	 *  		- add this friend at this index
	 *  		- exit method
	 *        END
	 *     END
	 */
	public  void addFriend( User user){
		int friendSize = this.friends.size();
		// for each friend in this users frined list
		for (int i = 0 ; i < friendSize ; i++){
			// if the id of the ith friend is greater than the id of the friend to add, we have reached the spot to add in place
			if ( ((User)this.friends.get(i)).getId() > user.getId() ){
				// add the user at this index
				this.friends.add(i, user);
				return;
			}
		}
		// if the friend to add has the largest id, add it at the end
		this.friends.add(user);
		
	
	}


	// this method will update the state of this User, it does this doing one of the following. If it has no target id ( just initialized) it will choose a random id among
	// the total users list and set that as the target user/id. Then if it does not have a targetUser set it will find this user based on the targetId. If the user has a target
	// id and user set, it will determine how far away it is from the target user. if it is more than 1 unit away it will move 1 step closer to the targetUser. If the user is within 1 unit radius
	// from the targetUser it will "visit" the user and add it as a friend. The user in this case will then move to a random position on the map.
	// INPUT: landscape the user is on
	// OUTPUT: always true (never gets removed from landscape)
	/* PSUEDOCODE
	 * 	1. 
	 */
	 public boolean updateState(Landscape scape){
	// if there is no initial target, find one randomly from the users
		 if ( this.targetID < 0 ){
			Random rand = new Random();
			int userSize = User.SORTED_USERS.size();
			// find random index
			int target = rand.nextInt(userSize);
			this.targetID = ((User)User.SORTED_USERS.get(rand.nextInt(userSize))).getId();
			// this while loop will keep picking random integers until it picks a User id that isn't this users id
			while( targetID == this.id ){
				target = rand.nextInt(userSize);
				this.targetID = ((User)User.SORTED_USERS.get(rand.nextInt(userSize))).getId();
			}
			
			// this will find the user with the associated id and set it to this users targetUser
			this.targetUser = User.search(SORTED_USERS, targetID);
			if (targetUser == null){
				// this means there was some error (should not happen)
				this.targetID = -1;
			}
		 }
		 // this means the User has just met a friend and needs to find a 
		 if ( this.targetUser == null){
			 this.targetUser = User.search(SORTED_USERS, targetID);
		 }
		 // this user has a targetUser to head to, needs to find out how close it is to know if it can visit
		 else{
			 // this gets the distance
			 double distance = this.distanceFromTarget();
			 // if we are greater than 1 unit from the target user, we need to move 1 unit closer
			 if( distance > (double) 1){
				 //move closer
				 // compute the direction in x, y (the directional vector)
				 double xDirection = this.targetUser.getX() - this.x;
				 double yDirection = this.targetUser.getY() - this.y;
				 // make it a unit vector and find the size to divide by;
				 double magnitude = Math.sqrt(xDirection*xDirection + yDirection*yDirection);
				 xDirection = xDirection/magnitude;
				 yDirection = yDirection/magnitude;
				 // add the unit vector to move in the direction of the other user
				 this.x = x + xDirection;
				 this.y = y + yDirection;
			 }
			 // this user is within 1 unit from the targetUser and it will add it as a friend and visit it
			 else{
				 //only adds the friend if it hasn't already
				 if( User.search(this.friends, this.targetID) == null ){
					 this.addFriend(( User )this.targetUser);
				 }
				 this.visit( ( User ) this.targetUser);
				 // moves to a random position
				 if( User.randMove == true){
					 this.setRandomPosition(scape);	 
			 
				 }
			 }
		 }
		 // always return true
		 return true;
	 }
	
	 // This mehtod will set the position of this user to a random position
	 // INPUT: landscape user is on
	 // OUPUT: nothing
	 public void setRandomPosition(Landscape scape){
		 double xNew = Math.random()*scape.getWidth();
		 double yNew = Math.random()*scape.getHeight();
		 this.x = xNew;
		 this.y = yNew;
	 }
	 
	 // this method will be used to draw the sim object on the landscape
	 // g specifies the graphics at location x,y in screen coordinates (not landscape coordinates)
	 // where the object should be drawn. 
	 // Note that this method will also change the color of the user dependant on the number of friends it has
	 public  void draw(Graphics g, int x, int y, int scale){
	 	// get number of Friends
		 int numFriends = this.friends.size();
		 if ( numFriends == 0){
			 g.setColor(Color.black);
		 }
		 else if( numFriends == 1){
			 g.setColor(Color.gray);
		 }
		 else if ((numFriends > 1) && ( numFriends <= 5 )){
			 g.setColor(Color.blue);
		 }
		 else if ( (numFriends > 5 ) && ( numFriends <= 10 )){
			 g.setColor(Color.orange);
		 }
		 else if ( (numFriends > 10) && ( numFriends <= 50 )){
			 g.setColor(Color.green);
		 }
		 else {
			 g.setColor(Color.PINK);
		 }
		 g.fillOval(x, y, scale, scale);
		 
		 
		 /*
		// drawlines between it and its friends, only draw every tenth
		 g.setColor(Color.yellow);
		for ( int i = 0 ; i < this.friends.size(); i ++){
			if ((i % 10) == 0 ) {
				// get friends location
				User o = (User)this.friends.get(i);
				double xFriend = o.getX(); 
				double yFriend = o.getY();
				g.drawLine(x, y, (int) xFriend*scale , (int) yFriend*scale);
				
			}
		}
		*/
		
		 
		 // This will draw a line between a user and its friends
		 g.setColor(Color.yellow);
		 
		//draw lines for every 10th user
		if ( ( this.id % 10 ) == 0 ){
			for( int i = 0 ; i < this.friends.size(); i ++ ){
				User o = (User) this.friends.get(i);
				double xFriend = o.getX();
				double yFriend = o.getY();
				g.drawLine(x, y, (int) (xFriend*scale), (int) (yFriend*scale));
			}
		}
		
	 }


	 // this method will test the capabilities of this users's methods including the static ones
	public static void main( String[] args ){
		ArrayList a = new ArrayList();
		// add users to the array
		for ( int i = 0 ; i < 20 ; i++){
			User u = new User(10,10);
			a.add(u);
			System.out.println("element number " + i + " is: " + u.toString());
			}
		// test the search
		System.out.println(" Find the id of 7 is " + User.search(a,7) );		
		System.out.println(" Find the id of 16 is " + User.search(a,16) );
		// randomly arrange the users
		Collections.shuffle(a);
		System.out.println("\n\n Shuffled: ");
		// print out the shuffled list
		for( int i=0; i< a.size(); i++){
			System.out.println( ((User)a.get(i)).toString());
		}
		// test the quicksort method
		User.quicksort(a);
		System.out.println("\n\n Quicksorted ");
		// print out the quicksorted list
		for (int i = 0 ; i< a.size(); i++){
			System.out.println( ((User)a.get(i)).toString());
		
		}
		
		// This tests the capabiliites of the addFriends to maintain a sorted list
		User u = new User(10,10);
		int[] friends2 = u.getFriendIds();
		System.out.println("Initial friends length" + friends2.length);
		System.out.println("Start ID of this user: " + u.getId());
		
		// since we are adding these backwards, the highest ids are added first, if it adds the ids in order, they will
		// appear in order when we print them out later
		for (int i = a.size(); i > 0  ; i--){
			u.addFriend((User)a.get(i-1));
		}
		
		int[] friends = u.getFriendIds();
		System.out.println("friends length " + friends.length);
		// print out all this users friends, testing the addFriend method
		for(int i = 0; i < friends.length ; i++){
			System.out.println(" the user id of this friend is: " + friends[i]);
		}
		
	}
	


}