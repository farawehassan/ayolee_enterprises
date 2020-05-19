import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ayolee_stores/bloc/daily_report_value.dart';
import 'package:ayolee_stores/bloc/daily_report_chart.dart';
import 'package:ayolee_stores/utils/reusable_card.dart';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'daily_report_list.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

// ignore: must_be_immutable
class DailyReports extends StatefulWidget {

  static const String id = 'daily_reports';

  @override
  _DailyReportsState createState() => _DailyReportsState();
}

class _DailyReportsState extends State<DailyReports> {

  var reportValue = DailyReportValue();

  var futureValue = FutureValues();

  double totalSalesPrice = 0.0;

  double availableCash = 0.0;

  double totalTransfer = 0.0;

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

  void getReports() async {
    Future<List<DailyReportsData>> report = futureValue.getDailyReportsFromDB();
    await report.then((value) {
      setState(() {
        for(int i = 0; i < value.length; i++){
          if(reportValue.checkIfToday(value[i].time)){
            calculateProfit(value[i]);
            if(value[i].paymentMode == 'Cash'){
              availableCash += double.parse(value[i].totalPrice);
            }
            else if(value[i].paymentMode == 'Transfer'){
              totalTransfer += double.parse(value[i].totalPrice);
            }
          }
        }
        totalSalesPrice = availableCash + totalTransfer;
      });

      print(availableCash);
      print(totalTransfer);
      print(totalSalesPrice);
      print(totalProfitMade);
    });
  }

  @override
  void initState() {
    super.initState();
    getReports();
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
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ReusableCard(
                cardChild: 'Today\'s Sales',
                onPress: (){
                  Navigator.pushNamed(context, DailyReportList.id);
                },
              ),
              SizedBox(height: 40.0,),
              DailyChart(),
              SizedBox(height: 40.0,),
              Container(
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    titleText('Available Cash: ${money(availableCash).output.symbolOnLeft}'),
                    SizedBox(height: 8.0,),
                    titleText('Transfered Cash: ${money(totalTransfer).output.symbolOnLeft}'),
                    SizedBox(height: 8.0,),
                    titleText('Total Cash: ${money(availableCash + totalTransfer).output.symbolOnLeft}'),
                    SizedBox(height: 8.0,),
                    username == 'Farawe' ? titleText('Profit made: ${money(totalProfitMade).output.symbolOnLeft}') : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}