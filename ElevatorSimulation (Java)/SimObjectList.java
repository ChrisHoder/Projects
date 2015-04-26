// FILE: SimObjectList.java
// AUTHOR: Brian Eastwood
// DATE: 11/14/2011
// PROJECT 08

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * A List implementation that maintains a list of SimObjects.
 * 
 * @author bseastwo
 */
public class SimObjectList
{
	private static Random rand = new Random();
	
	private Node head;
	private Node tail;
	private int count;
	
	/**
	 * Constructs a new empty SimObjectList.
	 */
	public SimObjectList()
	{
		this.head = null;
		this.tail = null;
		this.count = 0;
	}
	
	/**
	 * Clear all the elements from the list.
	 */
	public void clear()
	{
		this.head = null;
		this.tail = null;
		this.count = 0;
	}

	/**
	 * Returns the number of elements in the list.
	 * @return the number of elements in the list
	 */
	public int size()
	{
		return this.count;
	}
		
	/**
	 * Adds a SimObject onto the end of the list.
	 * @param data
	 */
	public void add(SimObject data)
	{
		Node end = new Node(data, null);
		
		if (this.head == null)
			// adding first element
			this.head = end;
		else
			// at least one element already in the list
			this.tail.next = end;
		
		// update tail pointer and count
		this.tail = end;
		this.count++;
	}
		
	/**
	 * Copies the elements in this list to a List implementation.
	 * @return the new list
	 */
	public List toList()
	{
		ArrayList copy = new ArrayList(this.size());
		Node node = this.head;
		while (node != null)
		{
			copy.add(node.data);
			node = node.next;
		}
		
		return copy;
	}
	
	/**
	 * Shuffles the elements in this List in place.
	 */
	public void shuffle()
	{
		// copy elements into a new array-based list
		List copy = this.toList();
		
		// randomly reorder elements in the array
		int idx;
		Object swap;
		for (int i = copy.size() - 1; i > 0; i--)
		{
			idx = rand.nextInt(i + 1);
			swap = copy.get(idx);
			copy.set(idx, copy.get(i));
			copy.set(i, swap);
		}
		
		// copy elements back into linked list
		this.clear();
		for (int i = 0; i < copy.size(); i++)
		{
			this.add((SimObject) copy.get(i));
		}
	}
	
	/**
	 * Calls updateState on all the elements in this list.
	 * @param scape  the landscape where all the agents live
	 */
	public void updateAll(Landscape scape)
	{
		Node curr = this.head;
		Node prev = null;
		boolean alive = true;
		
		while (curr != null)
		{
			// update the agent
			alive = curr.data.updateState(scape);
			
			// remove the agent from the list if it dies
			if (!alive)
			{
				this.count--;
				scape.addInactive(curr.data);
				
				if (curr == head)
				{
					// removing the head from the list
					this.head = head.next;
				}
				else
				{
					// removing any other node
					prev.next = curr.next;
				}
				
				if (curr == tail)
				{
					// removing the tail from the list
					this.tail = prev;
				}
			}
			else
			{
				// advance previous reference if we didn't remove a node
				prev = curr;
			}
			
			// advance node reference
			curr = curr.next;
		}
	}
	
	/**
	 * Creates a string representation of all the elements in this List.
	 */
	public String toString()
	{
		StringBuffer str = new StringBuffer(this.size() + ": [ ");
		Node node = this.head;
		while (node != null)
		{
			str.append(node.data + ", ");
			node = node.next;
		}
		str.append("]");
		
		return str.toString();
	}
	
	/**
	 * An inner Node.
	 */
	private class Node
	{
		private SimObject data;
		private Node next;
		
		public Node(SimObject data, Node next)
		{
			this.data = data;
			this.next = next;
		}
	}
	
	public static void main(String[] args)
	{
		SimObjectList list = new SimObjectList();
		for (int i = 0; i < 10; i++)
		{
//			list.add(new Broccoli(i));
		}
		
		System.out.println(list);
		list.shuffle();
		System.out.println(list);
		
		List listimpl = list.toList();
		System.out.println(listimpl);
		
//		 list.updateAll(null);
//		 System.out.println(list);
		 
		 System.out.println(list.head + ": " + list.head.data);
		 System.out.println(list.tail + ": " + list.tail.data);
	}
}
