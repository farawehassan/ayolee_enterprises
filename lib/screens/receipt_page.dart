import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Receipt extends StatelessWidget {

  static const String id = 'receipt_page';

  final List<Map> sentProducts;

  Receipt({@required this.sentProducts});

  String companyName = "Ayo-Lee Nigeria Enterprises";
  String address = "14, Leigh street Off Ojuelegba Road Surulere Lagos";
  String phoneNumber = "0802912565, 07033757855";
  String email = "farawebola@gmail.com";
  DateTime dateTime = DateTime.now();
  String buyersName;
  double totalPrice = 0.0;
  List<TableRow> items = [];

  List<Map> receivedProducts = [];

  /*void removeNull(){
    for(var product in sentProducts){
      if (product){
        print('incoming...');
        print(product);
        sentProducts.remove(product);
      }
    }
  }*/

  void addProducts() {
    //removeNull();
    items.add(TableRow(children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('S/N'),
            Text('QTY'),
            Text('PRODUCT'),
            Text('PRICE'),
            Text('TOTAL'),
          ],
        ),
      ),
    ]));
    for (var product in sentProducts) {
      //print(product);
      items.add(TableRow(children: [
        TableCell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(sentProducts.indexOf(product).toString()),
              Text(product['qty'].toString()),
              Text(product['product'].toString()),
              Text(product['unitPrice'].toString()),
              Text(product['totalPrice'].toString()),
            ],
          ),
        ),
      ]));
      //totalPrice += double.parse(product['totalPrice']);
    }
  }

  @override
  Widget build(BuildContext context) {
    removeNull();
    addProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.print,
              color: Colors.white,
            ),
            onPressed: () {

            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
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
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 2.0,
            ),
            Container(
              child: Text(
                "Tel: $phoneNumber",
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 2.0,
            ),
            Container(
              child: Text(
                "Email: $email",
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 2.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Container(
                          width: 150.0,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontWeight: FontWeight.w500),
                            onChanged: (value) {
                              buyersName = value;
                            },
                            decoration: InputDecoration(
                              hoverColor: Colors.black,
                              fillColor: Colors.black,
                              focusColor: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      "Date: $dateTime",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Table(
                border: TableBorder.all(color: Colors.black),
                children: items,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'TOTAL = ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  '$totalPrice',
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}

/*class Receipt extends StatefulWidget {
  static const String id = 'receipt_page';

  final List<Map> sentProducts;

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
  double totalPrice = 0.0;
  List<TableRow> items = [];

  List<Map> receivedProducts = [];

  @override
  void initState() {
    // TODO: implement initState
    receivedProducts = widget.sentProducts;
    super.initState();
  }

  void removeNull() {
    for (var products in receivedProducts) {
      print(products);
      print(products['qty']);
      print(products['product']);
      print(products['unitPrice']);
      print(products['totalPrice']);
      if (products['qty'] == null || products['product'] == null || products['unitPrice'] == null || products['totalPrice'] == null) {
        receivedProducts.remove(products);
      }
    }
    print(receivedProducts);
  }

  void addProducts() {
   *//* var toRemove = [];

    receivedProducts.forEach( (e) {
      if(e == null)
        toRemove.add(e);
    });
    receivedProducts.removeWhere( (e) => toRemove.contains(e));*//*
    //removeNull();
    items.add(TableRow(children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('S/N'),
            Text('QTY'),
            Text('PRODUCT'),
            Text('PRICE'),
            Text('TOTAL'),
          ],
        ),
      ),
    ]));
    for (var product in receivedProducts) {
      print(product);
      items.add(TableRow(children: [
        TableCell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(receivedProducts.indexOf(product).toString()),
              Text(product['qty'].toString()),
              Text(product['product'].toString()),
              Text(product['unitPrice'].toString()),
              Text(product['totalPrice'].toString()),
            ],
          ),
        ),
      ]));
      //totalPrice += double.parse(product['totalPrice']);
    }
  }

  @override
  Widget build(BuildContext context) {
    addProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.print,
              color: Colors.white,
            ),
            onPressed: () {

            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
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
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 2.0,
            ),
            Container(
              child: Text(
                "Tel: $phoneNumber",
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 2.0,
            ),
            Container(
              child: Text(
                "Email: $email",
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 2.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Container(
                          width: 150.0,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontWeight: FontWeight.w500),
                            onChanged: (value) {
                              buyersName = value;
                            },
                            decoration: InputDecoration(
                              hoverColor: Colors.black,
                              fillColor: Colors.black,
                              focusColor: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      "Date: $dateTime",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Table(
                border: TableBorder.all(color: Colors.black),
                children: items,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'TOTAL = ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  '$totalPrice',
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}*/
