import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'future_values.dart';

class DailyReportValue{

  static DateTime now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);

  final weekday = DateTime(now.weekday);

  static double totalSalesPrice = 0.0;

  static double availableCash = 0.0;

  static double totalTransfer = 0.0;

  var futureValue = FutureValues();

  /// Method to return today's date
  DateTime getFormattedDay(String dateTime) {
    DateTime day = DateTime.parse(dateTime);
    return DateTime(day.year, day.month, day.day);
  }

  /// Method to return today's week
  DateTime getFormattedWeek(String dateTime) {
    DateTime day = DateTime.parse(dateTime);
    return DateTime(day.weekday);
  }

  /// Method to return today's month
  DateTime getFormattedMonth(String dateTime) {
    DateTime day = DateTime.parse(dateTime);
    return DateTime(day.year, day.month);
  }

  /// Method to check if a date is today
  bool checkIfToday(String dateTime){
    if(getFormattedDay(dateTime) == today){
      return true;
    }
    return false;
  }

  /// Method to check if a date is this month
  bool checkMonth(String dateTime, DateTime month){
    if(getFormattedMonth(dateTime) == month){
      return true;
    }
    return false;
  }

  Future<double> calculateProfit(List<DailyReportsData> data) async {
    double totalProfitMade = 0.0;
    Future<List<AvailableProduct>> products = futureValue.getProductFromDB();
    await products.then((value) {
      print(value);
      for(int i = 0; i < data.length; i++){
        double profitMade = 0.0;
        for (int i = 0; i < value.length; i++){
          if(value[i].productName == data[i].productName){
            double profit = double.parse(value[i].sellingPrice) - double.parse(value[i].costPrice);
            profitMade += (double.parse(data[i].quantity) * profit);
            print(profit);
            print(profitMade);
          }
        }
        totalProfitMade += profitMade;
      }
    });
    return totalProfitMade;
  }

  /// Method to get today's report based on time
  Future<List<DailyReportsData>> getTodayReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkIfToday(value[i].time)){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get January's report based on time
  Future<List<DailyReportsData>> getJanReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.january))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get February's report based on time
  Future<List<DailyReportsData>> getFebReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.february))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get March's report based on time
  Future<List<DailyReportsData>> getMarReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.march))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get April's report based on time
  Future<List<DailyReportsData>> getAprReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.april))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get May's report based on time
  Future<List<DailyReportsData>> getMayReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.may))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get June's report based on time
  Future<List<DailyReportsData>> getJunReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.june))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get July's report based on time
  Future<List<DailyReportsData>> getJulReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.july))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get August's report based on time
  Future<List<DailyReportsData>> getAugReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.august))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get September's report based on time
  Future<List<DailyReportsData>> getSepReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.september))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get October's report based on time
  Future<List<DailyReportsData>> getOctReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.october))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get November's report based on time
  Future<List<DailyReportsData>> getNovReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.november))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

  /// Method to get December's report based on time
  Future<List<DailyReportsData>> getDecReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      for(int i = 0; i < value.length; i++){
        if(checkMonth(value[i].time, DateTime(now.year, DateTime.december))){
          DailyReportsData reportsData = new DailyReportsData();
          reportsData.quantity = value[i].quantity;
          reportsData.productName = value[i].productName;
          reportsData.unitPrice = value[i].unitPrice;
          reportsData.totalPrice = value[i].totalPrice;
          reportsData.paymentMode = value[i].paymentMode;
          reportsData.time = value[i].time;
          reports.add(reportsData);
        }
      }
    });
    return reports;
  }

}