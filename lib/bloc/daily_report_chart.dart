import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:ayolee_stores/bloc/daily_report_value.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:ayolee_stores/bloc/future_values.dart';

class DailyChart extends StatefulWidget {

  static const String id = 'daily_chart';

  @override
  _DailyChartState createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {

  var reportValue = DailyReportValue();

  var futureValue = FutureValues();

  List<Color> colours = (Colors.primaries.cast<Color>() + Colors.accents.cast<Color>());

  var data = {};

  Map<String, double> dataMap = Map();

  List<Color> colorList = [];

  void getReports() async {
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      setState(() {
        for(int i = 0; i < value.length; i++){
          if(reportValue.checkIfToday(value[i].time)){
            if(data.containsKey(value[i].productName)){
              data[value[i].productName] = (double.parse(data[value[i].productName]) + double.parse(value[i].quantity)).toString();
            }else{
              data[value[i].productName] = '${value[i].quantity}';
            }
          }
        }
        print(data);
      });
    });
    getColors();
  }

  void getColors() {
    for(int i = 0; i < data.length; i++){
      colorList.add(colours[i]);
    }
    print(data);
    print(colorList);
    data.forEach((k,v) {
      dataMap.putIfAbsent("$k", () => double.parse('$v'));
    });
    print(dataMap);
  }

  @override
  void initState() {
    getReports();
    super.initState();
  }

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
    else{
      Container(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _buildChart(),
      ),
    );
  }

}