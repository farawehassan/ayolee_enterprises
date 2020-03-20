import 'package:flutter/material.dart';
import 'ui/home_page.dart';
import 'ui/available_drinks.dart';
import 'ui/welcome_screen.dart';
import 'ui/register/login_screen.dart';
import 'ui/daily_reports.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        MyHomePage.id: (context) => MyHomePage(),
        Products.id: (context) => Products(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        DailyReports.id: (context) => DailyReports(),
      },
    );
  }
}