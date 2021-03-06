import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:ayolee_stores/model/reportsDB.dart';
import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:ayolee_stores/ui/receipt/printing_receipt.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:ayolee_stores/utils/size_config.dart';
import 'package:flutter/material.dart';
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
  String _companyName = "Ayo-Lee Stores";

  /// Variable holding the company's address
  String _address = "14, Leigh street Off Ojuelegba Road Surulere Lagos";

  /// Variable holding the company's phone number
  String _phoneNumber = "0802912565, 07033757855";

  /// Variable holding the company's email
  String _email = "farawebola@gmail.com";

  /// Variable holding today's datetime
  DateTime _dateTime = DateTime.now();

  /// Variable holding the total price
  double _totalPrice = 0.0;

  /// A List to hold the Map of [receivedProducts]
  List<Map> _receivedProducts = [];

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  String _getFormattedTime(String dateTime) {
    return DateFormat('h:mm a').format(DateTime.parse(dateTime)).toString();
  }

  /// Converting [dateTime] in string format to return a formatted time
  /// of weekday, month, day and year
  String _getFormattedDate(String dateTime) {
    return DateFormat('MMM d, ''yyyy').format(DateTime.parse(dateTime)).toString();
  }

  /// This adds the product details [sentProducts] to [_receivedProducts] if it's
  /// not empty and calculate the total price [_totalPrice]
  void _addProducts() {
    for (var product in widget.sentProducts) {
      if (product.isNotEmpty
          && product.containsKey('qty')
          && product.containsKey('product')
          && product.containsKey('costPrice')
          && product.containsKey('unitPrice')
          && product.containsKey('totalPrice')
      )  {
        _receivedProducts.add(product);
        _totalPrice += double.parse(product['totalPrice']);
      }
    }
  }

  /// Creating a [DataTable] widget from a List of Map [receivedProducts]
  /// using QTY, PRODUCT, UNIT, TOTAL, PAYMENT, TIME as DataColumn and
  /// the values of each DataColumn in the [receivedProducts] as DataRows
  Container _dataTable() {
    return Container(
      width: SizeConfig.safeBlockHorizontal * 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DataTable(
            columnSpacing: 5.0,
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
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              DataColumn(
                  label: Text(
                    'TOTAL PRICE',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
            rows: _receivedProducts.map((product) {
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
                  Text(Constants.money(double.parse(product['unitPrice']))),
                ),
                DataCell(
                  Text(Constants.money(double.parse(product['totalPrice']))),
                ),
              ]);
            }).toList(),
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
                  '${Constants.money(_totalPrice)}',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// This function contains the details of the store such as [_companyName],
  /// [_address], [_phoneNumber], [_email]
  Container _storeDetails(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
                _companyName,
                style: TextStyle(
                  fontSize: 26.0,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                )
            ),
          ),
          Container(
            padding: EdgeInsets.all(2.0),
            child: Text(
              _address,
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
              "Tel: $_phoneNumber",
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
              "Email: $_email",
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
                  child: Text(
                    "Date: ${_getFormattedDate(_dateTime.toString())}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Time: ${_getFormattedTime(_dateTime.toString())}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Calls [_addProducts()] before the class builds its widgets
  @override
  void initState() {
    super.initState();
    _addProducts();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                  child: Container(
                    width: SizeConfig.safeBlockHorizontal * 60,
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
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                                      child: Container(
                                        width: SizeConfig.safeBlockHorizontal * 60,
                                        height: 120.0,
                                        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Select payment mode",
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pop(); // To close the dialog
                                                    _saveProduct('Iya Bimbo');
                                                  },
                                                  child: Text(
                                                    'Iya Bimbo',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blueAccent,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pop(); // To close the dialog
                                                    _saveProduct('Transfer');
                                                  },
                                                  child: Text(
                                                    'Transfer',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blueAccent,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pop(); // To close the dialog
                                                    _saveProduct('Cash');
                                                  },
                                                  child: Text(
                                                    'Cash',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blueAccent,
                                                    ),
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
                MaterialPageRoute(builder: (context) => PrintingReceipt(sentProducts: widget.sentProducts)),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                _storeDetails(),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[_dataTable()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// This function calls [saveNewDailyReport()] with the details in
  /// [receivedProducts]
  void _saveProduct(String paymentMode) async {
    if(_receivedProducts.length > 0 && _receivedProducts.isNotEmpty){
      for (var product in _receivedProducts) {
        try {
          await _saveNewDailyReport(
              double.parse(
                  product[
                  'qty']),
              product[
              'product'],
              double.parse(product[
              'costPrice']),
              double.parse(product[
              'unitPrice']),
              double.parse(product[
              'totalPrice']),
              paymentMode)
              .then((value){
            Constants.showMessage("${product['product']} was sold successfully");
          });
        } catch (e) {
          print(e);
          Constants.showMessage(e.toString());
        }
      }
      Navigator.pop(context);
    }
    else {
      Constants.showMessage("Empty receipt");
      Navigator.pop(context);
    }
  }

  /// Function that adds new report to the database by calling
  /// [addNewDailyReport] in the [RestDataSource] class
  Future<void> _saveNewDailyReport(double qty, String productName, double costPrice, double unitPrice,
      double total, String paymentMode) async {
    try {
      var api = RestDataSource();
      var dailyReport = Reports();
      dailyReport.quantity = qty.toString();
      dailyReport.productName = productName.toString();
      dailyReport.costPrice = costPrice.toString();
      dailyReport.unitPrice = unitPrice.toString();
      dailyReport.totalPrice = total.toString();
      dailyReport.paymentMode = paymentMode;
      dailyReport.createdAt = _dateTime.toString();

      await api.addNewDailyReport(dailyReport).then((value) {
        print('$productName saved successfully');
      }).catchError((e) {
        print(e);
        throw (e);
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

}
