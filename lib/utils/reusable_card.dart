import 'package:flutter/material.dart';
import 'constants.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({this.cardChild, this.onPress});

  final String cardChild;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: titleText(cardChild)
          ),
        ),
        margin: EdgeInsets.all(8.0),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {

  ProfileCard({this.cardChild});

  final Widget cardChild;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cardChild,
      ),
    );
  }

}
