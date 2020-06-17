import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:ayolee_stores/ui/receipt/printing_receipt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';

/// A StatefulWidget class that displays receipt of items recorded
class Receipt extends StatefulWidget {

  static const String id = 'receipt_page';

  /// Passing the products recorded in this class constructor
  final List<Map> sentProducts;

  Receipt({@required this.sentProducts});

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Variable holding the company's name
  String companyName = "Ayo-Lee Stores";

  /// Variable holding the company's address
  String address = "14, Leigh street Off Ojuelegba Road Surulere Lagos";

  /// Variable holding the company's phone number
  String phoneNumber = "0802912565, 07033757855";

  /// Variable holding the company's email
  String email = "farawebola@gmail.com";

  /// Variable holding today's datetime
  DateTime dateTime = DateTime.now();

  /// Variable holding the buyer's name
  String buyersName;

  /// Variable holding the total price
  double totalPrice = 0.0;

  /// A List to hold the widget [TableRow] for my products
  List<TableRow> items = [];

  /// A List to hold the Map of [receivedProducts]
  List<Map> receivedProducts = [];

  /// Instantiating a class of the [DailyReportsData]
  DailyReportsData dailyReportsData = new DailyReportsData();

  /// A Map to hold the product's name to its current quantity
  Map products = {};

  /// A List to hold the Map of the data above
  List<Map> productsList = [];

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  String _getFormattedTime(String dateTime) {
    return DateFormat('h:mm a').format(DateTime.parse(dateTime)).toString();
  }

  /// Convert a double [value] to naira
  FlutterMoneyFormatter _money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  /// Function to fetch all the available product's names from the database to
  /// [availableProducts]
  void _availableProductNames() {
    Future<List<AvailableProduct>> productNames = futureValue.getProductFromDB();
    productNames.then((value) {
      for (int i = 0; i < value.length; i++) {
        print(value[i].productName);
        String name = value[i].productName;
        double qty = double.parse(value[i].currentQuantity);
        products = {name: qty};
        productsList.add(products);
      }
    });
  }

  /// This adds the product details [sentProducts] to [receivedProducts] if it's
  /// not empty and calculate the total price [totalPrice]
  void _addProducts() {
    for (var product in widget.sentProducts) {
      if (product.isNotEmpty
          && product.containsKey('qty')
          && product.containsKey('product')
          && product.containsKey('unitPrice')
          && product.containsKey('totalPrice')
      )  {
        receivedProducts.add(product);
        totalPrice += double.parse(product['totalPrice']);
      }
    }
  }

  /// Creating a [DataTable] widget from a List of Map [receivedProducts]
  /// using QTY, PRODUCT, UNIT, TOTAL, PAYMENT, TIME as DataColumn and
  /// the values of each DataColumn in the [receivedProducts] as DataRows
  Widget _dataTable() {
    return DataTable(
      columnSpacing: 1.0,
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
            Text(_money(double.parse(product['unitPrice'])).output.symbolOnLeft.toString()),
          ),
          DataCell(
            Text(_money(double.parse(product['totalPrice'])).output.symbolOnLeft.toString()),
          ),
        ]);
      }).toList(),
    );
  }

  /// Calls [_addProducts()] and [_availableProductNames()]
  /// before the class builds its widgets
  @override
  void initState() {
    super.initState();
    _addProducts();
    _availableProductNames();
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
                barrierDismissible: false,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  child: Container(
                    height: 200.0,
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
                                    barrierDismissible: false,
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
                                                      _saveProduct('Iya Bimbo');
                                                    },
                                                    textColor: Colors.blueAccent,
                                                    child: Text('Iya Bimbo'),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // To close the dialog
                                                      _saveProduct('Transfer');
                                                    },
                                                    textColor:
                                                        Colors.blueAccent,
                                                    child: Text('Transfer'),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // To close the dialog
                                                      _saveProduct('Cash');
                                                    },
                                                    textColor:
                                                    Colors.blueAccent,
                                                    child: Text('Cash'),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrintingReceipt(sentProducts: receivedProducts)),
              );
            },
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
              Container(
                padding: EdgeInsets.all(2.0),
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
                        "Date: ${_getFormattedTime(dateTime.toString())}",
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
                  children: <Widget>[_dataTable()],
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
                      '${_money(totalPrice).output.symbolOnLeft.toString()}',
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

  /// Using flutter toast to display a toast message [message]
  void _showMessage(String message){
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black);
  }

  /// This function calls [saveNewDailyReport()] with the details in
  /// [receivedProducts]
  void _saveProduct(String paymentMode){
    if(receivedProducts.length > 0 && receivedProducts.isNotEmpty){
      for (var product in receivedProducts) {
        try {
          _saveNewDailyReport(
              double.parse(
                  product[
                  'qty']),
              product[
              'product'],
              double.parse(product[
              'unitPrice']),
              double.parse(product[
              'totalPrice']),
              paymentMode);
        } catch (e) {
          _showMessage(e.toString());
          print(e);
        }
      }
      _showMessage("Items saved");
      Navigator.pop(context);
    }
    else {
      _showMessage("Empty receipt");
      Navigator.pop(context);
    }
  }

  /// Function that adds new report to the database by calling
  /// [addNewDailyReport] in the [RestDataSource] class
  void _saveNewDailyReport(double qty, String productName, double unitPrice,
      double total, String paymentMode) async {
    var api = RestDataSource();
    var dailyReport = DailyReportsData();
    dailyReport.quantity = qty.toString();
    dailyReport.productName = productName.toString();
    dailyReport.unitPrice = unitPrice.toString();
    dailyReport.totalPrice = total.toString();
    dailyReport.paymentMode = paymentMode;
    dailyReport.time = DateTime.now().toString();
    try {
      for (int i = 0; i < productsList.length; i++){
        if(productsList[i].containsKey(productName)){
          print(productsList[i]);
          print(productsList[i][productName]);
          Future<String> message = api.sellProduct(productName, (productsList[i][productName] - qty).toString());
          await message.then((value){
            api.addNewDailyReport(dailyReport);
          }).catchError((e){
            _showMessage("Error in saving $productName");
            print(e);
          });
        }
      }
    } catch (e) {
      print(e);
      _showMessage("Error in saving $productName");
    }

  }
}
