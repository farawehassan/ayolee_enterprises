import 'package:ayolee_stores/database/user_db_helper.dart';
import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:ayolee_stores/ui/navs/monthly/reports_page.dart';
import 'package:ayolee_stores/ui/profile_page.dart';
import '../available_drinks.dart';
import '../home_page.dart';
import 'package:ayolee_stores/ui/welcome_screen.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ayolee_stores/bloc/daily_report_value.dart';
import 'package:ayolee_stores/bloc/daily_report_chart.dart';
import 'package:ayolee_stores/utils/reusable_card.dart';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    getCurrentUser();
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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Ayolee Enterprises"),
              accountEmail: Text("farawebola@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('Assets/images/mum.JPG'),
                backgroundColor:
                Theme.of(context).platform == TargetPlatform.iOS ? Colors.blue : Colors.white,
              ),
              onDetailsPressed: (){
                if(username == 'Farawe'){
                  Navigator.pushNamed(context, Profile.id);
                }else{
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text('Sales Record'),
              onTap: (){
                Navigator.pushNamed(context, MyHomePage.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Available Drinks'),
              onTap: (){
                Navigator.pushNamed(context, Products.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_returned),
              title: Text('Daily Reports'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_returned),
              title: Text('Monthly Report'),
              onTap: (){
                Navigator.pushNamed(context, Reports.id);
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: (){
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    child: Container(
                      height: 150.0,
                      padding: const EdgeInsets.all(16.0),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0),
                              child: Text(
                                "Are you sure you want to sign out",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // To close the dialog
                                  },
                                  textColor: Colors.blueAccent,
                                  child: Text('No'),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // To close the dialog
                                    logout();
                                  },
                                  textColor: Colors.blueAccent,
                                  child: Text('Yes'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    var db = new DatabaseHelper();
    await db.deleteUsers();
    getBoolValuesSF();
  }

  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('loggedIn') ?? true;
    if(boolValue == true){
      addBoolToSF();
    }
  }

  addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
  }
}