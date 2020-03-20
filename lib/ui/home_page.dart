import 'package:ayolee_stores/database/DBHelper.dart';
import 'package:ayolee_stores/model/availableProductDB.dart';
import 'package:ayolee_stores/utils/product_suggestions.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ayolee_stores/ui/available_drinks.dart';
import 'package:ayolee_stores/ui/receipt_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ayolee_stores/ui/welcome_screen.dart';
import 'package:ayolee_stores/ui/daily_reports.dart';


FirebaseUser loggedInUser;

class MyHomePage extends StatefulWidget {

  static const String id = 'home_page';

  //MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _auth = FirebaseAuth.instance;

  double quantity;
  String selectedProduct;
  double unitPrice;
  double totalPrice;

  int increment = 0;
  List<Map> detailsList = [];
  Map details = {};
  List<String> availableProducts = [];

  List<Row> rows = List();

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser();
      if(user != null){
        loggedInUser = user;
      }
    } catch(e){
      print(e);
    }
  }

  Future<List<AvailableProduct>> getProductsFromDB() async {
    var dbHelper = DBHelper();
    Future<List<AvailableProduct>> availableProduct = dbHelper.getProducts();
    return availableProduct;
  }

  void availableProductNames() {
    Future<List<AvailableProduct>> productNames = getProductsFromDB();
    productNames.then((value) {
      for (int i = 0; i < value.length; i++){
        availableProducts.add(value[i].productName);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    availableProductNames();
    details = {'qty':'$quantity','product':selectedProduct,'unitPrice':'$unitPrice','totalPrice':'$totalPrice'};
  }

  void addRow(){
    availableProducts.clear();
    availableProductNames();
    print(detailsList);
    final TextEditingController priceController = TextEditingController();
    final TextEditingController productController = TextEditingController();
    final TextEditingController totalPriceController = TextEditingController();

    double total = 0.0;
    setState(() {
      details = {'qty':'$quantity','product':selectedProduct,'unitPrice':'$unitPrice','totalPrice':'$totalPrice'};
      increment ++;

      print(increment);
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              width: 80.0,
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
                  return AvailableProducts.getSuggestions(pattern, availableProducts);
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
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  unitPrice = double.parse(value);
                  details['unitPrice'] = '$unitPrice';
                  setState(() {
                    totalPrice = double.parse(value) * quantity;
                    total = totalPrice;
                    totalPriceController.text = totalPrice.toString();
                    details['totalPrice'] = '$totalPrice';
                  });
                },
                decoration: kTextFieldDecoration.copyWith(hintText: '0.0'),
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: 150.0,
              child: TextField(
                controller: totalPriceController,
                decoration: kTextFieldDecoration.copyWith(hintText: '0.0'),
              ),
            ),
          ),
        ],
      ));
      print(total);
    });

    print(details);
    detailsList.add(details);
    details.clear();
    priceController.clear();
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
      detailsList.insert(index, item);
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
                MaterialPageRoute(builder: (context) => Receipt(sentProducts: detailsList)),
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
                  titleText("QTY"),
                  titleText("PRODUCT"),
                  titleText("PRICE"),
                  titleText("TOTAL"),
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
                Navigator.pushNamed(context, MyHomePage.id);
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
                Navigator.pushNamed(context, DailyReports.id);
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
                _auth.signOut();
                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
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
