import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:ayolee_stores/database/user_db_helper.dart';
import 'package:ayolee_stores/ui/profile_page.dart';
import 'package:ayolee_stores/ui/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:ayolee_stores/utils/reusable_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../available_drinks.dart';
import '../daily/daily_reports.dart';
import '../home_page.dart';
import 'monthly_reports.dart';

// ignore: must_be_immutable
class Reports extends StatelessWidget {

  BuildContext context;
  static const String id = 'reports_page';
  var futureValue = FutureValues();

  String username;

  void getCurrentUser() async {
    await futureValue.getCurrentUser().then((user) {
      username = user.name;
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Monthly Reports')),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          ReusableCard(
            cardChild: 'January',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Jan')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'Febraury',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Feb')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'March',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Mar')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'April',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Apr')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'May',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'May')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'June',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Jun')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'July',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Jul')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'August',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Aug')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'September',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Sep')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'October',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Oct')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'November',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Nov')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'December',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Dec')),
              );
            },
          ),
        ],
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
                Navigator.pushNamed(context, DailyReports.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_returned),
              title: Text('Monthly Report'),
              onTap: (){
                Navigator.pop(context);
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

