import 'package:ayolee_stores/database/DBHelper.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';

class ReportValue{

  static DateTime now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);

  /// Method to get daily reports from database
  Future<List<DailyReportsData>> getDailyReportsFromDB() async {
    var dbHelper = DBHelper();
    Future<List<DailyReportsData>> dailyReportData = dbHelper.getDailyReports();
    return dailyReportData;
  }

  /// Method to return today's date
  DateTime getFormattedDay(String dateTime) {
    DateTime day = DateTime.parse(dateTime);
    return DateTime(day.year, day.month, day.day);
  }

  /// Method to check if a date is today
  bool checkIfToday(String dateTime){
    if(getFormattedDay(dateTime) == today){
      return true;
    }
    return false;
  }

  /// Method to get today's report based on time
  Future<List<DailyReportsData>> getTodayReport() async {
    List<DailyReportsData> reports = new List();
    Future<List<DailyReportsData>> report = getDailyReportsFromDB();
    report.then((value) {
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
}