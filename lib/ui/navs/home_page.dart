import 'package:ayolee_stores/bloc/product_suggestions.dart';
import 'package:ayolee_stores/database/user_db_helper.dart';
import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/ui/receipt/receipt_page.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:ayolee_stores/ui/welcome_screen.dart';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile_page.dart';
import 'available_drinks.dart';
import 'daily/daily_reports.dart';
import 'monthly/reports_page.dart';

class MyHomePage extends StatefulWidget {

  static const String id = 'home_page';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var futureValue = FutureValues();

  double quantity;
  String selectedProduct;
  double unitPrice;
  double totalPrice;

  int increment = 0;
  List<Map> detailsList = [];
  Map details = {};
  List<String> availableProducts = [];
  List<Row> rows = [];

  String username;

  void getCurrentUser() async {
    await futureValue.getCurrentUser().then((user) {
      username = user.name;
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  void availableProductNames() {
    Future<List<AvailableProduct>> productNames = futureValue.getProductsFromDB();
    productNames.then((value) {
      for (int i = 0; i < value.length; i++){
        availableProducts.add(value[i].productName);
      }
    });
    print(availableProducts);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //availableProductNames();
    //details = {'qty':'$quantity','product':selectedProduct,'unitPrice':'$unitPrice','totalPrice':'$totalPrice'};
  }

  void addRow() {
    availableProducts.clear();
    availableProductNames();

    print(detailsList);
    final TextEditingController qtyController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController productController = TextEditingController();
    final TextEditingController totalPriceController = TextEditingController();

    setState(() {
      details = {'qty':'$quantity','product':selectedProduct,'unitPrice':'$unitPrice','totalPrice':'$totalPrice'};
      increment ++;

      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              width: 80.0,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: qtyController,
                onChanged: (value) {
                  setState(() {
                    quantity = double.parse(value);
                    details['qty'] = '$quantity';
                    if(priceController.text != null){
                      totalPrice = double.parse(priceController.text) * double.parse(qtyController.text);
                      //total = totalPrice;
                      totalPriceController.text = totalPrice.toString();
                      details['totalPrice'] = '$totalPrice';
                    }
                  });
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
                  selectedProduct = value;
                  details['product'] = '$selectedProduct';
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
                  setState(() {
                    unitPrice = double.parse(value);
                    details['unitPrice'] = '$unitPrice';
                    print(unitPrice);
                    totalPrice = double.parse(value) * double.parse(qtyController.text);
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

      print(details);

    });

    if(details['qty'].toString().isNotEmpty && details['product'].toString().isNotEmpty && details['unitPrice'].toString().isNotEmpty && details['totalPrice'].toString().isNotEmpty){
      try {
        detailsList.add(details);
        details.clear();
        qtyController.clear();
        priceController.clear();
        print(detailsList);
      } catch (e) {
        print(e);
        Fluttertoast.showToast(
            msg: "Error in records",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black);
      }
    }
  }

  void deleteItem(index){
    setState((){
      print(index);
      rows.removeAt(index);
      try {
        print(detailsList[index]);
        detailsList.removeAt(index);
      } catch (e) {
        print(e);
      }
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
        title: Center(child: Text('Sales Record')),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () {
              if (detailsList.isNotEmpty) {
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Receipt(sentProducts: detailsList)),
                  );
                } catch (e) {
                  print(e);
                  Fluttertoast.showToast(
                      msg: "Error in records",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.white,
                      textColor: Colors.black);
                }
              }
              else{
                Fluttertoast.showToast(
                    msg: "No records",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.white,
                    textColor: Colors.black);
              }
            },
          ),
        ],
      ),
      body:  Padding(
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
                backgroundImage: AssetImage('Assets/images/mum.JPG'),
                backgroundColor: Colors.blue,
              ),
              onDetailsPressed: (){
                if(username == 'Farawe'){
                  Navigator.pushNamed(context, Profile.id);
                }else{
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text('Sales Record'),
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
                Navigator.pushNamed(context, DailyReports.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_returned),
              title: Text('Monthly Report'),
              onTap: (){
                Navigator.pushNamed(context, Reports.id);
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: (){
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    child: Container(
                      height: 150.0,
                      padding: const EdgeInsets.all(16.0),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0),
                              child: Text(
                                "Are you sure you want to sign out",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // To close the dialog
                                  },
                                  textColor: Colors.blueAccent,
                                  child: Text('No'),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // To close the dialog
                                    logout();
                                  },
                                  textColor: Colors.blueAccent,
                                  child: Text('Yes'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
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

  void showNullMessage(){
    Fluttertoast.showToast(
        msg: "No available drinks",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black);
  }

  void logout() async {
    var db = new DatabaseHelper();
    await db.deleteUsers();
    getBoolValuesSF();
  }

  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('loggedIn') ?? true;
    if(boolValue == true){
      addBoolToSF();
    }
  }

  addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
  }

}
