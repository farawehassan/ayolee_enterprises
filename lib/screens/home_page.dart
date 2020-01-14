import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ayolee_stores/constants.dart';
import 'package:ayolee_stores/screens/available_drinks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ayolee_stores/sample/sample_data_provider.dart';
import 'package:ayolee_stores/screens/receipt_page.dart';

class MyHomePage extends StatefulWidget {

  static const String id = 'home_page';

  //MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  double quantity;
  String selectedProduct;
  double unitPrice;
  double totalPrice = 0.0;
  int increment = 0;
  final List<Map> detailsList = [];
  Map details = {};

  List<Row> rows = List();

  @override
  void initState() {
    super.initState();
    details = {'qty':'$quantity','product':selectedProduct,'unitPrice':'$unitPrice','totalPrice':'$totalPrice'};
  }

  void addRow(){
    print(detailsList);
    final TextEditingController productController = TextEditingController();
    setState(() {
      details = {'qty':'$quantity','product':selectedProduct,'unitPrice':'$unitPrice','totalPrice':'$totalPrice'};
      increment ++;
      print(increment);
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              width: 50.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    quantity = double.parse(value);
                    details['qty'] = '$quantity';
                  },
                decoration: kTextFieldDecoration.copyWith(hintText: '0'),
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: 300.0,
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: productController,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Product'),
                ),
                suggestionsCallback: (pattern) {
                  return AvailableProducts.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  productController.text = suggestion;
                  selectedProduct = productController.text;
                  details['product'] = '$selectedProduct';
                  print(suggestion);
                },
                onSaved: (value) {
                  print(value);
                },
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: 100.0,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  unitPrice = double.parse(value);
                  details['unitPrice'] = '$unitPrice';
                },
                decoration: kTextFieldDecoration.copyWith(hintText: '0.0'),
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: 150.0,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalPrice = double.parse(value);
                  details['totalPrice'] = '$totalPrice';
                  //getTotalPrice(quantity, unitPrice);
                },
                decoration: kTextFieldDecoration.copyWith(hintText: '0.0',),
              ),
            ),
          ),
        ],
      ));
    });
    print(details);
    //details = {'qty':'$quantity','product':selectedProduct,'unitPrice':'$unitPrice','totalPrice':'$totalPrice'};
    detailsList.add(details);
    details.clear();
    print(rows.length);
    print(detailsList);
  }

  void deleteItem(index){
    setState((){
      print(index);
      rows.removeAt(index);
      print(detailsList[index]);
      detailsList.removeAt(index);
    });
  }

  void undoDeletion(index, item){
    setState((){
      rows.insert(index, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Record'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Receipt(sentProducts: detailsList,)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "QTY",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "PRODUCT",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
                  ),
                  Text(
                    "PRICE",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "TOTAL",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: rows.map((data) {
                    int index = rows.indexOf(data);
                    return Dismissible(
                      key: new ObjectKey(rows[index]),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          deleteItem(index);
                          increment--;
                        });
                      },
                      background: Container(color: Colors.red),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: rows[index],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Ayolee Enterprises"),
              accountEmail: Text("farawebola@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                Theme.of(context).platform == TargetPlatform.iOS ? Colors.blue : Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text('Daily Sales'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Available Drinks'),
              onTap: (){
                Navigator.pushNamed(context, Products.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_returned),
              title: Text('Daily Reports'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_returned),
              title: Text('Weekly Report'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addRow,
        tooltip: 'Relax',
        child: Icon(Icons.add),
      ),
    );
  }

}