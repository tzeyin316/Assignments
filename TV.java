
public class TV extends Product {
	private String screenType;
	private String resolution;
	private double displaySize;

	// Constructor
	public TV(int itemNumber, String name, int quantityAvailable, double price, String screenType, String resolution,
			double displaySize) {
		super(itemNumber, name, quantityAvailable, price);
		this.screenType = screenType;
		this.resolution = resolution;
		this.displaySize = displaySize;
	}

	// Getters and Setters
	public String getScreenType() {
		return screenType;
	}

	public void setScreenType(String screenType) {
		this.screenType = screenType;
	}

	public String getResolution() {
		return resolution;
	}

	public void setResolution(String resolution) {
		this.resolution = resolution;
	}

	public double getDisplaySize() {
		return displaySize;
	}

	public void setDisplaySize(double displaySize) {
		this.displaySize = displaySize;
	}

	@Override
	public String toString() {
		return "Item number: " + getItemNumber() + "\n" + 
				"Product name: " + getName() + "\n" + 
				"Screen type: " + screenType + "\n" + 
				"Resolution: " + resolution + "\n" + 
				"Display size: " + displaySize + "\n" +
				"Quantity available: " + getQuantityAvailable() + "\n" + 
				"Price (RM): " + getPrice() + "\n" + 
				"Inventory value (RM): " + getTotalInventoryValue() + "\n" + 
				"Product status: " + (getStatus() ? "Active" : "Discontinued");			 
	}
}