import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.Scanner;

public class StockManagement {

	// get maximum number of products
	public static int getMaxProducts(Scanner scanner) {
		while (true) {
			try {
				System.out.print("\nEnter the maximum number of products to add: ");
				int num = scanner.nextInt();
				scanner.nextLine(); // clear buffer

				if (num > 0) {
					return num;
				}
				System.out.println("\nInvalid input! Please enter a non-negative number.\n");
			}

			catch (InputMismatchException e) {
				System.out.println("\nInvalid input! Please enter a valid integer number.\n");
				scanner.nextLine(); // clear the invalid input
			}
		}
	}

	// display menu
	public static int displayMenu(Scanner scanner) {
		while (true) {
			try {
				System.out.print("\n-------------------- Menu --------------------\n\n");
				System.out.println("1. View products");
				System.out.println("2. Add stock");
				System.out.println("3. Deduct stock");
				System.out.println("4. Discontinue product");
				System.out.println("0. Exit");
				System.out.print("Please enter a menu option: ");
				int choice = scanner.nextInt();
				scanner.nextLine(); // clear buffer

				if (choice >= 0 && choice <= 4) {
					return choice;
				}
				System.out.println("Invalid input! Please enter a number between 0 and 4.\n");
			}

			catch (InputMismatchException e) {
				System.out.println("Invalid input! Please enter a number between 0 and 4.\n");
				scanner.nextLine(); // clear the invalid input
			}
		}
	}

	public static void executeMenu(int menuChoice, ArrayList<Product> products, Scanner scanner) {

		switch (menuChoice) {
		case 1:
			viewProducts(products, scanner);
			break;
		case 2:
			addStock(products, scanner);
			break;
		case 3:
			deductStock(products, scanner);
			break;
		case 4:
			discontinueProduct(products, scanner);
			break;
		case 0:
			System.out.println("Exiting...\n");
			break;
		default:
			System.out.println("Invalid choice! Please enter choices from 0 to 4.\n");
		}
	}

	// view products
	public static void viewProducts(ArrayList<Product> products, Scanner scanner) {

		System.out.print("\n---------------- View Products ----------------\n\n");

		if (products.isEmpty()) {
			System.out.println("No products available.");
			return;
		}

		int index = displayProducts(scanner, products);
		
		System.out.println(products.get(index).toString());
	}

	// display products (index + name)
	public static int displayProducts(Scanner scanner, ArrayList<Product> products) {
		System.out.print("List of products: \n");

		for (int i = 0; i < products.size(); i++) {
			System.out.println((i + 1) + ". " + products.get(i).getName() + "\n");
		}

		while (true) {
			try {
				System.out.print("Please select a product: ");
				int choice = scanner.nextInt() - 1;
				scanner.nextLine(); // clear buffer
				System.out.println();

				if (choice >= 0 && choice < products.size())
					return choice;
				else {
					System.out.print("Invalid input! Please select a number listed above.\n");
				}
			}

			catch (InputMismatchException e) {
				System.out.print("Invalid input! Please input a number\n");
				scanner.nextLine(); // clear the invalid input
			}
		}
	}

	// add stock
	public static void addStock(ArrayList<Product> products, Scanner scanner) {

		System.out.print("\n----------------- Add Stock -----------------\n\n");

		if (products.isEmpty()) {
			System.out.println("No products available.");
			return;
		}

		int num = displayProducts(scanner, products);

		while (true) {
			try {
				System.out.print("Enter quantity to add: ");
				int quantity = scanner.nextInt();
				scanner.nextLine(); // clear buffer

				if (quantity > 0) {
					int updatedQuantity = products.get(num).getQuantityAvailable() + quantity;
					products.get(num).setQuantityAvailable(updatedQuantity);
					break;
				} else {
					System.out.print("\nInvalid option. Please enter value higher than zero.\n");
				}
			}

			catch (InputMismatchException e) {
				System.out.print("\nInvalid input! Please enter a valid integer number.\n");
				scanner.nextLine(); // clear the invalid input
			}
		}
	}

	// deduct stock
	public static void deductStock(ArrayList<Product> products, Scanner scanner) {

		System.out.print("\n----------------- Deduct Stock -----------------\n\n");

		if (products.isEmpty()) {
			System.out.println("No products available.");
			return;
		}
		int num = displayProducts(scanner, products);
		int currentQuantity = products.get(num).getQuantityAvailable();

		try {
			System.out.print("Enter quantity to deduct: ");
			int quantity = scanner.nextInt();
			scanner.nextLine(); // clear buffer

			if (quantity >= 0 && quantity <= currentQuantity) {
				int deductedQuantity = currentQuantity - quantity;
				products.get(num).setQuantityAvailable(deductedQuantity);
			} else {
				System.out.print("\nInvalid option. The input is more than the current quantity.\n");
			}

		} catch (InputMismatchException e) {
			System.out.print("\nInvalid input! Please enter a valid integer number.\n");
			scanner.nextLine(); // clear the invalid input
		}

	}

	// discontinue product
	public static void discontinueProduct(ArrayList<Product> products, Scanner scanner) {

		System.out.print("\n-------------- Discontinue Product --------------\n\n");

		if (products.isEmpty()) {
			System.out.println("No products available.");
			return;
		}

		int num = displayProducts(scanner, products);
		products.get(num).setStatus(false);
		System.out.print("Status of product has been set to discontinued.\n");
	}

	// add product
	public static void addProduct(Scanner scanner, ArrayList<Product> products) {
		while (true) {
			try {
				System.out.println("\n----------------- Choose Product Type -----------------");
				System.out.println("1. Refrigerator");
				System.out.println("2. TV");
				System.out.println("3. Washing Machine");
				System.out.print("\nChoose product type: ");

				int choice = scanner.nextInt();
				scanner.nextLine(); // clear buffer

				if (choice == 1) {
					addRefrigerator(scanner, products);
					break;
				} else if (choice == 2) {
					addTV(scanner, products);
					break;
				} else if (choice == 3) {
					addWashingMachine(scanner, products);
					break;
				} else
					System.out.println("Invalid choice! Please enter 1-3.");
			}

			catch (InputMismatchException e) {
				System.out.print("\nInvalid input! Please enter a valid integer number.\n");
				scanner.nextLine(); // clear the invalid input
			}
		}
	}

	// Add Refrigerator
	private static void addRefrigerator(Scanner scanner, ArrayList<Product> products) {
		while (true) {
			try {
				System.out.print("\n---------------- Add Refrigerator ----------------\n\n");

				System.out.print("Enter name: ");
				String name = scanner.nextLine();

				System.out.print("Enter door design: ");
				String doorDesign = scanner.nextLine();

				System.out.print("Enter color: ");
				String color = scanner.nextLine();

				System.out.print("Enter capacity (in Litres): ");
				double capacity = scanner.nextDouble();
				scanner.nextLine(); // Clear buffer

				System.out.print("Enter quantity available: ");
				int quantity = scanner.nextInt();
				scanner.nextLine(); // Clear buffer

				System.out.print("Enter price (RM): ");
				double price = scanner.nextDouble();
				scanner.nextLine(); // Clear buffer

				System.out.print("Enter item number: ");
				int itemNumber = scanner.nextInt();
				scanner.nextLine(); // Clear buffer

				Product refrigerator = new Refrigerator(itemNumber, name, quantity, price, doorDesign, color, capacity);
				products.add(refrigerator);
				break;
			}

			catch (InputMismatchException e) {
				System.out.println("\nInvalid input! Please enter correct data types for each field.\n");
				scanner.nextLine(); // clear the invalid input
			}
		}
	}

	// Add TV
	private static void addTV(Scanner scanner, ArrayList<Product> products) {
		while (true) {
			try {
				System.out.print("\n-------------------- Add TV ---------------------\n\n");

				System.out.print("Enter name: ");
				String name = scanner.nextLine();

				System.out.print("Enter screen type: ");
				String screenType = scanner.nextLine();

				System.out.print("Enter resolution: ");
				String resolution = scanner.nextLine();

				System.out.print("Enter display size: ");
				double displaySize = scanner.nextDouble();
				scanner.nextLine(); // Clear buffer

				System.out.print("Enter quantity available: ");
				int quantity = scanner.nextInt();
				scanner.nextLine(); // Clear buffer

				System.out.print("Enter price (RM): ");
				double price = scanner.nextDouble();
				scanner.nextLine(); // Clear buffer

				System.out.print("Enter item number: ");
				int itemNumber = scanner.nextInt();
				scanner.nextLine(); // Clear buffer

				Product tv = new TV(itemNumber, name, quantity, price, screenType, resolution, displaySize);
				products.add(tv);
				break;
			}

			catch (InputMismatchException e) {
				System.out.println("\nInvalid input! Please enter correct data types for each field.\n");
				scanner.nextLine(); // clear the invalid input
			}
		}
	}

	// Add Washing Machine
	private static void addWashingMachine(Scanner scanner, ArrayList<Product> products) {
		while (true) {
			try {
				System.out.print("\n---------------- Add Washing Machine -----------------\n\n");

				System.out.print("Enter name: ");
				String name = scanner.nextLine();

				System.out.print("Enter loading type: ");
				String loadingType = scanner.nextLine();

				System.out.print("Enter energy rating: ");
				String energyRating = scanner.nextLine();

				System.out.print("Enter capacity: ");
				double capacity = scanner.nextDouble();
				scanner.nextLine(); // Clear buffer

				System.out.print("Enter quantity available: ");
				int quantity = scanner.nextInt();
				scanner.nextLine(); // Clear buffer

				System.out.print("Enter price (RM): ");
				double price = scanner.nextDouble();
				scanner.nextLine(); // Clear buffer

				System.out.print("Enter item number: ");
				int itemNumber = scanner.nextInt();
				scanner.nextLine(); // Clear buffer

				Product wm = new WashingMachine(itemNumber, name, quantity, price, loadingType, energyRating, capacity);
				products.add(wm);
				break;
			}

			catch (InputMismatchException e) {
				System.out.println("\nInvalid input! Please enter correct data types for each field.\n");
				scanner.nextLine(); // clear the invalid input
			}
		}
	}

	// Main method
	public static void main(String[] args) {

		ArrayList<Product> products = new ArrayList<Product>();
		Scanner scanner = new Scanner(System.in);

		// format time
		LocalDateTime time = LocalDateTime.now();
		DateTimeFormatter timeFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
		String formattedTime = time.format(timeFormat);

		// Welcome message
		System.out.println("Welcome to the SMS");
		System.out.println("Date and Time: \t" + formattedTime);
		System.out.println("Group Members: \tFong Zi Lin\n\t\tGoh Yun Ning\n\t\tJoyce Lau Yu Xuan\n\t\tLee Tze Yin\n");

		// Get user info
		UserInfo user = new UserInfo();
		user.getUserName();

		// Add products
		System.out.print("\n----------------------- Add Products ----------------------\n\n");

		int choice;
		do {
			try {
				System.out.print("Do you wish to add products? (1 = Yes, 0 = No): ");
				choice = scanner.nextInt();
				scanner.nextLine(); // clear buffer

				if (choice == 1) {
					int maxProducts = getMaxProducts(scanner);
					for (int i = 0; i < maxProducts; i++) {
						addProduct(scanner, products);
					}
				} else if (choice == 0)
					System.out.println("\nPlease enter zero to exit the program.");
				else
					System.out.println("\nInvalid input. Please input 0 or 1.\n");
			}

			catch (InputMismatchException e) {
				System.out.println("\nInvalid input! Please enter a number.\n");
				scanner.nextLine(); // clear the invalid input
				choice = -1; // force the loop to continue
			}

		} while (choice < 0 || choice > 1);

		// Display menu
		int menuChoice;

		do {
			menuChoice = displayMenu(scanner);
			executeMenu(menuChoice, products, scanner);
		} while (menuChoice != 0);

		scanner.close();

		// Display user info
		System.out.println("User ID: " + user.getUserID() + "\t\tUser Name: " + user.getName());
	}
}