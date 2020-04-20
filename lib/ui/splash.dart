import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'welcome_screen.dart';

class Splash extends StatelessWidget {

  static const String id = 'splash_screen_page';

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 3,
        navigateAfterSeconds: WelcomeScreen.id,
        image: new Image.asset('Assets/images/splash_logo.png'),
        photoSize: 200.0,
        onClick: ()=>print("My Splash")
    );
  }
}