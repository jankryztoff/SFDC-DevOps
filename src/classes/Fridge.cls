public class Fridge {
	public String modelNumber;
	private Integer numberInStock;
	public void updateStock(Integer justSold) {
	numberInStock = numberInStock - justSold;
	}
    
    public void setModelNumber(String theModelNumber) {
	modelNumber = theModelNumber;
	}
							public String getModelNumber() {
	return modelNumber;
	}
}