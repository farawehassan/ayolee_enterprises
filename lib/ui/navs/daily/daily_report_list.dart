import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

// ignore: must_be_immutable
class DailyReportList extends StatelessWidget {

  static const String id = 'daily_report_list';

  var futureValue = FutureValues();

  Map data = {};

  List<Map> reports = [];

  Map products = {};

  List<Map> productsList = [];

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

  FlutterMoneyFormatter money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  String getFormattedTime(String dateTime) {
    return DateFormat('h:mm a').format(DateTime.parse(dateTime)).toString();
  }

  SingleChildScrollView dataTable(List<Map> salesList){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columnSpacing: 20.0,

        columns: [
          DataColumn(label: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('UNIT', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('PAYMENT', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('TIME', style: TextStyle(fontWeight: FontWeight.bold),)),
        ],
        rows: salesList.map((report) => DataRow(
            //selected: reports.contains(report),
//            onSelectChanged: (bool selected){
//              if (selected) {
//                print(report);
//                deleteReport(report);
//              }
//            },
            cells: [
              DataCell(
                Text(report['qty'].toString()),
              ),
              DataCell(
                Text(report['productName'].toString()),
              ),
              DataCell(
                Text(money(double.parse(report['unitPrice'])).output.symbolOnLeft.toString()),
              ),
              DataCell(
                Text(money(double.parse(report['totalPrice'])).output.symbolOnLeft.toString()),
              ),
              DataCell(
                Text(report['paymentMode'].toString()),
              ),
              DataCell(
                Text(getFormattedTime(report['time'])),
              ),
            ]
        )).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, d MMM').format(now);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Today\'s Sales'),
            Text(formattedDate),
          ],
        ),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: FutureBuilder(
                  future: futureValue.getTodayReports(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      for (int i = 0; i < snapshot.data.length; i++){
                        data = {'qty':'${snapshot.data[i].quantity}', 'productName': '${snapshot.data[i].productName}','unitPrice':'${snapshot.data[i].unitPrice}','totalPrice':'${snapshot.data[i].totalPrice}', 'paymentMode':'${snapshot.data[i].paymentMode}', 'time':'${snapshot.data[i].time}'};
                        reports.add(data);
                      }
                      return dataTable(reports);
                    }
                    else if(snapshot.data == null || snapshot.data.length == 0){
                      return Container(
                          alignment: AlignmentDirectional.center,
                          child: Text("No sales yet"));
                    }
                    return Container(
                      alignment: AlignmentDirectional.center,
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          )
      ),
    );
  }

  void deleteReport(Map report){
    var api = RestDataSource();
    api.deleteReport(report['id']);

    //TODO  DELETE

    for (int i = 0; i < productsList.length; i++) {
      if (productsList[i].containsKey(report['productName'])) {
        print(productsList[i]);
        print(productsList[i][report['productName']]);
        api.sellProduct(report['productName'], (productsList[i][report['productName']] + report['qty']).toString());
      }
    }
  }

}
