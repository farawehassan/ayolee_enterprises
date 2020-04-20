import 'package:flutter/material.dart';
import 'package:ayolee_stores/ui/register/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navs/home_page.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    getBoolValuesSF();
    return Container();
  }

  void getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('loggedIn');
    if(boolValue == true){
      Navigator.of(context).pushReplacementNamed(MyHomePage.id);
    }
    else if(boolValue == false){
      Navigator.of(context).pushReplacementNamed(LoginScreen.id);
    }
    else {
      Navigator.of(context).pushReplacementNamed(LoginScreen.id);
    }
  }

}


