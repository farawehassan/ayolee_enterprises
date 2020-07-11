import 'package:ayolee_stores/model/linear_sales.dart';
import 'package:ayolee_stores/model/store_details.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'future_values.dart';

/// A StatefulWidget class creating a point line chart for my yearly report records
class PointsLineChart extends StatefulWidget {

  static const String id = 'point_line_chart';

  @override
  _PointsLineChartState createState() => _PointsLineChartState();

}

class _PointsLineChartState extends State<PointsLineChart> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A variable holding the list total sales from my [LinearSales] model
  List<double> details = [];

  /// A variable holding my total sales value so far
  double totalSales = 0;

  /// Convert a double [value] to naira
  FlutterMoneyFormatter money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  /// A function to set the value for [totalSales]
  /// from the [StoreDetails] model fetching from the database
  void _getStoreValues() async {
    Future<StoreDetails> details = futureValue.getStoreDetails();
    await details.then((value) {
      if (!mounted) return;
      setState(() {
        totalSales = value.totalSalesMade;
      });
    }).catchError((onError){
      _showMessage(onError);
    });
  }

  /// This function calls [getYearReports()] method from my [futureValue] class
  /// It adds every total sales gotten to [details] and sum them to [totalSales]
  void getReports() async {
    _getStoreValues();
    Future<List<LinearSales>> report = futureValue.getYearReports();
    await report.then((value) {
      if (!mounted) return;
      setState(() {
        for(int i = 0; i < value.length; i++){
          details.add(value[i].sales);
        }
      });
    }).catchError((onError){
      _showMessage(onError);
    });
  }

  /// Function to build my line chart if details is not empty and it's length is
  /// > 0 using flutter_sparkline package
  Widget _buildLineChart(){
    if(details.length > 0 && details.isNotEmpty){
      return Sparkline(
        data: details,
        lineColor: Colors.lightBlueAccent,
        fillMode: FillMode.below,
        fillColor: Colors.white70,
        pointsMode: PointsMode.all,
        pointSize: 5.0,
        pointColor: Colors.white70,
      );
    }
    else{
      Container();
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[300]),
        ),
      ),
    );
  }

  /// It calls [getReports()] while initializing my state
  @override
  void initState() {
    super.initState();
    getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(1.0),
            child: Text(
              money(totalSales).output.symbolOnLeft,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white70,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildLineChart(),
          ),
        ],
      ),
    );
  }

  /// Using flutter toast to display a toast message [message]
  void _showMessage(String message){
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black
    );
  }

}


