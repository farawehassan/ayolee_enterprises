import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:ayolee_stores/ui/receipt/printing_receipt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';

class Receipt extends StatefulWidget {
  static const String id = 'receipt_page';

  final List<Map> sentProducts;

  Receipt({@required this.sentProducts});

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {

  var futureValue = FutureValues();

  String companyName = "Ayo-Lee Enterprises";

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

  String getFormattedTime(String dateTime) {
    return DateFormat('h:mm a').format(DateTime.parse(dateTime)).toString();
  }

  FlutterMoneyFormatter money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  void availableProductNames() {
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

  void addProducts() {
    for (var product in widget.sentProducts) {
      if (product.isNotEmpty && product.containsKey('qty') && product.containsKey('product') && product.containsKey('unitPrice') && product.containsKey('totalPrice'))  {
        receivedProducts.add(product);
        totalPrice += double.parse(product['totalPrice']);
      }
    }
  }

  Widget dataTable() {
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
            Text(money(double.parse(product['unitPrice'])).output.symbolOnLeft.toString()),
          ),
          DataCell(
            Text(money(double.parse(product['totalPrice'])).output.symbolOnLeft.toString()),
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
                                                      saveProduct('Iya Bimbo');
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
                                                      saveProduct('Transfer');
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
                                                      saveProduct('Cash');
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
                        "Date: ${getFormattedTime(dateTime.toString())}",
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
                      '${money(totalPrice).output.symbolOnLeft.toString()}',
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

  void showMessage(String message){
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black);
  }

  void saveProduct(String paymentMode){
    for (var product in receivedProducts) {
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
            paymentMode);
      } catch (e) {
        showMessage(e.toString());
        print(e);
      }
    }
    showMessage("Items saved");
    Navigator.pop(context);
  }

  void saveNewDailyReport(double qty, String productName, double unitPrice,
      double total, String paymentMode) {
    try {
      var dailyReport = DailyReportsData();
      dailyReport.quantity = qty.toString();
      dailyReport.productName = productName.toString();
      dailyReport.unitPrice = unitPrice.toString();
      dailyReport.totalPrice = total.toString();
      dailyReport.paymentMode = paymentMode;
      dailyReport.time = DateTime.now().toString();
      print(dailyReport.time);

      var api = RestDataSource();
      api.addNewDailyReport(dailyReport);
      for (int i = 0; i < productsList.length; i++){
        if(productsList[i].containsKey(productName)){
          print(productsList[i]);
          print(productsList[i][productName]);
          api.sellProduct(productName, (productsList[i][productName] - qty).toString());
        }
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error in saving data",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black);
    }
  }
}
