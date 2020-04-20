import 'dart:typed_data';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:ayolee_stores/ui/navs/home_page.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_printer/esc_pos_printer.dart';

class PrintingReceipt extends StatefulWidget {

  static const String id = 'printing_receipt';

  final List<Map> sentProducts;

  PrintingReceipt({@required this.sentProducts});

  @override
  _PrintingReceiptState createState() => _PrintingReceiptState();
}

class _PrintingReceiptState extends State<PrintingReceipt> {

  var futureValue = FutureValues();
  List<Map> receivedProducts = [];
  Map products = {};
  List<Map> productsList = [];
  double totalPrice = 0.0;

  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];

  void addProducts() {
    for (var product in widget.sentProducts) {
      if (product.isNotEmpty)  {
        receivedProducts.add(product);
        totalPrice += double.parse(product['totalPrice']);
      }
    }
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

  @override
  void initState() {
    super.initState();
    addProducts();
    availableProductNames();
  }

  FlutterMoneyFormatter money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  Future<Ticket> showReceipt() async{
    Ticket ticket = Ticket(PaperSize.mm58);

    // Print image
    final ByteData data = await rootBundle.load('Assets/images/ayole-logo.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    ticket.image(image);

    ticket.text('AYO-LEE ENTERPRISES',
        styles: PosStyles(
          align: PosTextAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    ticket.text('14, Leigh street Off Ojuelegba Road', styles: PosStyles(align: PosTextAlign.center));
    ticket.text('Surulere Lagos', styles: PosStyles(align: PosTextAlign.center));
    ticket.text('0802912565, 07033757855', styles: PosStyles(align: PosTextAlign.center));
    ticket.text('farawebola@gmail.com',
        styles: PosStyles(align: PosTextAlign.center), linesAfter: 1);
    ticket.emptyLines(1);

    ticket.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 7),
      PosColumn(
          text: 'Price', width: 2, styles: PosStyles(align: PosTextAlign.right)),
      PosColumn(
          text: 'Total', width: 2, styles: PosStyles(align: PosTextAlign.right)),
    ]);

    for(var item in receivedProducts){
      ticket.row([
        PosColumn(text: '${item['qty']}', width: 1),
        PosColumn(text: '${item['product']}', width: 7),
        PosColumn(
            text: '${item['unitPrice']}', width: 2, styles: PosStyles(align: PosTextAlign.right)),
        PosColumn(
            text: '${item['totalPrice']}', width: 2, styles: PosStyles(align: PosTextAlign.right)),
      ]);
    }

    ticket.emptyLines(1);

    ticket.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: '${money(totalPrice).output.symbolOnLeft}',
          width: 6,
          styles: PosStyles(
            align: PosTextAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    ticket.emptyLines(2);
    //ticket.hr(ch: '=', linesAfter: 1);

    ticket.feed(2);
    ticket.text('Thank you!',
        styles: PosStyles(align: PosTextAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    ticket.text(timestamp, styles: PosStyles(align: PosTextAlign.center), linesAfter: 2);

    ticket.feed(2);
    ticket.cut();
    return ticket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Printer"),
      ),
      body: ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context,position){
          return ListTile(
            onTap: () async {
              printerManager.selectPrinter(_devices[position]);
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
                              "Are you sure the product you want to print is confirmed?",
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
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // To close the dialog
                                                      showReceipt().then((ticketValue){
                                                        printerManager.printTicket(ticketValue).then((result) {
                                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(result.msg)));
                                                          if(result.msg == "Success"){
                                                            saveProduct("Iya Bimbo");
                                                          }
                                                        }).catchError((error){
                                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                                                        });
                                                      });
                                                    },
                                                    textColor: Colors.blueAccent,
                                                    child: Text('Iya Bimbo'),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // To close the dialog
                                                      showReceipt().then((ticketValue){
                                                        printerManager.printTicket(ticketValue).then((result) {
                                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(result.msg)));
                                                          if(result.msg == "Success"){
                                                            saveProduct("Transfer");
                                                          }
                                                        }).catchError((error){
                                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                                                        });
                                                      });
                                                    },
                                                    textColor: Colors.blueAccent,
                                                    child: Text('Transfer'),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // To close the dialog
                                                      showReceipt().then((ticketValue){
                                                        printerManager.printTicket(ticketValue).then((result) {
                                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(result.msg)));
                                                          if(result.msg == "Success"){
                                                            saveProduct("Cash");
                                                          }
                                                        }).catchError((error){
                                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                                                        });
                                                      });
                                                    },
                                                    textColor: Colors.blueAccent,
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
            title: Text(_devices[position].name),
            subtitle: Text(_devices[position].address),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        printerManager.startScan(Duration(seconds: 4));
        printerManager.scanResults.listen((scannedDevices) {
          setState(() {
            _devices = scannedDevices;
          });
          if(_devices.isEmpty){
            showMessage('No Available Printer');
          }
        });
      },child: Icon(Icons.search),),
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
    Navigator.pushReplacementNamed(context, MyHomePage.id);
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