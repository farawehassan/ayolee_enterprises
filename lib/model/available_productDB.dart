
class AvailableProduct {

  AvailableProduct({this.productName, this.costPrice, this.sellingPrice, this.initialQuantity, this.currentQuantity});

  String productName;
  String costPrice;
  String sellingPrice;
  String initialQuantity;
  String currentQuantity;

  factory AvailableProduct.fromJson(Map<String, dynamic> json) {
    return AvailableProduct(
      productName: json["productName"].toString(),
      costPrice: json["costPrice"].toString(),
      sellingPrice: json["sellingPrice"].toString(),
      initialQuantity: json["initialQty"].toString(),
      currentQuantity: json["currentQty"].toString(),
    );
  }

  //AvailableProduct();

  /*AvailableProduct.map(dynamic obj) {
    this.productName = obj["productName"];
    this.costPrice = obj["costPrice"];
    this.sellingPrice = obj["sellingPrice"];
    this.initialQuantity = obj["initialQty"];
    this.currentQuantity = obj["currentQty"];
  }*/

 /* String get productName => productName;
  double get costPrice => costPrice;
  double get sellingPrice => sellingPrice;
  double get initialQuantity => initialQuantity;
  double get currentQuantity => currentQuantity;*/

 /* Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["productName"] = productName;
    map["costPrice"] = costPrice;
    map["sellingPrice"] = sellingPrice;
    map["initialQty"] = initialQuantity;
    map["currentQty"] = currentQuantity;

    return map;
  }*/

  /*Map<String, dynamic> toJson() =>
      {
        "productName" : productName,
        "costPrice" : costPrice,
        "sellingPrice" : sellingPrice,
        "initialQty" : initialQuantity,
        "currentQty" : currentQuantity,
      };
*/

}