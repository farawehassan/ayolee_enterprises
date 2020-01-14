import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Receipt extends StatefulWidget {

  static const String id = 'receipt_page';
  final List sentProducts;

  Receipt({@required this.sentProducts});

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {

  String companyName = "Ayo-Lee Nigeria Enterprises";
  String address = "14, Leigh street Off Ojuelegba Road Surulere Lagos";
  String phoneNumber = "0802912565, 07033757855";
  String email = "farawebola@gmail.com";
  DateTime dateTime = DateTime.now();
  String buyersName;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            child: Text(
              companyName,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Container(
            child: Text(
              address,
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Text(
                  "Tel: $phoneNumber",
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Email: $email",
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    buyersName = value;
                  },
                ),
              ),
              Container(
                child: Text(
                  "Date: $dateTime",
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
