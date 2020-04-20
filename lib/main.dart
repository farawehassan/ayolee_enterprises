import 'package:ayolee_stores/ui/navs/daily/daily_report_list.dart';
import 'package:ayolee_stores/ui/navs/daily/daily_reports.dart';
import 'package:ayolee_stores/ui/navs/monthly/monthly_reports.dart';
import 'package:ayolee_stores/ui/navs/monthly/reports_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'ui/navs/home_page.dart';
import 'ui/navs/available_drinks.dart';
import 'ui/welcome_screen.dart';
import 'ui/register/login_screen.dart';
import 'ui/profile_page.dart';
import 'ui/register/create_worker.dart';
import 'ui/splash.dart';

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  enablePlatformOverrideForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayo-Lee Enterprises',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Splash.id,
      routes: {
        Splash.id: (context) => Splash(),
        MyHomePage.id: (context) => MyHomePage(),
        Products.id: (context) => Products(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        DailyReports.id: (context) => DailyReports(),
        DailyReportList.id: (context) => DailyReportList(),
        Reports.id: (context) => Reports(),
        // ignore: missing_required_param
        MonthReport.id: (context) => MonthReport(),
        Profile.id: (context) => Profile(),
        CreateWorker.id: (context) => CreateWorker(),
      },
    );
  }
}
