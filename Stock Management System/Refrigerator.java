
public class Refrigerator extends Product {
	private String doorDesign;
	private String color;
	private double capacity;

	// Constructor
	public Refrigerator(int itemNumber, String name, int quantityAvailable, double price, String doorDesign,
			String color, double capacity) {
		super(itemNumber, name, quantityAvailable, price);
		this.doorDesign = doorDesign;
		this.color = color;
		this.capacity = capacity;
	}

	// Getters and Setters
	public String getDoorDesign() {
		return doorDesign;
	}

	public void setDoorDesign(String doorDesign) {
		this.doorDesign = doorDesign;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public double getCapacity() {
		return capacity;
	}

	public void setCapacity(double capacity) {
		this.capacity = capacity;
	}

	@Override
	public String toString() {
		return "Item number: " + getItemNumber() + "\n" + 
				"Product name: " + getName() + "\n" + 
				"Door design: " + doorDesign + "\n" + 
				"Color: " + color + "\n" +
				"Capacity (in Litres): " + capacity + "\n" +
				"Quantity available: " + getQuantityAvailable() + "\n" + 
				"Price (RM): " + getPrice() + "\n" + 
				"Inventory value (RM): " + getTotalInventoryValue() + "\n" + 
				"Product status: " + (getStatus() ? "Active" : "Discontinued");
	}
}