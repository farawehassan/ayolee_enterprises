import 'package:ayolee_stores/database/DBHelper.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ayolee_stores/utils/dailyReportValue.dart';

// ignore: must_be_immutable
class DailyReports extends StatelessWidget {

  static const String id = 'daily_reports';

  Map data = {};
  List<Map> reports = [];

  double totalSalesPrice = 0.0;
  double availableCash = 0.0;
  double totalTransfer = 0.0;

  Future<List<DailyReportsData>> getTodayReports() async {
    var reportValue = ReportValue();
    Future<List<DailyReportsData>> todayReport = reportValue.getTodayReport();
    return todayReport;
  }

  String getFormattedTime(String dateTime) {
    return DateFormat('H:m:s').format(DateTime.parse(dateTime)).toString();
  }

  SingleChildScrollView dataTable(List<Map> salesList){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          DataTable(
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
                cells: [
                  DataCell(
                    Text(report['qty'].toString()),
                  ),
                  DataCell(
                    Text(report['productName'].toString()),
                  ),
                  DataCell(
                    Text(report['unitPrice'].toString()),
                  ),
                  DataCell(
                    Text(report['totalPrice'].toString()),
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
          Container(
            margin: EdgeInsets.only(left: 5.0, right: 40.0),
            padding: EdgeInsets.only(right: 20.0, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'TOTAL = N',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$totalSalesPrice',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM').format(now);
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
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Expanded(
                child: FutureBuilder(
                  future: getTodayReports(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      for (int i = 0; i < snapshot.data.length; i++){
                        data = {'qty':'${snapshot.data[i].quantity}', 'productName': '${snapshot.data[i].productName}','unitPrice':'${snapshot.data[i].unitPrice}','totalPrice':'${snapshot.data[i].totalPrice}', 'paymentMode':'${snapshot.data[i].paymentMode}', 'time':'${snapshot.data[i].time}'};
                        if(snapshot.data[i].paymentMode == 'Cash'){
                          availableCash += snapshot.data[i].totalPrice;
                        }
                        else if(snapshot.data[i].paymentMode == 'Transfer'){
                          totalTransfer += snapshot.data[i].totalPrice;
                        }
                        print(data);
                        reports.add(data);
                      }
                      totalSalesPrice = availableCash + totalTransfer;
                      print(availableCash);
                      print(totalTransfer);
                      print(totalSalesPrice);
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
          ),
        ),
      ),
    );
  }
}