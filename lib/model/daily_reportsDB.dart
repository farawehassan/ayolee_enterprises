
class DailyReportsData {

  DailyReportsData({this.id, this.productName, this.quantity, this.unitPrice, this.totalPrice, this.time, this.paymentMode});

  String id;
  String productName;
  String quantity;
  String unitPrice;
  String totalPrice;
  String time;
  String paymentMode;

  //DailyReportsData();

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