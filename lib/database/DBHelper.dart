import 'package:ayolee_stores/model/availableProductDB.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io' as io;

class DBHelper{

  final String AVAILABLE_PRODUCT_TABLE = "AvailableProducts";
  final String DAILY_REPORT_TABLE = "DailyReports";
  static Database db_instance;

  Future<Database> get db async {
    if(db_instance == null){
      db_instance = await initDB();
    }
    return db_instance;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ayoleeTest1.db");
    var db = await openDatabase(path, version: 1, onCreate: onCreateFunc);
    return db;
  }

  /**
   * AvailableProduct's Table and its functions
   * Insert, Modify, Delete
   */

  /// Create Table
  void onCreateFunc(Database db, int version) async {
    await db.execute('CREATE TABLE $AVAILABLE_PRODUCT_TABLE ('
        'productName TEXT PRIMARY KEY,'
        'costPrice FLOAT(24) NOT NULL,'
        'sellingPrice FLOAT(24) NOT NULL,'
        'initialQty FLOAT(24) NOT NULL,'
        'currentQty FLOAT(24) NOT NULL'
        ');'
    );

    await db.execute('CREATE TABLE $DAILY_REPORT_TABLE ('
        'qty FLOAT(24),'
        'productName TEXT NOT NULL,'
        'unitPrice FLOAT(24) NOT NULL,'
        'totalPrice FLOAT(24) NOT NULL,'
        'paymentMode TEXT NOT NULL,'
        'time TEXT NOT NULL'
        ');'
    );
  }

  /// CRUD FUNCTIONS FOR AVAILABLE PRODUCT TABLE

  // Get all available products
  Future<List<AvailableProduct>> getProducts () async {
    var dbConnection = await db;
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $AVAILABLE_PRODUCT_TABLE');
    List<AvailableProduct> products = new List();
    for(int i = 0; i < list.length; i++){
      AvailableProduct product = new AvailableProduct();
      product.productName = list[i]['productName'];
      product.costPrice = list[i]['costPrice'];
      product.sellingPrice = list[i]['sellingPrice'];
      product.initialQuantity = list[i]['initialQty'];
      product.currentQuantity = list[i]['currentQty'];

      products.add(product);
    }
    return products;
  }

  /// Add new product
  void addNewAvailableProduct(AvailableProduct product) async {
    var dbConnection = await db;
    String rawQuery = 'INSERT INTO $AVAILABLE_PRODUCT_TABLE(productName, costPrice, sellingPrice, initialQty, currentQty) '
        'VALUES(\'${product.productName}\', \'${product.costPrice}\', '
        '\'${product.sellingPrice}\', \'${product.initialQuantity}\','
        ' \'${product.currentQuantity}\')';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(rawQuery);
    });
  }

  /// Modify product
  void updateAvailableProduct(AvailableProduct product) async {
    var dbConnection = await db;
    String rawQuery = 'UPDATE $AVAILABLE_PRODUCT_TABLE SET costPrice = \'${product.costPrice}\', sellingPrice = \'${product.sellingPrice}\', '
        'initialQty = \'${product.initialQuantity}\', currentQty = \'${product.currentQuantity}\' '
        'WHERE productName = \'${product.productName}\' ';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(rawQuery);
    });
  }

  void updateSales(String name, double qty) async {
    var dbConnection = await db;
    String rawQuery = 'UPDATE $AVAILABLE_PRODUCT_TABLE SET currentQty = \'$qty\' '
        'WHERE productName = \'$name\' ';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(rawQuery);
    });
  }

  /// Delete product
  void deleteAvailableProduct(AvailableProduct product) async {
    var dbConnection = await db;
    String rawQuery = 'DELETE FROM $AVAILABLE_PRODUCT_TABLE WHERE productName = \'${product.productName}\'';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(rawQuery);
    });
  }

  /*****************************************************************************/

  /// CRUD FUNCTIONS FOR DAILY REPORTS TABLE

  // Get all available products
  Future<List<DailyReportsData>> getDailyReports () async {
    var dbConnection = await db;
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $DAILY_REPORT_TABLE');
    List<DailyReportsData> data = new List();
    for(int i = 0; i < list.length; i++){
      DailyReportsData reportsData = new DailyReportsData();
      reportsData.quantity = list[i]['qty'];
      reportsData.productName = list[i]['productName'];
      reportsData.unitPrice = list[i]['unitPrice'];
      reportsData.totalPrice = list[i]['totalPrice'];
      reportsData.paymentMode = list[i]['paymentMode'];
      reportsData.time = list[i]['time'];

      data.add(reportsData);
    }
    return data;
  }

  /// Add new data
  void addNewDailyReport(DailyReportsData dailyReportsData) async {
    var dbConnection = await db;
    String rawQuery = 'INSERT INTO $DAILY_REPORT_TABLE(qty, productName, unitPrice, totalPrice, paymentMode, time) '
        'VALUES(\'${dailyReportsData.quantity}\', \'${dailyReportsData.productName}\', '
        '\'${dailyReportsData.unitPrice}\', \'${dailyReportsData.totalPrice}\','
        ' \'${dailyReportsData.paymentMode}\', \'${dailyReportsData.time}\')';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(rawQuery);
    });
  }

  /// Delete product
  void deleteDailyReport(DailyReportsData dailyReportsData) async {
    var dbConnection = await db;
    String rawQuery = 'DELETE FROM $AVAILABLE_PRODUCT_TABLE WHERE productName = \'${dailyReportsData.productName}\'';
    await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(rawQuery);
    });
  }

}

