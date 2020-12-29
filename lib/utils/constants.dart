import 'package:ayolee_stores/ui/profile_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

/// A class to set constants for menu options in the profile page
class Constants{

  static const String Create = 'Create a worker';

  static const String ShowRetail = 'Retail Sales';

  static const String ShowAll = 'All products';
  static const String ShowAvailable = 'Available products';
  static const String ShowFinished = 'Products out of Stock';

  /// List of string to hold the menu options in [Products]
  static const List<String> showProductChoices = <String>[
    ShowAll,
    ShowAvailable,
    ShowFinished
  ];

  /// List of string to hold the menu options in [Profile]
  static const List<String> profileChoices = <String>[
    Create,
  ];

  /// List of string to hold the menu options in [ProductsSold]
  static const List<String> productsSoldChoices = <String>[
    ShowRetail,
  ];

  /// Method to capitalize the first letter of each word in [string]
  static String capitalize(String string) {
    String result = '';

    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    else{
      List<String> values = string.split(' ');
      List<String> valuesToJoin = new List();

      if(values.length == 1){
        result = string[0].toUpperCase() + string.substring(1);
      }
      else{
        for(int i = 0; i < values.length; i++){
          if(values[i].isNotEmpty){
            valuesToJoin.add(values[i][0].toUpperCase() + values[i].substring(1));
          }
        }
        result = valuesToJoin.join(' ');
      }

    }
    return result;
  }

  /// Convert a double [value] to a currency
  static String money(double value){
    final nf = NumberFormat("#,##0.00", "en_US");
    return 'N${nf.format(value)}';
  }

  /// Using FlutterToast to display toast message of value [message]
  static showMessage(String message){
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black
    );
  }

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

