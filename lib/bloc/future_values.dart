import 'package:ayolee_stores/database/user_db_helper.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/model/store_details.dart';
import 'package:ayolee_stores/model/user.dart';
import 'package:ayolee_stores/networking/rest_data.dart';
import 'daily_report_value.dart';
import 'package:ayolee_stores/model/linear_sales.dart';

class FutureValues{

  /// Method to get all the current user
  Future<User> getCurrentUser() async {
    var dbHelper = DatabaseHelper();
    Future<User> user = dbHelper.getUser();
    return user;
  }

  /// Method to get all the products from database
  Future<List<AvailableProduct>> getProductFromDB() async {
    var data = RestDataSource();
    Future<List<AvailableProduct>> availableProduct = data.fetchAllProducts();
    return availableProduct;
  }

  /// Method to get all the available products from database
  Future<List<AvailableProduct>> getProductsFromDB() async {
    var data = RestDataSource();
    List<AvailableProduct> products = new List();
    Future<List<AvailableProduct>> availableProduct = data.fetchAllProducts();
    await availableProduct.then((value){
      for(int i = 0; i < value.length; i++){
        if(double.parse(value[i].currentQuantity) != 0.0){
          products.add(value[i]);
        }
      }
    });
    return products;
  }

  /// Method to get daily reports from database
  Future<List<DailyReportsData>> getDailyReportsFromDB() async {
    var data = RestDataSource();
    Future<List<DailyReportsData>> dailyReportData = data.fetchAllReports();
    return dailyReportData;
  }

  /// Method to get today's reports from daily reports
  Future<List<DailyReportsData>> getTodayReports() async {
    var reportValue = DailyReportValue();
    Future<List<DailyReportsData>> todayReport = reportValue.getTodayReport();
    return todayReport;
  }

  /// Method to get all the available products details
  Future<StoreDetails> availableProducts() async {
    StoreDetails storeDetails = new StoreDetails();
    double cpNetWorth = 0;
    double spNetWorth = 0;
    double numberOfItems = 0;
    Future<List<AvailableProduct>> productNames = getProductsFromDB();
    await productNames.then((value) {
      for (int i = 0; i < value.length; i++){
        cpNetWorth += (double.parse(value[i].costPrice) * double.parse(value[i].currentQuantity));
        spNetWorth += (double.parse(value[i].sellingPrice) * double.parse(value[i].currentQuantity));
        numberOfItems +=  double.parse(value[i].currentQuantity);
      }
    });
    storeDetails.cpNetWorth = cpNetWorth;
    storeDetails.spNetWorth = spNetWorth;
    storeDetails.numberOfItems = numberOfItems;
    return storeDetails;
  }

  /// Method to calculate profit of a report
  Future<double> calculateProfit(DailyReportsData data) async {
    double profitMade = 0.0;
    Future<List<AvailableProduct>> products = getProductFromDB();
    await products.then((value) {
      for (int i = 0; i < value.length; i++){
        if(value[i].productName == data.productName){
          if(data.paymentMode != 'Iya Bimbo'){
            double profit = double.parse(data.unitPrice) - double.parse(value[i].costPrice);
            profitMade += (double.parse(data.quantity) * profit);
          }
        }
      }
    });
    return profitMade;
  }

  /// Method to get report of a year
  Future<List<LinearSales>> getYearReports() async {
    List<LinearSales> sales = new List();
    var reportValue = DailyReportValue();

    Future<List<DailyReportsData>> janReport = reportValue.getJanReport();
    await janReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Jan';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> febReport = reportValue.getFebReport();
    await febReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Feb';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> marReport = reportValue.getMarReport();
    await marReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Mar';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> aprReport = reportValue.getAprReport();
    await aprReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Apr';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> mayReport = reportValue.getMayReport();
    await mayReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'May';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> junReport = reportValue.getJunReport();
    await junReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Jun';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> julReport = reportValue.getJulReport();
    await julReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Jul';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> augReport = reportValue.getAugReport();
    await augReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Aug';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> sepReport = reportValue.getSepReport();
    await sepReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Sep';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> octReport = reportValue.getOctReport();
    await octReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Oct';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> novReport = reportValue.getNovReport();
    await novReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Nov';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    Future<List<DailyReportsData>> decReport = reportValue.getDecReport();
    await decReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        Future<double> profit = calculateProfit(value[i]);
        await profit.then((profitValue){
          totalProfitMade += profitValue;
        });
        if(value[i].paymentMode != 'Iya Bimbo'){
          totalSales += double.parse(value[i].totalPrice);
        }
      }
      linearSales.month = 'Dec';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    });

    return sales;

  }

  /// Method to get report of a month
  Future<List<DailyReportsData>> getMonthReports(String month) {
    var reportValue = DailyReportValue();

    switch(month) {
      case 'Jan': {
        Future<List<DailyReportsData>> monthReport = reportValue.getJanReport();
        return monthReport;
      }
      break;

      case 'Feb': {
        Future<List<DailyReportsData>> monthReport = reportValue.getFebReport();
        return monthReport;
      }
      break;

      case 'Mar': {
        Future<List<DailyReportsData>> monthReport = reportValue.getMarReport();
        return monthReport;
      }
      break;

      case 'Apr': {
        Future<List<DailyReportsData>> monthReport = reportValue.getAprReport();
        return monthReport;
      }
      break;

      case 'May': {
        Future<List<DailyReportsData>> monthReport = reportValue.getMayReport();
        return monthReport;
      }
      break;

      case 'Jun': {
        Future<List<DailyReportsData>> monthReport = reportValue.getJunReport();
        return monthReport;
      }
      break;

      case 'Jul': {
        Future<List<DailyReportsData>> monthReport = reportValue.getJulReport();
        return monthReport;
      }
      break;

      case 'Aug': {
        Future<List<DailyReportsData>> monthReport = reportValue.getAugReport();
        return monthReport;
      }
      break;

      case 'Sep': {
        Future<List<DailyReportsData>> monthReport = reportValue.getSepReport();
        return monthReport;
      }
      break;

      case 'Oct': {
        Future<List<DailyReportsData>> monthReport = reportValue.getOctReport();
        return monthReport;
      }
      break;

      case 'Nov': {
        Future<List<DailyReportsData>> monthReport = reportValue.getNovReport();
        return monthReport;
      }
      break;

      case 'Dec': {
        Future<List<DailyReportsData>> monthReport = reportValue.getDecReport();
        return monthReport;
      }
      break;

      default: {
        return null;
      }
      break;
    }

  }

}


