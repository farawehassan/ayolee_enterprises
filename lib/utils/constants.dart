import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

/// A class to set constants for menu options in the profile page
class Constants{

  static const String Create = 'Create a worker';

  /// List of string to hold the menu options names
  static const List<String> choices = <String>[
    Create,
  ];

}

/// setting a constant [kTextFieldDecoration] for [InputDecoration] styles
const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

/// setting a constant [kAddProductDecoration] for [InputDecoration] styles
const kAddProductDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  //border: InputBorder.none,
);

/// Building a [Text] widget to display [title]
Text titleText(String title){
  return Text(
    title,
    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
  );
}

