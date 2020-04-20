import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:flutter/material.dart';
import 'package:ayolee_stores/bloc/daily_report_value.dart';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class MonthlyReportCharts extends StatefulWidget {

  MonthlyReportCharts({@required this.month});

  static const String id = 'monthly_report_charts';

  final String month;

  @override
  _MonthlyReportChartsState createState() => _MonthlyReportChartsState();
}

class _MonthlyReportChartsState extends State<MonthlyReportCharts> {

  var reportValue = DailyReportValue();

  var futureValue = FutureValues();

  List<Color> colours = (Colors.primaries.cast<Color>() + Colors.accents.cast<Color>());

  var data = {};

  Map<String, double> dataMap = Map();

  List<Color> colorList = [];

  double totalProfitMade = 0.0;

  String username;

  void getCurrentUser() async {
    await futureValue.getCurrentUser().then((user) {
      username = user.name;
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  FlutterMoneyFormatter money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  void getReports() async {
    print(widget.month);
    Future<List<DailyReportsData>> report = futureValue.getMonthReports(widget.month);
    await report.then((value) {
      setState(() {
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
      setState(() {
        totalProfitMade += profitMade;
      });
    });
  }

  void getColors() {
    for(int i = 0; i < data.length; i++){
      colorList.add(colours[i]);
    }
    data.forEach((k,v) {
      dataMap.putIfAbsent("$k", () => double.parse('$v'));
    });
  }

  @override
  void initState() {
    super.initState();
    getReports();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
            child: dataMap.isEmpty
                ? Container(
                alignment: AlignmentDirectional.center,
                child: Text("")
            )
                : PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery.of(context).size.width / 2.7,
              showChartValuesInPercentage: true,
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
              chartType: ChartType.disc,
            ),
          ),
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
