import 'package:ayolee_stores/model/linear_sales.dart';
import 'package:ayolee_stores/model/reportsDB.dart';
import 'package:ayolee_stores/model/store_details.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter/material.dart';
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

  /// A string variable holding the start date of taking reports
  String _startDate = '';

  /// A string variable holding the last date of taking reports
  String _endDate = '';

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
      Constants.showMessage(onError);
    });
  }

  /// This function calls [getYearReports()] method from my [futureValue] class
  /// It adds every total sales gotten to [details] and sum them to [totalSales]
  void getReports() async {
    _getStoreValues();
    Future<List<Reports>> report = futureValue.getAllReportsFromDB();
    await report.then((value) {
      List<LinearSales> sales = futureValue.getYearReports(value);
      if (!mounted) return;
      setState(() {
        _startDate = sales.first.month;
        _endDate = sales.last.month;
        for(int i = 0; i < sales.length; i++){
          details.add(sales[i].sales);
        }
      });
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
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
        padding: EdgeInsets.all(24.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  _startDate,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white70,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  Constants.money(totalSales),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white70,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  _endDate,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: _buildLineChart(),
            ),
          ),
        ],
      ),
    );
  }

}


