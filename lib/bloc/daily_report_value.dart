import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'future_values.dart';

/// A class to handle methods needed with daily report records in the database
class DailyReportValue{

  /// Variable [now] holding today's current date time
  static DateTime now = DateTime.now();

  /// Variable to hold today's date in year, month and day
  final today = DateTime(now.year, now.month, now.day);

  /// Variable to hold today's date in weekday
  final weekday = DateTime(now.weekday);

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Method to format a string value [dateTime] to a [DateTime]
  /// of year, month and day only
  DateTime getFormattedDay(String dateTime) {
    DateTime day = DateTime.parse(dateTime);
    return DateTime(day.year, day.month, day.day);
  }

  /// Method to format a string value [dateTime] to a [DateTime]
  /// of weekday only
  DateTime getFormattedWeek(String dateTime) {
    DateTime day = DateTime.parse(dateTime);
    return DateTime(day.weekday);
  }

  /// Method to format a string value [dateTime] to a [DateTime]
  /// of year and month only
  DateTime getFormattedMonth(String dateTime) {
    DateTime day = DateTime.parse(dateTime);
    return DateTime(day.year, day.month);
  }

  /// Method to check if a date is today
  /// It returns true if it is and false if it's not
  bool checkIfToday(String dateTime){
    if(getFormattedDay(dateTime) == today){
      return true;
    }
    return false;
  }

  /// Method to check if a date is this month
  /// It returns true if it is and false if it's not
  bool checkMonth(String dateTime, DateTime month){
    if(getFormattedMonth(dateTime) == month){
      return true;
    }
    return false;
  }

  /// Method to calculate profit made of a report by deducting the report's
  /// [unitPrice] from the product's [costPrice] and multiplying the value by the
  /// report's [quantity]
  /// It is done if the report's [paymentMode] is not 'Iya Bimbo'
  /// or else it returns 0
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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
  /// It returns a list of [DailyReportsData]
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