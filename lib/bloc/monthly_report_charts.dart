import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:flutter/material.dart';
import 'package:ayolee_stores/bloc/daily_report_value.dart';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

/// A StatefulWidget class creating a pie chart for my monthly report records
class MonthlyReportCharts extends StatefulWidget {

  static const String id = 'monthly_report_charts';

  /// Passing the month to load its data in this class constructor
  final String month;

  MonthlyReportCharts({@required this.month});

  @override
  _MonthlyReportChartsState createState() => _MonthlyReportChartsState();
}

class _MonthlyReportChartsState extends State<MonthlyReportCharts> {

  /// Instantiating a class of the [DailyReportValue]
  var reportValue = DailyReportValue();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A variable holding the list of primary colors and accents colors
  List<Color> colours = (Colors.primaries.cast<Color>() + Colors.accents.cast<Color>());

  /// A variable holding my daily report data as a map
  var data = {};

  /// Creating a map to my [data]'s product name to it's quantity for my charts
  Map<String, double> dataMap = new Map();

  /// A variable holding the list of colors needed for my pie chart
  List<Color> colorList = [];

  /// A variable holding the total profit made
  double totalProfitMade = 0.0;

  /// A variable holding the length my daily report data
  int _dataLength;

  /// Variable to hold the name of the user logged in
  String username;

  /// Setting the current user's name logged in to [_username]
  void getCurrentUser() async {
    await futureValue.getCurrentUser().then((user) {
      username = user.name;
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  /// Convert a double [value] to naira
  FlutterMoneyFormatter money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  /// Function to get this [month] report and map [data] it's product name to
  /// its quantity accordingly
  /// It also calls the function [getColors()]
  void getReports() async {
    print(widget.month);
    Future<List<DailyReportsData>> report = futureValue.getMonthReports(widget.month);
    await report.then((value) {
      if (!mounted) return;
      setState(() {
        _dataLength = value.length;
        for(int i = 0; i < value.length; i++){
          calculateProfit(value[i]);
          if(data.containsKey(value[i].productName)){
            data[value[i].productName] = (double.parse(data[value[i].productName]) + double.parse(value[i].quantity)).toString();
          }else{
            data[value[i].productName] = '${value[i].quantity}';
          }
        }
        print(data);
      });
    });
    getColors();
  }

  /// Method to calculate profit made of a report by deducting the report's
  /// [unitPrice] from the product's [costPrice] and multiplying the value by the
  /// report's [quantity]
  /// It is done if the report's [paymentMode] is not 'Iya Bimbo'
  /// or else it returns 0
  void calculateProfit(DailyReportsData data) async {
    double profitMade = 0.0;
    Future<List<AvailableProduct>> products = futureValue.getProductFromDB();
    await products.then((value) {
      print(value);
      for (int i = 0; i < value.length; i++){
        if(value[i].productName == data.productName){
          if(data.paymentMode != 'Iya Bimbo'){
            double profit = double.parse(data.unitPrice) - double.parse(value[i].costPrice);
            profitMade += (double.parse(data.quantity) * profit);
            print(profit);
          }
          print(profitMade);
        }
      }
      if (!mounted) return;
      setState(() {
        totalProfitMade += profitMade;
      });
    });
  }

  /// Function to get the amount of colors needed for the pie chart and map
  /// [data] to [dataMap]
  void getColors() {
    for(int i = 0; i < data.length; i++){
      colorList.add(colours[i]);
    }
    data.forEach((k,v) {
      dataMap.putIfAbsent("$k", () => double.parse('$v'));
    });
  }

  /// It calls [getReports()] and [getCurrentUser()] while initializing my state
  @override
  void initState() {
    super.initState();
    getReports();
    getCurrentUser();
  }

  /// Function to build my pie chart if dataMap is not empty and it's length is
  /// > 0 using pie_chart package
  Widget _buildChart(){
    if(dataMap.length > 0 && dataMap.isNotEmpty){
      return PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32.0,
        chartRadius: MediaQuery.of(context).size.width / 2.7,
        showChartValuesInPercentage: false,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.grey[200],
        colorList: colorList,
        showLegends: true,
        legendPosition: LegendPosition.right,
        decimalPlaces: 1,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900].withOpacity(0.9),
        ),
        chartType: ChartType.ring,
      );
    }
    else if(_dataLength == 0){
      return Container(
        alignment: AlignmentDirectional.center,
        child: Center(child: Text("No sales yet")),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }

  /// It doesn't show user's [totalProfitMade] if the [username] is not 'Farawe'
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(child: _buildChart()),
          SizedBox(height: 15.0,width: 15.0,),
          username == 'Farawe' ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    'Profit Made',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[400],
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${money(totalProfitMade).output.symbolOnLeft.toString()}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              ],
            ),
          ) : Container(),
        ],
      ),
    );
  }

}
