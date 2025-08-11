
public class WashingMachine extends Product {
	
    private String loadingType;
    private String energyRating;
    private double capacity;

    // Constructor
    public WashingMachine(int itemNumber, String name, int quantityAvailable, double price, 
                         String loadingType, String energyRating, double capacity) {
        super(itemNumber, name, quantityAvailable, price);
        this.loadingType = loadingType;
        this.energyRating = energyRating;
        this.capacity = capacity;
    }

    // Getters and Setters
    public String getLoadingType() {
        return loadingType;
    }

    public void setLoadingType(String loadingType) {
        this.loadingType = loadingType;
    }

    public String getEnergyRating() {
        return energyRating;
    }

    public void setEnergyRating(String energyRating) {
        this.energyRating = energyRating;
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
               "Loading type: " + loadingType + "\n" + 
               "Energy rating: " + energyRating + "\n" +
               "Capacity (in kg): " + capacity + "\n" +
               "Quantity available: " + getQuantityAvailable() + "\n" + 
               "Price (RM): " + getPrice() + "\n" + 
               "Inventory value (RM): " + getTotalInventoryValue() + "\n" + 
               "Product status: " + (getStatus() ? "Active" : "Discontinued");
    }
}