import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class Products extends StatefulWidget {
  static const String id = 'available_drinks';

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  AvailableProduct product = new AvailableProduct();

  String productName;
  double costPrice, sellingPrice, initialQuantity, currentQuantity;

  var futureValue = FutureValues();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<AvailableProduct> names = new List();
  List<AvailableProduct> filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Available Products');

  _ProductsState(){
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        if (!mounted) return;
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      }
      else {
        if (!mounted) return;
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  String capitalize(String string) {
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

  void refreshData(){
    if (!mounted) return;
    setState(() {
      _getNames();
    });
  }

  void _getNames() async {
    List<AvailableProduct> tempList = new List();
    Future<List<AvailableProduct>> productNames = futureValue.getProductsFromDB();
    await productNames.then((value) {
      for (int i = 0; i < value.length; i++){
        tempList.add(value[i]);
      }
    });
    if (!mounted) return;
    setState(() {
      names = tempList;
      filteredNames = names;
    });
  }

  void _searchPressed() {
    if (!mounted) return;
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...'
          ),
        );
      }
      else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Available Products');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ],
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List<AvailableProduct> tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i].productName.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    if(filteredNames.length > 0 && filteredNames.isNotEmpty){
      return ListView.builder(
        itemCount: names == null ? 0 : filteredNames.length,
        itemBuilder: (BuildContext context, int index) {
          return SimpleFoldingCell(
              frontWidget: buildFrontWidget(
                  filteredNames[index].productName),
              innerTopWidget: buildInnerTopWidget(
                  filteredNames[index].productName),
              innerBottomWidget: buildInnerBottomWidget(
                  filteredNames[index].productName,
                  double.parse(filteredNames[index].initialQuantity),
                  double.parse(filteredNames[index].currentQuantity),
                  double.parse(filteredNames[index].costPrice),
                  double.parse(filteredNames[index].sellingPrice)),
              cellSize: Size(MediaQuery.of(context).size.width, 90),
              padding: EdgeInsets.all(8.0),
              animationDuration: Duration(milliseconds: 300),
              borderRadius: 10,
              onOpen: () => print('$index cell opened'),
              onClose: () => print('$index cell closed'));
        },
      );
    }
    else{
      Container(
        alignment: AlignmentDirectional.center,
        child: Center(child: Text("No available products")),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> _refresh() {
    List<AvailableProduct> tempList = new List();
    Future<List<AvailableProduct>> productNames = futureValue.getProductsFromDB();
    return productNames.then((value) {
      for (int i = 0; i < value.length; i++){
        tempList.add(value[i]);
      }
      if (!mounted) return;
      setState(() {
        names = tempList;
        filteredNames = names;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Container(
          child: _buildList(),
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
                            width: 110.0,
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
                            width: 110.0,
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
            barrierDismissible: false,
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
    final controllerProduct = TextEditingController();
    final controllerQty = TextEditingController();
    final controllerCp = TextEditingController();
    final controllerSp = TextEditingController();

    FlutterMoneyFormatter cpVal;
    FlutterMoneyFormatter spVal;

    return Builder(builder: (context) {
      cpVal = FlutterMoneyFormatter(amount: cp, settings: MoneyFormatterSettings(symbol: 'N'));
      spVal = FlutterMoneyFormatter(amount: sp, settings: MoneyFormatterSettings(symbol: 'N'));
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
                    Text('CP: ${cpVal.output.symbolOnLeft}'),
                    Text('SP: ${spVal.output.symbolOnLeft}'),
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
                                width: 270.0,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: controllerProduct,
                                  decoration: kAddProductDecoration.copyWith(
                                      hintText: "Product name (if needed)"),
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
                                    width: 110.0,
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
                                    width: 110.0,
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

                                        double initialQty = double.parse(controllerQty.text) + iq;
                                        double currentQty =  double.parse(controllerQty.text) + cq;

                                        updateProduct(
                                          name.toString(),
                                          controllerProduct.text.toString(),
                                          initialQty,
                                          double.parse(controllerCp.text),
                                          double.parse(controllerSp.text),
                                          currentQty);

                                        refreshData();

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
                      barrierDismissible: false,
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
    var api = new RestDataSource();
    var product = AvailableProduct();
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      return null;
    }
    try {
      product.productName = capitalize(productName);
      product.costPrice = costPrice.toString();
      product.sellingPrice = sellingPrice.toString();
      product.initialQuantity = initialQuantity.toString();
      product.currentQuantity /*= currentQuantity*/ = initialQuantity.toString();

      api.addProduct(product).then((value) {
        Fluttertoast.showToast(
            msg: "${product.productName} was added",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black);
      }).catchError((Object error) {
        Fluttertoast.showToast(
            msg: "${error.toString()}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black);
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error in adding data",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black);
    }
  }

  void updateProduct(String name, String updateName, double initialQty, double cp, double sp, double currentQty,){
    var api = new RestDataSource();
    var product = AvailableProduct();

    try {
      if(updateName == ""){
        product.productName = name;
      }else{
        product.productName = capitalize(updateName);
      }
      product.costPrice = cp.toString();
      product.sellingPrice = sp.toString();
      product.initialQuantity = initialQty.toString();
      product.currentQuantity = currentQty.toString();

      api.updateProduct(product, name);

      Fluttertoast.showToast(
          msg: "$name is updated",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error in adding data",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black);
    }
  }

}
