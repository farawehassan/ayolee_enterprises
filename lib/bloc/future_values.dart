import 'package:ayolee_stores/database/user_db_helper.dart';
import 'package:ayolee_stores/model/product_history.dart';
import 'package:ayolee_stores/model/reportsDB.dart';
import 'package:ayolee_stores/model/productDB.dart';
import 'package:ayolee_stores/model/store_details.dart';
import 'package:ayolee_stores/model/user.dart';
import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:intl/intl.dart';
import 'daily_report_value.dart';
import 'package:ayolee_stores/model/linear_sales.dart';

/// A class to handle my asynchronous methods linking to the server or database
class FutureValues{

  /// Method to get the current [user] in the database using the
  /// [DatabaseHelper] class
  Future<User> getCurrentUser() async {
    var dbHelper = DatabaseHelper();
    Future<User> user = dbHelper.getUser();
    return user;
  }

  /// Method to get all the products from the database in the server with
  /// the help of [RestDataSource]
  /// It returns a list of [Product]
  Future<List<Product>> getAllProductsFromDB() {
    var data = RestDataSource();
    Future<List<Product>> product = data.fetchAllProducts();
    return product;
  }

  /// Method to get all the products from the database in the server that its
  /// [currentQuantity] is not 0 with the help of [RestDataSource]
  /// It returns a list of [Product]
  Future<List<Product>> getAvailableProductsFromDB() async {
    List<Product> products = new List();
    Future<List<Product>> availableProduct = getAllProductsFromDB();
    await availableProduct.then((value){
      for(int i = 0; i < value.length; i++){
        if(double.parse(value[i].currentQuantity) != 0.0){
          products.add(value[i]);
        }
      }
    }).catchError((e){
      throw e;
    });
    return products;
  }

  /// Method to get all the products from the database in the server that its
  /// [currentQuantity] is = 0 with the help of [RestDataSource]
  /// It returns a list of [Product]
  Future<List<Product>> getFinishedProductFromDB() async {
    List<Product> products = new List();
    Future<List<Product>> finishedProduct = getAllProductsFromDB();
    await finishedProduct.then((value){
      for(int i = 0; i < value.length; i++){
        if(double.parse(value[i].currentQuantity) == 0.0){
          products.add(value[i]);
        }
      }
    }).catchError((e){
      throw e;
    });
    return products;
  }

  /// Method to get all the product history from the database in the server with
  /// the help of [RestDataSource]
  /// It returns a list of [ProductHistory]
  Future<List<ProductHistory>> getAllProductsHistoryFromDB() {
    var data = RestDataSource();
    Future<List<ProductHistory>> productHistory = data.fetchAllProductHistory();
    return productHistory;
  }

  /// Method to get a particular the product history from the database
  /// in the server with the help of [RestDataSource]
  /// It returns a list of [ProductHistory]
  Future<ProductHistory> getAProductHistoryFromDB(String id) {
    var data = RestDataSource();
    Future<ProductHistory> productHistory = data.findProductHistory(id);
    return productHistory;
  }

  /// Method to get all the reports from the database in the server with
  /// the help of [RestDataSource]
  /// It returns a list of [Reports]
  Future<List<Reports>> getAllReportsFromDB() {
    var data = RestDataSource();
    Future<List<Reports>> dailyReportData = data.fetchAllReports();
    return dailyReportData;
  }

  /// Method to get today's reports from [DailyReportValue] based on time by
  /// calling the [getTodayReport]
  /// It returns a list of [Reports]
  Future<List<Reports>> getTodayReports() {
    var reportValue = DailyReportValue();
    Future<List<Reports>> todayReport = reportValue.getTodayReport();
    return todayReport;
  }


  /// Method to get all the store details such as:
  ///  cost price net worth, selling price net worth, number of product items,
  ///  total sales made, totalProfitMade
  /// It returns a model of [StoreDetails]
  Future<StoreDetails> getStoreDetails() async {
    var data = RestDataSource();
    Future<StoreDetails> storeDetails = data.fetchStoreDetails();
    return storeDetails;
  }

  /// Method to get report of a [month] using the class [DailyReportValue]
  /// /// It returns a list of [Reports]
  List<Reports> getMonthReports(String month, List<Reports> reports, {int year}) {
    var reportValue = DailyReportValue();

    switch(month) {
      case 'Jan': {
        List<Reports> monthReport = reportValue.getJanReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'Feb': {
        List<Reports> monthReport = reportValue.getFebReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'Mar': {
        List<Reports> monthReport = reportValue.getMarReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'Apr': {
        List<Reports> monthReport = reportValue.getAprReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'May': {
        List<Reports> monthReport = reportValue.getMayReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'Jun': {
        List<Reports> monthReport = reportValue.getJunReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'Jul': {
        List<Reports> monthReport = reportValue.getJulReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'Aug': {
        List<Reports> monthReport = reportValue.getAugReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'Sep': {
        List<Reports> monthReport = reportValue.getSepReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'Oct': {
        List<Reports> monthReport = reportValue.getOctReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'Nov': {
        List<Reports> monthReport = reportValue.getNovReport(reports, year: year);
        return monthReport;
      }
      break;

      case 'Dec': {
        List<Reports> monthReport = reportValue.getDecReport(reports, year: year);
        return monthReport;
      }
      break;

      default: {
        return null;
      }
      break;
    }

  }

  /// Method to get report of a [month] using the class [DailyReportValue]
  /// /// It returns a model of [LinearSales]
  LinearSales getMonthAndYearReports(String month, List<Reports> reports, {int year}) {
    var reportValue = DailyReportValue();

    switch(month) {
      case '1': {
        List<Reports> janReport = reportValue.getJanReport(reports, year: year);
        LinearSales janLinearSales = LinearSales();
        double janTotalProfitMade = 0.0;
        double janTotalSales = 0;
        for(int i = 0; i < janReport.length; i++){
          if(janReport[i].paymentMode != 'Iya Bimbo'){
            janTotalProfitMade += double.parse(janReport[i].quantity) *
                (double.parse(janReport[i].unitPrice) - double.parse(janReport[i].costPrice));
            janTotalSales += double.parse(janReport[i].totalPrice);
          }
        }
        janLinearSales.month = 'Jan $year';
        janLinearSales.sales = janTotalSales;
        janLinearSales.profit = janTotalProfitMade;
        return janLinearSales;
      }
      break;

      case '2': {
        List<Reports> febReport = reportValue.getFebReport(reports, year: year);
        LinearSales febLinearSales = LinearSales();
        double febTotalProfitMade = 0.0;
        double febTotalSales = 0;
        for(int i = 0; i < febReport.length; i++){
          if(febReport[i].paymentMode != 'Iya Bimbo'){
            febTotalProfitMade += double.parse(febReport[i].quantity) *
                (double.parse(febReport[i].unitPrice) - double.parse(febReport[i].costPrice));
            febTotalSales += double.parse(febReport[i].totalPrice);
          }
        }
        febLinearSales.month = 'Feb $year';
        febLinearSales.sales = febTotalSales;
        febLinearSales.profit = febTotalProfitMade;
        return febLinearSales;
      }
      break;

      case '3': {
        List<Reports> marReport = reportValue.getMarReport(reports, year: year);
        LinearSales marLinearSales = LinearSales();
        double marTotalProfitMade = 0.0;
        double marTotalSales = 0;
        for(int i = 0; i < marReport.length; i++){
          if(marReport[i].paymentMode != 'Iya Bimbo'){
            marTotalProfitMade += double.parse(marReport[i].quantity) *
                (double.parse(marReport[i].unitPrice) - double.parse(marReport[i].costPrice));
            marTotalSales += double.parse(marReport[i].totalPrice);
          }
        }
        marLinearSales.month = 'Mar $year';
        marLinearSales.sales = marTotalSales;
        marLinearSales.profit = marTotalProfitMade;
        return marLinearSales;
      }
      break;

      case '4': {
        List<Reports> aprReport = reportValue.getAprReport(reports, year: year);
        LinearSales aprLinearSales = LinearSales();
        double aprTotalProfitMade = 0.0;
        double aprTotalSales = 0;
        for(int i = 0; i < aprReport.length; i++){
          if(aprReport[i].paymentMode != 'Iya Bimbo'){
            aprTotalProfitMade += double.parse(aprReport[i].quantity) *
                (double.parse(aprReport[i].unitPrice) - double.parse(aprReport[i].costPrice));
            aprTotalSales += double.parse(aprReport[i].totalPrice);
          }
        }
        aprLinearSales.month = 'Apr $year';
        aprLinearSales.sales = aprTotalSales;
        aprLinearSales.profit = aprTotalProfitMade;
        return aprLinearSales;
      }
      break;

      case '5': {
        List<Reports> mayReport = reportValue.getMayReport(reports, year: year);
        LinearSales mayLinearSales = LinearSales();
        double mayTotalProfitMade = 0.0;
        double mayTotalSales = 0;
        for(int i = 0; i < mayReport.length; i++){
          if(mayReport[i].paymentMode != 'Iya Bimbo'){
            mayTotalProfitMade += double.parse(mayReport[i].quantity) *
                (double.parse(mayReport[i].unitPrice) - double.parse(mayReport[i].costPrice));
            mayTotalSales += double.parse(mayReport[i].totalPrice);
          }
        }
        mayLinearSales.month = 'May $year';
        mayLinearSales.sales = mayTotalSales;
        mayLinearSales.profit = mayTotalProfitMade;
        return mayLinearSales;
      }
      break;

      case '6': {
        List<Reports> junReport = reportValue.getJunReport(reports, year: year);
        LinearSales junLinearSales = LinearSales();
        double junTotalProfitMade = 0.0;
        double junTotalSales = 0;
        for(int i = 0; i < junReport.length; i++){
          if(junReport[i].paymentMode != 'Iya Bimbo'){
            junTotalProfitMade += double.parse(junReport[i].quantity) *
                (double.parse(junReport[i].unitPrice) - double.parse(junReport[i].costPrice));
            junTotalSales += double.parse(junReport[i].totalPrice);
          }
        }
        junLinearSales.month = 'Jun $year';
        junLinearSales.sales = junTotalSales;
        junLinearSales.profit = junTotalProfitMade;
        return junLinearSales;
      }
      break;

      case '7': {
        List<Reports> julReport = reportValue.getJulReport(reports, year: year);
        LinearSales julLinearSales = LinearSales();
        double julTotalProfitMade = 0.0;
        double julTotalSales = 0;
        for(int i = 0; i < julReport.length; i++){
          if(julReport[i].paymentMode != 'Iya Bimbo'){
            julTotalProfitMade += double.parse(julReport[i].quantity) *
                (double.parse(julReport[i].unitPrice) - double.parse(julReport[i].costPrice));
            julTotalSales += double.parse(julReport[i].totalPrice);
          }
        }
        julLinearSales.month = 'Jul $year';
        julLinearSales.sales = julTotalSales;
        julLinearSales.profit = julTotalProfitMade;
        return julLinearSales;
      }
      break;

      case '8': {
        List<Reports> augReport = reportValue.getAugReport(reports, year: year);
        LinearSales augLinearSales = LinearSales();
        double augTotalProfitMade = 0.0;
        double augTotalSales = 0;
        for(int i = 0; i < augReport.length; i++){
          if(augReport[i].paymentMode != 'Iya Bimbo'){
            augTotalProfitMade += double.parse(augReport[i].quantity) *
                (double.parse(augReport[i].unitPrice) - double.parse(augReport[i].costPrice));
            augTotalSales += double.parse(augReport[i].totalPrice);
          }
        }
        augLinearSales.month = 'Aug $year';
        augLinearSales.sales = augTotalSales;
        augLinearSales.profit = augTotalProfitMade;
        return augLinearSales;
      }
      break;

      case '9': {
        List<Reports> sepReport = reportValue.getSepReport(reports, year: year);
        LinearSales sepLinearSales = LinearSales();
        double sepTotalProfitMade = 0.0;
        double sepTotalSales = 0;
        for(int i = 0; i < sepReport.length; i++){
          if(sepReport[i].paymentMode != 'Iya Bimbo'){
            sepTotalProfitMade += double.parse(sepReport[i].quantity) *
                (double.parse(sepReport[i].unitPrice) - double.parse(sepReport[i].costPrice));
            sepTotalSales += double.parse(sepReport[i].totalPrice);
          }
        }
        sepLinearSales.month = 'Sep $year';
        sepLinearSales.sales = sepTotalSales;
        sepLinearSales.profit = sepTotalProfitMade;
        return sepLinearSales;
      }
      break;

      case '10': {
        List<Reports> octReport = reportValue.getOctReport(reports, year: year);
        LinearSales octLinearSales = LinearSales();
        double octTotalProfitMade = 0.0;
        double octTotalSales = 0;
        for(int i = 0; i < octReport.length; i++){
          if(octReport[i].paymentMode != 'Iya Bimbo'){
            octTotalProfitMade += double.parse(octReport[i].quantity) *
                (double.parse(octReport[i].unitPrice) - double.parse(octReport[i].costPrice));
            octTotalSales += double.parse(octReport[i].totalPrice);
          }
        }
        octLinearSales.month = 'Oct $year';
        octLinearSales.sales = octTotalSales;
        octLinearSales.profit = octTotalProfitMade;
        return octLinearSales;
      }
      break;

      case '11': {
        List<Reports> novReport = reportValue.getNovReport(reports, year: year);
        LinearSales novLinearSales = LinearSales();
        double novTotalProfitMade = 0.0;
        double novTotalSales = 0;
        for(int i = 0; i < novReport.length; i++){
          if(novReport[i].paymentMode != 'Iya Bimbo'){
            novTotalProfitMade += double.parse(novReport[i].quantity) *
                (double.parse(novReport[i].unitPrice) - double.parse(novReport[i].costPrice));
            novTotalSales += double.parse(novReport[i].totalPrice);
          }
        }
        novLinearSales.month = 'Nov $year';
        novLinearSales.sales = novTotalSales;
        novLinearSales.profit = novTotalProfitMade;
        return novLinearSales;
      }
      break;

      case '12': {
        List<Reports> decReport = reportValue.getDecReport(reports, year: year);
        LinearSales decLinearSales = LinearSales();
        double decTotalProfitMade = 0.0;
        double decTotalSales = 0;
        for(int i = 0; i < decReport.length; i++){
          if(decReport[i].paymentMode != 'Iya Bimbo'){
            decTotalProfitMade += double.parse(decReport[i].quantity) *
                (double.parse(decReport[i].unitPrice) - double.parse(decReport[i].costPrice));
            decTotalSales += double.parse(decReport[i].totalPrice);
          }
        }
        decLinearSales.month = 'Dec $year';
        decLinearSales.sales = decTotalSales;
        decLinearSales.profit = decTotalProfitMade;
        return decLinearSales;
      }
      break;

      default: {
        return null;
      }
      break;
    }

  }

  /// Method to get report of a year by accumulating the report of each month
  /// using the [LinearSales] model by calculating the [totalSales] as the
  /// sum of every [totalPrice] in the [DailyReportValue] if its [paymentMode]
  /// != 'Iya Bimbo' and also calculating the profit using [calculateProfit()] function
  /// It returns a list of [LinearSales]
  List<LinearSales> getYearReports(List<Reports> reports) {
    List<LinearSales> sales = List();
    var reportValue = DailyReportValue();

    List<DateTime> monthsAndYears = reportValue.getAllMonthsAndYears(reports);
    for(int i = 0; i < monthsAndYears.length; i ++){
      sales.add(getMonthAndYearReports(monthsAndYears[i].month.toString(), reports, year: monthsAndYears[i].year));
    }

    return sales;

  }

}


