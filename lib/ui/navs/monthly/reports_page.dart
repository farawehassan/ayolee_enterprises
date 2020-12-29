import 'dart:io';

import 'package:ayolee_stores/bloc/daily_report_value.dart';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:ayolee_stores/model/reportsDB.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:ayolee_stores/utils/reusable_card.dart';
import 'monthly_reports.dart';

/// A StatelessWidget class that displays all the months in a year
class ReportPage extends StatefulWidget {

  static const String id = 'reports_page';

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Instantiating a class of the [DailyReportValue]
  var dailyReportValue = DailyReportValue();

  List<Reports> _reports = [];

  List<String> _years = [DateTime.now().year.toString()];

  /// Integer variable to hold the selected year
  int _selectedYear = DateTime.now().year;

  var now = DateTime.now();

  /// Variable to hold the type of the user logged in
  String userType;

  /// Setting the current user's type logged in to [userType]
  void _getCurrentUser() async {
    await futureValue.getCurrentUser().then((user) {
      if(!mounted)return;
      setState(() {
        userType = user.type;
      });
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  /// Function to get all reports and all available years to [_reports] and
  /// [_years] respectively
  void _getReports() async {
    Future<List<Reports>> value = futureValue.getAllReportsFromDB();
    await value.then((allReports) {
      _years.clear();
      _years = dailyReportValue.getAllYears(allReports);
      _reports.addAll(allReports);
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// Function to build the GridView widget of all the months in a year
  Widget _buildList() {
    if(_reports == null){
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    } else{
      return GridView.count(
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
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Jan', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'Febraury',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Feb', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'March',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Mar', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'April',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Apr', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'May',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'May', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'June',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Jun', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'July',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Jul', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'August',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Aug', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'September',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Sep', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'October',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Oct', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'November',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Nov', userType: userType, year: _selectedYear)),
              );
            },
          ),
          ReusableCard(
            cardChild: 'December',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Dec', userType: userType, year: _selectedYear)),
              );
            },
          ),
        ],
      );
    }

  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getReports();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Reports'),
        actions: [
          Container(
            alignment: Alignment.center,
            child: Text(
              _selectedYear.toString(),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return _years.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            }
          )
        ],
      ),
      body: _buildList(),
    );
  }

  /// A function to set the [choice] to the [_selectedYear]
  void choiceAction(String choice){
    if(!mounted)return;
    setState(() {
      _selectedYear = int.parse(choice);
    });
  }

}

