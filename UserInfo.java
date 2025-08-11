import java.util.Scanner;

public class UserInfo {
	private String name;
	private String userID;

	// Method to get name
	public void getUserName() {
		Scanner scanner = new Scanner(System.in);
		System.out.print("Enter your full name (first name and surname): ");
		name = scanner.nextLine().trim(); //trim() removes spaces in front and end of string only
		generateUserID();
	}

	// Method to generate user ID
	private void generateUserID() {
		if (name.contains(" ")) {
			String[] parts = name.split(" "); //split names by spaces, e.g. "Ah Peng Wong" -> ["Ah","Peng","Wong"]
			userID = parts[0].charAt(0) + parts[parts.length - 1]; //take the first alphabet and the surname
		} 
		else {
			userID = "guest"; //if name no space
		}
	}

	// Getters
	public String getName() {
		return name;
	}

	public String getUserID() {
		return userID;
	}
}
