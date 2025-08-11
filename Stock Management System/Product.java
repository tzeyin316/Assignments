
public abstract class Product {
	private String name;
	private double price;
	private int quantityAvailable;
	private int itemNumber;
	private boolean status;

	// Constructors
	public Product() {
	}

	public Product(int itemNumber, String name, int quantityAvailable, double price) {
		this.itemNumber = itemNumber;
		this.name = name;
		this.quantityAvailable = quantityAvailable;
		this.price = price;
		this.status = true;
	}

	// Getters and Setters
	public int getItemNumber() {
		return itemNumber;
	}

	public void setItemNumber(int itemNumber) {
		this.itemNumber = itemNumber;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getQuantityAvailable() {
		return quantityAvailable;
	}

	public void setQuantityAvailable(int quantityAvailable) {
		this.quantityAvailable = quantityAvailable;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public boolean getStatus() {
		return status;
	}

	public void setStatus(boolean status) {
		this.status = status;
	}

	// Methods
	public double getTotalInventoryValue() {
		return price * quantityAvailable;
	}

	public void addStock(int quantity) {
		if (status) {
			quantityAvailable += quantity;
		} else {
			System.out.println("Cannot add stock to a discontinued product.");
		}
	}

	public void deductStock(int quantity) {
		if (quantity <= quantityAvailable) {
			quantityAvailable -= quantity;
		} else {
			System.out.println("Insufficient stock.");
		}
	}

	@Override
	public String toString() {
		return "Item number: " + itemNumber + "\n" + 
				"Product name: " + name + "\n" + 
				"Quantity available: " + quantityAvailable + "\n" + 
				"Price (RM): " + price + "\n" + 
				"Inventory value (RM): " + getTotalInventoryValue() + "\n" + 
				"Product status: " + (status ? "Active" : "Discontinued");
	}
}