
/// A class to hold my [AvailableProduct] model
class AvailableProduct {

  /// Setting constructor for [AvailableProduct] class
  AvailableProduct({
    this.productName,
    this.costPrice,
    this.sellingPrice,
    this.initialQuantity,
    this.currentQuantity
  });

  /// A string variable to hold my product name
  String productName;

  /// A string variable to hold my cost price
  String costPrice;

  /// A string variable to hold my selling price
  String sellingPrice;

  /// A string variable to hold my initial quantity
  String initialQuantity;

  /// A string variable to hold my current quantity
  String currentQuantity;


  /// Creating a method to map my JSON values to the model details accordingly
  factory AvailableProduct.fromJson(Map<String, dynamic> json) {
    return AvailableProduct(
      productName: json["productName"].toString(),
      costPrice: json["costPrice"].toString(),
      sellingPrice: json["sellingPrice"].toString(),
      initialQuantity: json["initialQty"].toString(),
      currentQuantity: json["currentQty"].toString(),
    );
  }

}