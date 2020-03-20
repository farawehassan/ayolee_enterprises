import 'package:ayolee_stores/model/availableProductDB.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:ayolee_stores/database/DBHelper.dart';

Future<List<AvailableProduct>> getProductsFromDB() async {
  var dbHelper = DBHelper();
  Future<List<AvailableProduct>> availableProduct = dbHelper.getProducts();
  return availableProduct;
}

class Products extends StatefulWidget {
  static const String id = 'available_drinks';

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  AvailableProduct product = new AvailableProduct();

  String productName;
  double costPrice, sellingPrice, initialQuantity, currentQuantity;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  void refreshData(){
    setState(() {
      getProductsFromDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    //addText(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<AvailableProduct>>(
          future: getProductsFromDB(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    print(snapshot.data);
                    return SimpleFoldingCell(
                        frontWidget: buildFrontWidget(
                            snapshot.data[index].productName),
                        innerTopWidget: buildInnerTopWidget(
                            snapshot.data[index].productName),
                        innerBottomWidget: buildInnerBottomWidget(
                            snapshot.data[index].productName,
                            snapshot.data[index].initialQuantity,
                            snapshot.data[index].currentQuantity,
                            snapshot.data[index].costPrice,
                            snapshot.data[index].sellingPrice),
                        cellSize: Size(MediaQuery.of(context).size.width, 90),
                        padding: EdgeInsets.all(8.0),
                        animationDuration: Duration(milliseconds: 300),
                        borderRadius: 10,
                        onOpen: () => print('$index cell opened'),
                        onClose: () => print('$index cell closed'));
                  });
            }
            else if(snapshot.data == null || snapshot.data.length == 0){
              return Container(
                  alignment: AlignmentDirectional.center,
                  child: Text("No available products"));
            }
            // Show loading while snapshot is not loaded
            return Container(
              alignment: AlignmentDirectional.center,
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.white,
              child: Container(
                height: 300.0,
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Add new product",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (val) =>
                              val.length == 0 ? "Enter Product" : null,
                          onChanged: (value) {
                            productName = value;
                          },
                          onSaved: (value) {
                            this.productName = value;
                          },
                          decoration: kAddProductDecoration.copyWith(
                              hintText: "Product name"),
                        ),
                      ),
                      Container(
                        width: 150.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val.length == 0 ? "Enter Qty" : null,
                          onChanged: (value) {
                            initialQuantity = double.parse(value);
                          },
                          onSaved: (value) {
                            this.initialQuantity = double.parse(value);
                          },
                          decoration:
                              kAddProductDecoration.copyWith(hintText: "Qty"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 150.0,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                                  val.length == 0 ? "Enter CP" : null,
                              onChanged: (value) {
                                costPrice = double.parse(value);
                              },
                              onSaved: (value) {
                                this.costPrice = double.parse(value);
                              },
                              decoration: kAddProductDecoration.copyWith(
                                  hintText: "CP"),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            width: 150.0,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value.length == 0 ? "Enter SP" : null,
                              onChanged: (value) {
                                sellingPrice = double.parse(value);
                              },
                              onSaved: (value) {
                                this.sellingPrice = double.parse(value);
                              },
                              decoration: kAddProductDecoration.copyWith(
                                  hintText: "SP"),
                            ),
                          ),
                        ],
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
                                Navigator.of(context)
                                    .pop(); // To close the dialog
                              },
                              textColor: Colors.blueAccent,
                              child: Text('CANCEL'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FlatButton(
                              onPressed: () {
                                print(productName);
                                print(initialQuantity);
                                print(costPrice);
                                print(sellingPrice);
                                saveNewProduct(); // To close the dialog
                                Navigator.of(context)
                                    .pop(); // To close the dialog
                                refreshData();
                              },
                              textColor: Colors.blueAccent,
                              child: Text('SAVE'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        tooltip: 'Add new product',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildFrontWidget(String productName) {
    return Builder(builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          SimpleFoldingCellState foldingCellState = context.findAncestorStateOfType<SimpleFoldingCellState>();
          foldingCellState?.toggleFold();
        },
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.expand_more, color: Colors.lightBlueAccent),
                  onPressed: () {
                    SimpleFoldingCellState foldingCellState = context.findAncestorStateOfType<SimpleFoldingCellState>();
                    foldingCellState?.toggleFold();
                  },
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  productName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildInnerTopWidget(String productName) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Text(
        productName,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget buildInnerBottomWidget(
      String name, double iq, double cq, double cp, double sp) {
    final controllerQty = TextEditingController();
    final controllerCp = TextEditingController();
    final controllerSp = TextEditingController();

    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          SimpleFoldingCellState foldingCellState = context.findAncestorStateOfType<SimpleFoldingCellState>();
          foldingCellState?.toggleFold();
        },
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.expand_less, color: Colors.lightBlueAccent),
                  onPressed: () {
                    SimpleFoldingCellState foldingCellState = context.findAncestorStateOfType<SimpleFoldingCellState>();
                    foldingCellState?.toggleFold();
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Initial quantity: $iq',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Current quantity: $cq',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Quantity Sold: ${iq - cq}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('CP: $cp'),
                    Text('SP: $sp'),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.info, color: Colors.lightBlueAccent),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 0.0,
                        backgroundColor: Colors.white,
                        child: Container(
                          height: 300.0,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "Update incoming product",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 150.0,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (val) =>
                                      val.length == 0 ? "Enter Qty" : null,
                                  controller: controllerQty,
                                  decoration: kAddProductDecoration.copyWith(
                                      hintText: "Qty"),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 150.0,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: (val) =>
                                          val.length == 0 ? "Enter CP" : null,
                                      controller: controllerCp,
                                      decoration: kAddProductDecoration
                                          .copyWith(hintText: "CP"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Container(
                                    width: 150.0,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: (value) =>
                                          value.length == 0 ? "Enter SP" : null,
                                      controller: controllerSp,
                                      decoration: kAddProductDecoration
                                          .copyWith(hintText: "SP"),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // To close the dialog
                                      },
                                      textColor: Colors.blueAccent,
                                      child: Text('CANCEL'),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: FlatButton(
                                      onPressed: () {
                                        var dbHelper = DBHelper();
                                        AvailableProduct product =
                                            AvailableProduct();
                                        product.productName = name;
                                        product.initialQuantity =
                                            double.parse(controllerQty.text) +
                                                iq;
                                        product.costPrice =
                                            double.parse(controllerCp.text);
                                        product.sellingPrice =
                                            double.parse(controllerSp.text);
                                        product.currentQuantity =
                                            double.parse(controllerQty.text) +
                                                cq;
                                        dbHelper
                                            .updateAvailableProduct(product);
                                        Fluttertoast.showToast(
                                            msg: "$name is updated",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black);
                                        setState(() {
                                          getProductsFromDB();
                                        });
                                        Navigator.of(context)
                                            .pop(); // To close the dialog
                                      },
                                      textColor: Colors.blueAccent,
                                      child: Text('SAVE'),
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
        ),
      );
    });
  }

  void saveNewProduct() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      return null;
    }
    var product = AvailableProduct();
    product.productName = productName;
    product.costPrice = costPrice;
    product.sellingPrice = sellingPrice;
    product.initialQuantity = initialQuantity;
    product.currentQuantity = currentQuantity = initialQuantity;

    var dbHelper = DBHelper();
    dbHelper.addNewAvailableProduct(product);
    Fluttertoast.showToast(
        msg: "Product was added",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black);
  }
}