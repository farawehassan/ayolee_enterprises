import 'package:ayolee_stores/model/linear_sales.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter/material.dart';
import 'future_values.dart';

class Sales {
  final String year;
  final int sales;

  Sales(this.year, this.sales);
}

class PointsLineChart extends StatefulWidget {

  static const String id = 'point_line_chart';

  @override
  _PointsLineChartState createState() => _PointsLineChartState();

}

class _PointsLineChartState extends State<PointsLineChart> {

  var futureValue = FutureValues();

  bool animate;

  List<double> details = [];
  double totalSales = 0;

  FlutterMoneyFormatter money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  void getReports() async {
    Future<List<LinearSales>> report = futureValue.getYearReports();
    await report.then((value) {
      setState(() {
        for(int i = 0; i < value.length; i++){
          details.add(value[i].sales);
          totalSales += value[i].sales;
        }
      });
    });
  }

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
}


