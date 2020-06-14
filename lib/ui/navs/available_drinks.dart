import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

/// A StatefulWidget class that displays available product from the database
class Products extends StatefulWidget {

  static const String id = 'available_drinks';

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  /// Instantiating a class of the [AvailableProduct]
  AvailableProduct product = new AvailableProduct();

  /// Variable of String to hold the productName when you're adding a new product
  String _productName;

  /// Variable of double to hold the costPrice, sellingPrice, initialQuantity
  /// when you're adding a new product
  double _costPrice, _sellingPrice, _initialQuantity;

  /// Variable of int to hold the numbers of product on the page
  int _productLength;

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// GlobalKey of a my form state to validate my form while saving a new product
  final _saveNewFormKey = new GlobalKey<FormState>();

  /// GlobalKey of a my form state to validate my form while updating a product
  final _updateFormKey = new GlobalKey<FormState>();

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  /// A TextEditingController to control the searchText on the AppBar
  final TextEditingController _filter = new TextEditingController();

  /// Variable of String to hold the searchText on the AppBar
  String _searchText = "";

  /// Variable of List<[AvailableProduct]> to hold
  /// the details of all the availableProduct
  List<AvailableProduct> _names = new List();

  /// Variable of List<[AvailableProduct]> to hold
  /// the details of all filtered availableProduct
  List<AvailableProduct> _filteredNames = new List();

  /// Variable to hold an Icon Widget of Search
  Icon _searchIcon = new Icon(Icons.search);

  /// Variable to hold a Widget of Text for the appBarText
  Widget _appBarTitle = new Text('Available Products');

  /// Checking if the filter controller is empty to reset the
  /// _searchText on the appBar to "" and the filteredNames to Names
  _ProductsState(){
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        if (!mounted) return;
        setState(() {
          _searchText = "";
          _filteredNames = _names;
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

  /// Method to capitalize the first letter of each word in a productName [string]
  /// while adding a new product or updating a particular product
  String _capitalize(String string) {
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

  /// Function to refresh details of the Available products
  /// by calling [_getNames()]
  void _refreshData(){
    if (!mounted) return;
    setState(() {
      _getNames();
    });
  }

  /// Function to get all the available products from the database and
  /// setting the details and [_filteredNames] to [_names] plus the numbers of
  /// products to [_productLength]
  void _getNames() async {
    List<AvailableProduct> tempList = new List();
    Future<List<AvailableProduct>> productNames = futureValue.getProductsFromDB();
    await productNames.then((value) {
      for (int i = 0; i < value.length; i++){
        tempList.add(value[i]);
      }
    }).catchError((onError){
      return Fluttertoast.showToast(
          msg: "Error in fetching data",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black);
    });
    if (!mounted) return;
    setState(() {
      _productLength = tempList.length;
      _names = tempList;
      _filteredNames = _names;
    });
  }

  /// Function to change icons on the appBar when the searchIcon or closeIcon
  /// is pressed then sets the TextController to [_filter] and hintText of
  /// 'Search...' if it was the searchIcon or else it resets the AppBar to its
  /// normal state
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
        _filteredNames = _names;
        _filter.clear();
      }
    });
  }

  /// A function to build the AppBar of the page by calling
  /// [_searchPressed()] when the icon is pressed
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

  /// A function to build the list of the available products by using a
  /// SimpleFoldingCell library to display its details in the [_buildFrontWidget()],
  /// [_buildInnerTopWidget()] and [_buildInnerBottomWidget()]
  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List<AvailableProduct> tempList = new List();
      for (int i = 0; i < _filteredNames.length; i++) {
        if (_filteredNames[i].productName.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(_filteredNames[i]);
        }
      }
      _filteredNames = tempList;
    }
    if(_filteredNames.length > 0 && _filteredNames.isNotEmpty){
      return ListView.builder(
        itemCount: _names == null ? 0 : _filteredNames.length,
        itemBuilder: (BuildContext context, int index) {
          return SimpleFoldingCell(
              frontWidget: _buildFrontWidget(
                  _filteredNames[index].productName),
              innerTopWidget: _buildInnerTopWidget(
                  _filteredNames[index].productName),
              innerBottomWidget: _buildInnerBottomWidget(
                  _filteredNames[index].productName,
                  double.parse(_filteredNames[index].initialQuantity),
                  double.parse(_filteredNames[index].currentQuantity),
                  double.parse(_filteredNames[index].costPrice),
                  double.parse(_filteredNames[index].sellingPrice)),
              cellSize: Size(MediaQuery.of(context).size.width, 90),
              padding: EdgeInsets.all(8.0),
              animationDuration: Duration(milliseconds: 300),
              borderRadius: 10,
              onOpen: () => print('$index cell opened'),
              onClose: () => print('$index cell closed'));
        },
      );
    }
    else if(_productLength == 0){
      return Container(
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

  /// Function to refresh details of the Available products similar to the
  /// [_getNames()] method but this is from the RefreshIndicator
  Future<Null> _refresh() {
    List<AvailableProduct> tempList = new List();
    Future<List<AvailableProduct>> productNames = futureValue.getProductsFromDB();
    return productNames.then((value) {
      for (int i = 0; i < value.length; i++){
        tempList.add(value[i]);
      }
      if (!mounted) return;
      setState(() {
        _names = tempList;
        _filteredNames = _names;
      });
    });
  }

  /// Calls [_getNames()] before the class builds its widgets
  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  /// Building a Scaffold Widget to display [_buildList()] and a
  /// floatingActionButton to display a form to add new product when pressed
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
                height: 340.0,
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _saveNewFormKey,
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
                            _productName = value;
                          },
                          onSaved: (value) {
                            this._productName = value;
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
                            _initialQuantity = double.parse(value);
                          },
                          onSaved: (value) {
                            this._initialQuantity = double.parse(value);
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
                                _costPrice = double.parse(value);
                              },
                              onSaved: (value) {
                                this._costPrice = double.parse(value);
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
                                _sellingPrice = double.parse(value);
                              },
                              onSaved: (value) {
                                this._sellingPrice = double.parse(value);
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
                                if (this._saveNewFormKey.currentState.validate()) {
                                  _saveNewFormKey.currentState.save();
                                } else {
                                  return null;
                                }
                                _saveNewProduct();
                                Navigator.of(context)
                                    .pop(); // To close the dialog
                                _refreshData();
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

  /// Function that builds the FrontWidget of the SimpleFoldingCell by displaying
  /// the [productName] and opening the InnerTopWidget when the card is pressed
  Widget _buildFrontWidget(String productName) {
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

  /// Function that builds the InnerTopWidget of the SimpleFoldingCell by
  /// displaying the [productName] at the top when the FrontWidget is pressed
  Widget _buildInnerTopWidget(String productName) {
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


  /// Function that builds the InnerBottomWidget of the SimpleFoldingCell by
  /// displaying the details of the product [name], [iq], [cq], [cp], [sp]
  /// and also update the productDetails by calling [_updateProduct()]
  /// when the info icon is pressed and the form is filled
  Widget _buildInnerBottomWidget(
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
                          height: 320.0,
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _updateFormKey,
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
                                    onChanged: (value) {
                                      controllerQty.text = value;
                                    },
                                    onSaved: (value) {
                                      controllerQty.text = value;
                                    },
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
                                        onChanged: (value) {
                                          controllerCp.text = value;
                                        },
                                        onSaved: (value) {
                                          controllerCp.text = value;
                                        },
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
                                        validator: (val) =>
                                        val.length == 0 ? "Enter SP" : null,
                                        onChanged: (value) {
                                          controllerSp.text = value;
                                        },
                                        onSaved: (value) {
                                          controllerSp.text = value;
                                        },
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
                                          if (this._updateFormKey.currentState.validate()) {
                                            _updateFormKey.currentState.save();
                                          } else {
                                            return null;
                                          }

                                          double initialQty = double.parse(controllerQty.text) + iq;
                                          double currentQty =  double.parse(controllerQty.text) + cq;

                                          _updateProduct(
                                            name.toString(),
                                            controllerProduct.text.toString(),
                                            initialQty,
                                            double.parse(controllerCp.text),
                                            double.parse(controllerSp.text),
                                            currentQty
                                          );

                                          _refreshData();

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

  /// Using flutter toast to display a toast message [message]
  void _showMessage(String message){
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black);
  }

  /// Function to check whether a product exists or not
  /// It returns true if it does and false if it does not
  Future<bool> _checkIfProductExists(String name) async {
    bool response;
    Future<List<AvailableProduct>> productNames = futureValue.getProductFromDB();
    await productNames.then((value) {
      for (int i = 0; i < value.length; i++){
         if(name == value[i].productName){
           response = true;
         }
         else{
           response = false;
         }
      }
    }).catchError((onError){
       _showMessage( "Error in fetching data");
       response = false;
    });
    return response;
  }

  /// Function that adds new product to the database by calling
  /// [addProduct] in the [RestDataSource] class
  void _saveNewProduct() async {
    var api = new RestDataSource();
    var product = AvailableProduct();

    Future<bool> exists = _checkIfProductExists(_capitalize(_productName));
    await exists.then((value) {
      if (value == true){
        _updateProduct(
          _capitalize(_productName),
          _capitalize(_productName),
          _initialQuantity,
          _costPrice,
          _sellingPrice,
          _initialQuantity
        );
      }
      else {
        try {
          product.productName = _capitalize(_productName);
          product.costPrice = _costPrice.toString();
          product.sellingPrice = _sellingPrice.toString();
          product.initialQuantity = _initialQuantity.toString();
          product.currentQuantity = _initialQuantity.toString();

          api.addProduct(product).then((value) {
            _showMessage("${product.productName} was added");
          }).catchError((Object error) {
            _showMessage("${error.toString()}");
          });
        } catch (e) {
          _showMessage( "Error in adding data");
        }
      }
    }).catchError((onError){
      _showMessage( "Error in fetching data");
    });

  }

  /// Function to update the details of a product in the database by calling
  /// [updateProduct] in the [RestDataSource] class
  void _updateProduct(String name, String updateName, double initialQty, double cp, double sp, double currentQty,){
    var api = new RestDataSource();
    var product = AvailableProduct();

    try {
      if(updateName == ""){
        product.productName = name;
      }else{
        product.productName = _capitalize(updateName);
      }
      product.costPrice = cp.toString();
      product.sellingPrice = sp.toString();
      product.initialQuantity = initialQty.toString();
      product.currentQuantity = currentQty.toString();

      api.updateProduct(product, name);

      _showMessage( "$name is updated");
    } catch (e) {
      print(e);
      _showMessage( "Error in adding data");
    }
  }

}
