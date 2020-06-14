import 'dart:async';
import 'package:ayolee_stores/bloc/future_values.dart';
import 'package:ayolee_stores/model/available_productDB.dart';
import 'package:ayolee_stores/model/create_user.dart';
import 'package:ayolee_stores/model/daily_reportsDB.dart';
import 'package:ayolee_stores/model/user.dart';
import 'network_util.dart';

/// A [RestDataSource] class to do all the send request to the back end
/// and handle the result
class RestDataSource {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Instantiating a class of the [NetworkHelper]
  NetworkHelper _netUtil = new NetworkHelper();

  static final BASE_URL = "https://mob-ap.herokuapp.com";
  static final LOGIN_URL = BASE_URL + "/authentication/signIn";
  static final SIGN_UP_URL = BASE_URL + "/authentication/signUp";
  static final ADD_PRODUCT_URL = BASE_URL + "/product/create";
  static final SELl_PRODUCT_URL = BASE_URL + "/product/sell";
  static final FETCH_PRODUCT_URL = BASE_URL + "/product/fetchAll";
  static final ADD_REPORT_URL = BASE_URL + "/report/create";
  static final FETCH_REPORT_URL = BASE_URL + "/report/fetchAll";

  /// A function that verifies login details from the server POST.
  /// with [phoneNumber] and [pin]
  Future<User> login(String phoneNumber, String pin) {
    return _netUtil.postLogin(LOGIN_URL, body: {
      "email": phoneNumber,
      "password": pin
    }).then((dynamic res) {
      if(res["error"] == true){
        throw new Exception(res["meesage"]);
      }else{
        return new User.map(res["data"]);
      }
    });
  }

  /// A function that creates a new user POST.
  /// with [CreateUser] model
  Future<String> signUp(CreateUser createUser) {
    return _netUtil.post(SIGN_UP_URL, body: {
      "name": createUser.name,
      "email": createUser.phoneNumber,
      "password": createUser.pin,
      "password_confirmation": createUser.confirmPin
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw new Exception(res["meesage"]);
      }else{
        return res["meesage"];
      }
    });
  }

  /// A function that adds new product to the server POST
  /// with [AvailableProduct] model
  Future<String> addProduct(AvailableProduct product) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    print(header.toString());

    return _netUtil.post(ADD_PRODUCT_URL, headers: header, body: {
      "productName": product.productName,
      "costPrice": product.costPrice.toString(),
      "sellingPrice": product.sellingPrice.toString(),
      "initialQty": product.initialQuantity.toString(),
      "currentQty": product.currentQuantity.toString(),
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw new Exception(res["meesage"]);
      }else{
        print(res["meesage"]);
        return res["meesage"];
      }
    });
  }

  /// A function that updates the current quantity of the product that is sold POST.
  ///  with [productName] and [currentQuantity]
  Future<String> sellProduct(String productName, String currentQuantity) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    print(header.toString());

    return _netUtil.post(SELl_PRODUCT_URL, headers: header, body: {
      "productName": productName,
      "currentQty": currentQuantity,
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw new Exception(res["meesage"]);
      }else{
        print(res["meesage"]);
        return res["meesage"];
      }
    });
  }

  /// A function that updates product details PUT.
  /// with [AvailableProduct] model and [name]
  Future<String> updateProduct(AvailableProduct product, String name) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    print(header.toString());
    final UPDATE_PRODUCT_URL = BASE_URL + "/product/edit/" + "$name";

    return _netUtil.put(UPDATE_PRODUCT_URL, headers: header, body: {
      "productName": product.productName,
      "costPrice": product.costPrice.toString(),
      "sellingPrice": product.sellingPrice.toString(),
      "initialQty": product.initialQuantity.toString(),
      "currentQty": product.currentQuantity.toString(),
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw new Exception(res["meesage"]);
      }else{
        print(res["meesage"]);
        return res["meesage"];
      }
    });
  }

  /// A function that fetches all products from the server
  /// into a List of [AvailableProduct] GET.
  Future<List<AvailableProduct>> fetchAllProducts() async {
    List<AvailableProduct> products;
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_PRODUCT_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw new Exception(res["meesage"]);
      }else{
        var rest = res["data"] as List;
        products = rest.map<AvailableProduct>((json) => AvailableProduct.fromJson(json)).toList();
        return products;
      }
    }).catchError((e){
      throw new Exception(e);
    });
  }

  /// A function that adds new daily reports to the server POST.
  /// with [DailyReportsData] model
  Future<String> addNewDailyReport(DailyReportsData reportsData) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    print(header.toString());

    return _netUtil.post(ADD_REPORT_URL, headers: header, body: {
      "productName": reportsData.productName,
      "qty": reportsData.quantity.toString(),
      "unitPrice": reportsData.unitPrice.toString(),
      "totalPrice": reportsData.totalPrice.toString(),
      "reportTime": reportsData.time.toString(),
      "paymentMode": reportsData.paymentMode.toString()
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw new Exception(res["meesage"]);
      }else{
        return res["meesage"];
      }
    });
  }

  /// A function that fetches all reports from the server
  /// into a List of [DailyReportsData] GET.
  Future<List<DailyReportsData>> fetchAllReports() async {
    List<DailyReportsData> reports;
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_REPORT_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw new Exception(res["meesage"]);
      }else{
        var result = res["data"] as List;
        reports = result.map<DailyReportsData>((json) => DailyReportsData.fromJson(json)).toList();
        return reports;
      }
    });
  }

  /// A function that fetches deletes a report from the server using the [id]
  Future<String> deleteReport(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    print(header.toString());
    final DELETE_REPORT_URL = BASE_URL + "/report/delete/" + "$id";
    return _netUtil.delete(DELETE_REPORT_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw new Exception(res["meesage"]);
      }else{
        print(res["meesage"]);
        return res["meesage"];
      }
    });
  }

}