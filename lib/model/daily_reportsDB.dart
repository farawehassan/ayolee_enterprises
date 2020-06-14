/// A class to hold my [DailyReportsData] model
class DailyReportsData {

  /// Setting constructor for [DailyReportsData] class
  DailyReportsData({
    this.id,
    this.productName,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.time,
    this.paymentMode
  });

  /// A string variable to hold id
  String id;

  /// A string variable to hold product name
  String productName;

  /// A string variable to hold quantity
  String quantity;
  /// A string variable to hold unit price
  String unitPrice;

  /// A string variable to hold total price
  String totalPrice;

  /// A string variable to hold time
  String time;

  /// A string variable to hold payment mode
  String paymentMode;


  /// Creating a method to map my JSON values to the model details accordingly
  factory DailyReportsData.fromJson(Map<String, dynamic> json) {
    return DailyReportsData(
      id: json["id"].toString(),
      productName: json["productName"].toString(),
      quantity: json["qty"].toString(),
      unitPrice: json["unitPrice"].toString(),
      totalPrice: json["totalPrice"].toString(),
      time: json["reportTime"].toString(),
      paymentMode: json["paymentMode"].toString(),
    );
  }

}