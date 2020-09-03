import 'dart:async';
import 'dart:io';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:ayolee_stores/model/productDB.dart';
import 'package:ayolee_stores/model/create_user.dart';
import 'package:ayolee_stores/model/product_history.dart';
import 'package:ayolee_stores/model/product_history_details.dart';
import 'package:ayolee_stores/model/reportsDB.dart';
import 'package:ayolee_stores/model/store_details.dart';
import 'package:ayolee_stores/model/user.dart';
import 'network_util.dart';

/// A [RestDataSource] class to do all the send request to the back end
/// and handle the result
class RestDataSource {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Instantiating a class of the [NetworkHelper]
  NetworkHelper _netUtil = new NetworkHelper();

  static final BASE_URL = "https://ayolee-stores.herokuapp.com";

  static final LOGIN_URL = BASE_URL + "/authentication/login";
  static final SIGN_UP_URL = BASE_URL + "/authentication/signup";

  static final ADD_PRODUCT_URL = BASE_URL + "/product/addProduct";
  static final UPDATE_PRODUCT_URL = BASE_URL + "/product/editProduct";
  static final FETCH_PRODUCTS_URL = BASE_URL + "/product/fetchAllProducts";
  static final FETCH_PRODUCT_URL = BASE_URL + "/product/fetchProduct";

  static final ADD_REPORT_URL = BASE_URL + "/report/addNewReport";
  static final UPDATE_REPORT_NAME_URL = BASE_URL + "/report/updateReportName";
  static final FETCH_REPORT_URL = BASE_URL + "/report/fetchAllReports";
  static final DELETE_REPORT_URL = BASE_URL + "/report/deleteReport";

  static final ADD_PRODUCT_HISTORY_URL = BASE_URL + "/history/addProductHistory";
  static final ADD_HISTORY_TO_PRODUCT_URL = BASE_URL + "/history/addNewProductToHistory";
  static final FETCH_PRODUCT_HISTORY_URL = BASE_URL + "/history/fetchProductHistory";
  static final FIND_PRODUCT_HISTORY_URL = BASE_URL + "/history/findProductHistory";
  static final UPDATE_PRODUCT_HISTORY_NAME_URL = BASE_URL + "/history/updateProductName";
  static final DELETE_PRODUCT_HISTORY_URL = BASE_URL + "/history/deleteHistory";

  static final FETCH_STORE_URL = BASE_URL + "/fetchStoreDetails";

  /// A function that verifies login details from the server POST.
  /// with [phoneNumber] and [pin]
  Future<User> login(String phoneNumber, String pin) {
    return _netUtil.postLogin(LOGIN_URL, body: {
      "phone": phoneNumber,
      "password": pin
    }).then((dynamic res) {
      if(res["error"] == true){
        print(res["error"]);
        throw (res["message"]);
      } else {
        print(res["error"]);
        return User.map(res["data"]);
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw (e);
    });
  }

  /// A function that creates a new user POST.
  /// with [CreateUser] model
  Future<dynamic> signUp(CreateUser createUser) {
    return _netUtil.post(SIGN_UP_URL, body: {
      "name": createUser.name,
      "phone": createUser.phoneNumber,
      "type": "Worker",
      "password": createUser.pin,
      "confirmPassword": createUser.confirmPin
    }).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in creating user, try again");
    });
  }

  /// A function that adds new product to the server POST
  /// with [Product] model
  Future<dynamic> addProduct(Product product) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });

    return _netUtil.post(ADD_PRODUCT_URL, headers: header, body: {
      "productName": product.productName,
      "costPrice": product.costPrice.toString(),
      "sellingPrice": product.sellingPrice.toString(),
      "initialQty": product.initialQuantity.toString(),
      "currentQty": product.currentQuantity.toString(),
      "createdAt": product.createdAt.toString(),
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in adding product, try again");
    });
  }

  /// A function that updates product details PUT.
  /// with [Product]
  Future<dynamic> updateProduct(Product product, String id) async{
    /// Variable holding today's datetime
    DateTime dateTime = DateTime.now();

    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    final UPDATE_URL = UPDATE_PRODUCT_URL + "/$id";

    return _netUtil.put(UPDATE_URL, headers: header, body: {
      "productName": product.productName,
      "costPrice": product.costPrice.toString(),
      "sellingPrice": product.sellingPrice.toString(),
      "initialQty": product.initialQuantity.toString(),
      "currentQty": product.currentQuantity.toString(),
      "updatedAt":  dateTime.toString(),
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in updating product, try again");
    });
  }

  /// A function that fetches a particular product from the server
  /// into a model of [Product] GET.
  Future<Product> fetchProduct(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw new Exception("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    final FETCH_URL = FETCH_PRODUCT_URL + "$id";
    return _netUtil.get(FETCH_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return Product.fromJson(res["data"]);
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching product, try again");
    });
  }

  /// A function that fetches all products from the server
  /// into a List of [Product] GET.
  Future<List<Product>> fetchAllProducts() async {
    List<Product> products;
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_PRODUCTS_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        var rest = res["data"] as List;
        products = rest.map<Product>((json) => Product.fromJson(json)).toList();
        return products;
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching products, try again");
    });
  }

  /// A function that adds new daily reports to the server POST.
  /// with [Reports] model
  Future<dynamic> addNewDailyReport(Reports reportsData) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });

    return _netUtil.post(ADD_REPORT_URL, headers: header, body: {
      "quantity": reportsData.quantity.toString(),
      "productName": reportsData.productName,
      "costPrice": reportsData.costPrice.toString(),
      "unitPrice": reportsData.unitPrice.toString(),
      "totalPrice": reportsData.totalPrice.toString(),
      "paymentMode": reportsData.paymentMode.toString(),
      "createdAt": reportsData.createdAt.toString()
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in saving ${reportsData.productName}, try again");
    });
  }

  /// A function that updates report product name to the server PUT.
  /// with [Reports] model
  Future<dynamic> updateReportName(String productName, String updatedName) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });

    return _netUtil.put(UPDATE_REPORT_NAME_URL, headers: header, body: {
      "productName": productName,
      "updatedName": updatedName,
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in updating $productName, try again");
    });
  }

  /// A function that fetches all reports from the server
  /// into a List of [Reports] GET.
  Future<List<Reports>> fetchAllReports() async {
    List<Reports> reports;
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_REPORT_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        var result = res["data"] as List;
        reports = result.map<Reports>((json) => Reports.fromJson(json)).toList();
        return reports;
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching reports, try again");
    });
  }

  /// A function that fetches deletes a report from the server using the [id]
  Future<dynamic> deleteReport(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    final DELETE_URL = DELETE_REPORT_URL + "/$id";
    return _netUtil.delete(DELETE_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        print(res['message']);
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in deleting report, try again");
    });
  }

  /// A function that fetches a the store details from the server
  /// into a model of [StoreDetails] GET.
  Future<StoreDetails> fetchStoreDetails() async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_STORE_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return StoreDetails.fromJson(res["data"]);
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching store details, try again");
    });
  }

  /// A function that adds new product history to the database POST
  /// with [ProductHistoryDetails] model
  Future<dynamic> addProductHistory(String productName, ProductHistoryDetails productHistoryDetails) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.post(ADD_PRODUCT_HISTORY_URL, headers: header, body: {
      "productName": productName,
      "initialQty": productHistoryDetails.initialQty,
      "qtyReceived": productHistoryDetails.qtyReceived,
      "currentQty": productHistoryDetails.currentQty,
      "collectedAt": productHistoryDetails.collectedAt,
      "createdAt": DateTime.now().toString(),
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in adding product history, try again");
    });
  }

  /// A function that adds new reports to a customer reports details POST.
  /// with [ProductHistoryDetails]
  Future<dynamic> addHistoryToProduct(String id, ProductHistoryDetails productHistoryDetails) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.post(ADD_HISTORY_TO_PRODUCT_URL, headers: header, body: {
      "id": id,
      "initialQty": productHistoryDetails.initialQty,
      "qtyReceived": productHistoryDetails.qtyReceived,
      "currentQty": productHistoryDetails.currentQty,
      "collectedAt": productHistoryDetails.collectedAt,
    }).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in adding history to product history, try again");
    });
  }

  /// A function that fetches a particular product history from the database
  /// into a model of [ProductHistory] GET.
  Future<ProductHistory> findProductHistory(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    final FETCH_URL = FIND_PRODUCT_HISTORY_URL + "/$id";
    return _netUtil.get(FETCH_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return ProductHistory.fromJson(res["data"]);
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching product history, try again");
    });
  }

  /// A function that fetches all product history from the database
  /// into a List of [ProductHistory] GET.
  Future<List<ProductHistory>> fetchAllProductHistory() async {
    List<ProductHistory> history;
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_PRODUCT_HISTORY_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        var rest = res["data"] as List;
        history = rest.map<ProductHistory>((json) => ProductHistory.fromJson(json)).toList();
        return history;
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      print(e);
      throw ("Error in fetching product history, try again");
    });
  }

  /// A function that updates a product history name from the database using the [id]
  /// and the [name] to be updated to  PUT
  Future<dynamic> updateProductHistoryName(String id, String name) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.put(UPDATE_PRODUCT_HISTORY_NAME_URL, headers: header, body: {
      "id": id,
      "name": name,
    }).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in deleting product history, try again");
    });
  }

  /// A function that deletes a product history from the database using the [id]
  Future<dynamic> deleteProductHistory(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    final DELETE_URL = DELETE_PRODUCT_HISTORY_URL + "/$id";
    return _netUtil.delete(DELETE_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in deleting product history, try again");
    });
  }

}