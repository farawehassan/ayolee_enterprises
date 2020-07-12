import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

/// A network helper class to do all the back end request
class NetworkHelper{

  /// next three lines makes this class a Singleton
  static NetworkHelper _instance = new NetworkHelper.internal();
  NetworkHelper.internal();
  factory NetworkHelper() => _instance;

  /// An object for decoding json values
  final JsonDecoder _decoder = new JsonDecoder();

  /// A function to do the login request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> postLogin (String url, {Map headers, body, encoding}) async {
    try {
      return http
          .post(url, body: body, headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new ErrorDescription("${result['message']}");
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      print(e);
      throw new ErrorDescription (e.toString());
    }
  }

  /// A function to do any get request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> get(String url, {Map headers, body}) async {
    try {
      return
        http
            .get(url, headers: headers)
            .then((http.Response response) {
          final String res = response.body;
          final int statusCode = response.statusCode;
          if (statusCode < 200 || statusCode > 400 || json == null) {
            throw new ErrorDescription("Error while fetching data");
          }
          return _decoder.convert(res);
        });
    } catch (e) {
      print(e);
      throw new ErrorDescription(e.toString());
    }
  }

  /// A function to do any post request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    try {
      return http
          .post(url, body: body, headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new ErrorDescription("$statusCode ,${_decoder.convert(res)["message"]}");
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      print(e);
      throw new ErrorDescription(e.toString());
    }
  }

  /// A function to do any put request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> put(String url, {Map headers, body, encoding}) {
    try {
      return http
          .put(url, body: body, headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new ErrorDescription("$statusCode , ${_decoder.convert(res)["message"]}");
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      print(e);
      throw new ErrorDescription(e.toString());
    }
  }

  /// A function to do any delete request with the url and headers
  /// then sends back a json decoded result
  Future<dynamic> delete(String url, {Map headers}) {
    try {
      return http
          .delete(url, headers: headers)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new ErrorDescription("$statusCode , ${_decoder.convert(res)["message"]}");
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      print(e);
      throw new ErrorDescription(e.toString());
    }
  }

}



