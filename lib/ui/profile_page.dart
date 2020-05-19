import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:ayolee_stores/model/linear_sales.dart';
import 'package:ayolee_stores/model/store_details.dart';
import 'package:ayolee_stores/ui/register/create_worker.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:ayolee_stores/utils/reusable_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:ayolee_stores/bloc/year_line_charts.dart';
import 'package:ayolee_stores/bloc/profit_charts.dart';

class Profile extends StatefulWidget {

  static const String id = 'profile_page';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  var futureValue = FutureValues();

  String cpNetWorth = '';
  String spNetWorth = '';
  double numberOfItems = 0.0;

  double totalProfit = 0.0;

  FlutterMoneyFormatter money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  void getStoreValues() async {
    Future<StoreDetails> details = futureValue.availableProducts();
    await details.then((value) {
      setState(() {
        cpNetWorth = money(value.cpNetWorth).output.symbolOnLeft;
        spNetWorth = money(value.spNetWorth).output.symbolOnLeft;
        numberOfItems = value.numberOfItems;
      });
    });
  }

  void getReports() async {
    Future<List<LinearSales>> report = futureValue.getYearReports();
    await report.then((value) {
      setState(() {
        for(int i = 0; i < value.length; i++){
          totalProfit += value[i].profit;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getStoreValues();
    getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf2f4fb),
      appBar: AppBar(
        title: Text('Ayo-Lee Enterprises'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Material(
              color: Color(0xFFF9FBFD),
              elevation: 14.0,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              shadowColor: Color(0x802196F3),
              child: Container(
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.only(bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Hero(
                            tag: 'displayPicture',
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              maxRadius: 80.0,
                              minRadius: 40.0,
                              backgroundImage: AssetImage('Assets/images/mum.JPG'),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Mrs Farawe Silifat Bola",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blue[400],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "farawebola@gmail.com",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blue[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'CP Net Worth',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blue[400],
                                ),
                              ),
                              Text(
                                '$cpNetWorth',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'SP Net Worth',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blue[400],
                                ),
                              ),
                              Text(
                                '$spNetWorth',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              margin: EdgeInsets.all(8.0),
              height: 200.0,
              child: Material(
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Color(0xFFF9FBFD),
                child:  Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blueAccent
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],

                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sales by Month',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      PointsLineChart(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              margin: EdgeInsets.all(4.0),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProfileCard(
                        cardChild: ProfitCharts(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ProfileCard(
                            cardChild: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:Text(
                                    'Profit Made',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.blue[400],
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      '${money(totalProfit).output.symbolOnLeft}',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.0,),
                          ProfileCard(
                            cardChild: Column(
                              children: <Widget>[
                                Text(
                                  'Number of Items',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.blue[400],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      '$numberOfItems',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void choiceAction(String choice){
    if(choice == Constants.Create){
      Navigator.pushNamed(context, CreateWorker.id);
    }
  }
}

