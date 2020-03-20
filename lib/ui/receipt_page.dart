import 'package:ayolee_stores/database/DBHelper.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ayolee_stores/model/availableProductDB.dart';

class Receipt extends StatefulWidget {
  static const String id = 'receipt_page';

  final List<Map> sentProducts;

  Receipt({@required this.sentProducts});

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  String companyName = "Ayo-Lee Nigeria Enterprises";

  String address = "14, Leigh street Off Ojuelegba Road Surulere Lagos";

  String phoneNumber = "0802912565, 07033757855";

  String email = "farawebola@gmail.com";

  DateTime dateTime = DateTime.now();

  String buyersName;

  double totalPrice = 0.0;

  List<TableRow> items = [];

  List<Map> receivedProducts = [];

  DailyReportsData dailyReportsData = new DailyReportsData();

  double quantity, unitPrice, total;

  Map products = {};

  List<Map> productsList = [];

  Future<List<AvailableProduct>> getProductsFromDB() async {
    var dbHelper = DBHelper();
    Future<List<AvailableProduct>> availableProduct = dbHelper.getProducts();
    return availableProduct;
  }

  void availableProductNames() {
    Future<List<AvailableProduct>> productNames = getProductsFromDB();
    productNames.then((value) {
      for (int i = 0; i < value.length; i++) {
        print(value[i].productName);
        String name = value[i].productName;
        double qty = value[i].currentQuantity;
        products = {name: qty};
        productsList.add(products);
      }
    });
  }

  void addProducts() {
    for (var product in widget.sentProducts) {
      //print(product);
      if (product.isNotEmpty) {
        //print('incoming...');
        receivedProducts.add(product);
      }
    }
    //print(receivedProducts);
  }

  DataTable dataTable() {
    return DataTable(
      columnSpacing: 8.0,
      columns: [
        DataColumn(
          label: Text(
            'S/N',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
            label: Text(
          'QTY',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          'PRODUCT',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          'UNIT PRICE',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          'TOTAL PRICE',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ],
      rows: receivedProducts.map((product) {
        totalPrice += double.parse(product['totalPrice']);
        return DataRow(cells: [
          DataCell(
            Text((widget.sentProducts.indexOf(product) + 1).toString()),
          ),
          DataCell(
            Text(product['qty'].toString()),
          ),
          DataCell(
            Text(product['product'].toString()),
          ),
          DataCell(
            Text(product['unitPrice'].toString()),
          ),
          DataCell(
            Text(product['totalPrice'].toString()),
          ),
        ]);
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    addProducts();
    availableProductNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'SAVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  child: Container(
                    height: 150.0,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              "Are you sure the product you want to save is confirmed?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // To close the dialog
                                },
                                textColor: Colors.blueAccent,
                                child: Text('NO'),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // To close the dialog
                                  showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      elevation: 0.0,
                                      backgroundColor: Colors.white,
                                      child: Container(
                                        height: 150.0,
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16.0),
                                                child: Text(
                                                  "Select payment mode",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 24.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // To close the dialog
                                                      for (var product
                                                          in receivedProducts) {
                                                        try {
                                                          saveNewDailyReport(
                                                              double.parse(
                                                                  product[
                                                                      'qty']),
                                                              product[
                                                                  'product'],
                                                              double.parse(product[
                                                                  'unitPrice']),
                                                              double.parse(product[
                                                                  'totalPrice']),
                                                              "Transfer");
                                                        } catch (e) {
                                                          Fluttertoast.showToast(
                                                              msg: e.toString(),
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              textColor:
                                                                  Colors.black);
                                                          print(e);
                                                        }
                                                      }
                                                      Fluttertoast.showToast(
                                                          msg: "Items saved",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          backgroundColor:
                                                              Colors.white,
                                                          textColor:
                                                              Colors.black);
                                                      Navigator.pop(context);
                                                    },
                                                    textColor:
                                                        Colors.blueAccent,
                                                    child: Text('TRANSFER'),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // To close the dialog
                                                      for (var product
                                                      in receivedProducts) {
                                                        try {
                                                          saveNewDailyReport(
                                                              double.parse(
                                                                  product[
                                                                  'qty']),
                                                              product[
                                                              'product'],
                                                              double.parse(product[
                                                              'unitPrice']),
                                                              double.parse(product[
                                                              'totalPrice']),
                                                              "Cash");
                                                        } catch (e) {
                                                          Fluttertoast.showToast(
                                                              msg: e.toString(),
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              backgroundColor:
                                                              Colors.white,
                                                              textColor:
                                                              Colors.black);
                                                          print(e);
                                                        }
                                                      }
                                                      Fluttertoast.showToast(
                                                          msg: "Items saved",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          backgroundColor:
                                                          Colors.white,
                                                          textColor:
                                                          Colors.black);
                                                      Navigator.pop(context);
                                                    },
                                                    textColor:
                                                    Colors.blueAccent,
                                                    child: Text('CASH'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                textColor: Colors.blueAccent,
                                child: Text('YES'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.print,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  companyName,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 2.0,
              ),
              Container(
                child: Text(
                  address,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 2.0,
              ),
              Container(
                child: Text(
                  "Tel: $phoneNumber",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 2.0,
              ),
              Container(
                child: Text(
                  "Email: $email",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 2.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Container(
                            width: 150.0,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              onChanged: (value) {
                                buyersName = value;
                              },
                              decoration: InputDecoration(
                                hoverColor: Colors.black,
                                fillColor: Colors.black,
                                focusColor: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Text(
                        "Date: $dateTime",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[dataTable()],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                padding: EdgeInsets.only(right: 20.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'TOTAL = ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$totalPrice',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveNewDailyReport(double qty, String productName, double unitPrice,
      double total, String paymentMode) {
    var dailyReport = DailyReportsData();
    dailyReport.quantity = qty;
    dailyReport.productName = productName;
    dailyReport.unitPrice = unitPrice;
    dailyReport.totalPrice = total;
    dailyReport.paymentMode = paymentMode;
    dailyReport.time = DateTime.now().toString();

    var dbHelper = DBHelper();
    dbHelper.addNewDailyReport(dailyReport);
    for (int i = 0; i < productsList.length; i++){
      if(productsList[i].containsKey(productName)){
        print(productsList[i]);
        print(productsList[i][productName]);
        dbHelper.updateSales(productName, (productsList[i][productName] - qty));
      }
    }
  }
}
