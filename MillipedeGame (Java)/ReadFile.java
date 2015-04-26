// FILE: ReadFile.java
// AUTHOR: http://www.homeandlearn.co.uk/java/read_a_textfile_in_java.html
//     MODIFIED BY: Chris Hoder
// DATE: 10/2/2011
// PROJECT 03



import java.io.IOException;
import java.io.FileReader;
import java.io.BufferedReader;

/* 
	used for reading files from a text file. Can return a array of strings with each
	element a line in the text file
*/
public class ReadFile{


	// Data declarations
	private String path;
	
	public ReadFile(String file_path){
		path = file_path;
	
	}
	
	
	//This function will count the number of lines in the file by opening the file in path
	// and counting the number of lines that can be read before reaching the end.
	int readLines() throws IOException {
		FileReader file_to_read = new FileReader(path);
		BufferedReader bf = new BufferedReader( file_to_read );
		
		int numberOfLines = 0;
		
		// While there is another line to be read, increment the counter
		while(( bf.readLine()) != null){
			numberOfLines ++;
		}
		// close connection
		bf.close();
		// return the number of lines in the file to be read
		return numberOfLines;
	
	}

	
	// This function will open the file designated by path.
	// it will read each line into a string and store these strings
	// in a string array.
	// INPUT: nothing
	// OUTPUT: array of Strings. each string corresponds to a line in the file
	public String[] openFile() throws IOException {
		FileReader fr = new FileReader(path);
		BufferedReader textReader = new BufferedReader(fr);
		
		int numberOfLines = readLines();
		String[] textData = new String[numberOfLines];
		
		// For each line in the file, read it into the array of strings
		for (int i=0; i<numberOfLines ; i++){
			textData[i] = textReader.readLine();
			// This would read a single characer : textReader.read();
		}
		
		// close connection
		textReader.close();
		// return the array of strings
		return textData;
			
	}
	
	
	
	
	// This function will test the capabilities of this class by loading The Blinker2.txt file
	// Note that this does look different than the blinker2.txt will be loaded when 
	// loaded as part of the LifeSimulation, this is because there are more lines and columns
	// than read in to the the LifeSimulation grid.
	public static void main( String[] args ) throws IOException{
		ReadFile rf = new ReadFile("./highscore.txt");
		String[] Text = rf.openFile();
		// print out each line
		for(int i=0; i<Text.length; i++){
			System.out.println(Text[i]);
		
		}
	
	}
	
	}