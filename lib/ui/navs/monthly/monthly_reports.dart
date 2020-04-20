import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ayolee_stores/bloc/monthly_report_charts.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';

// ignore: must_be_immutable
class MonthReport extends StatefulWidget {

  MonthReport({@required this.month});

  static const String id = 'month_reports';
  final String month;

  @override
  _MonthReportState createState() => _MonthReportState();
}

class _MonthReportState extends State<MonthReport> {

  var futureValue = FutureValues();

  //List<Map> reports = [];

  double totalSalesPrice = 0.0;

  double availableCash = 0.0;

  double totalTransfer = 0.0;

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<Map> sales = new List();
  List<Map> filteredSales= new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Sales Report');

  _MonthReportState(){
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredSales = sales;
        });
      }
      else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void _getSales() async {
    List<Map> tempList = new List();
    Future<List<DailyReportsData>> dailySales = futureValue.getMonthReports(widget.month);
    await dailySales.then((value) {
      Map details = {};
      for (int i = 0; i < value.length; i++){
        details = {'qty':'${value[i].quantity}', 'productName': '${value[i].productName}','unitPrice':'${value[i].unitPrice}','totalPrice':'${value[i].totalPrice}', 'paymentMode':'${value[i].paymentMode}', 'time':'${value[i].time}'};
        if(value[i].paymentMode == 'Cash'){
          availableCash += double.parse(value[i].totalPrice);
        }
        else if(value[i].paymentMode == 'Transfer'){
          totalTransfer += double.parse(value[i].totalPrice);
        }
        tempList.add(details);
      }
      totalSalesPrice = availableCash + totalTransfer;
    });
    setState(() {
      sales = tempList;
      filteredSales = sales;
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...'
          ),
        );
      }
      else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Sales Report');
        filteredSales = sales;
        _filter.clear();
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = '${widget.month}, ${DateFormat('yyyy').format(now)}';
    return new AppBar(
      centerTitle: false,
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              formattedDate,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List<Map> tempList = new List();
      for (int i = 0; i < filteredSales.length; i++) {
        if (getFormattedTime(filteredSales[i]['time']).toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredSales[i]);
        }
      }
      filteredSales = tempList;
    }
    if(filteredSales == null || filteredSales.length == 0){
      return Container(
          alignment: AlignmentDirectional.center,
          child: Text("No sales yet"));
    }
    else if(filteredSales.length > 0){
      return dataTable(filteredSales);
    }
    return Container(
      alignment: AlignmentDirectional.center,
      child: CircularProgressIndicator(),
    );
  }

  FlutterMoneyFormatter money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  String getFormattedTime(String dateTime) {
    return DateFormat('EEE, MMM d, h:mm a').format(DateTime.parse(dateTime)).toString();
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
                    Text(money(double.parse(report['unitPrice'])).output.symbolOnLeft),
                  ),
                  DataCell(
                    Text(money(double.parse(report['totalPrice'])).output.symbolOnLeft),
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
                  'TOTAL = ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${money(totalSalesPrice).output.symbolOnLeft}',
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
  void initState() {
    _getSales();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildList(),
              SizedBox(height: 60.0,),
              MonthlyReportCharts(month: widget.month,),
            ],
          ),
        ),
      ),
    );
  }

}