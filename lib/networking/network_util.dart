import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NetworkHelper{
  // next three lines makes this class a Singleton
  static NetworkHelper _instance = new NetworkHelper.internal();
  NetworkHelper.internal();
  factory NetworkHelper() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> postLogin(String url, {Map headers, body, encoding}) {
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
  }

  Future<dynamic> get(String url, {Map headers, body}) {
    return http
        .get(url, headers: headers)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("$statusCode , $res");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> put(String url, {Map headers, body, encoding}) {
    return http
        .put(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("$statusCode , $res");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> delete(String url, {Map headers}) {
    return http
        .delete(url, headers: headers)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("$statusCode , $res");
      }
      return _decoder.convert(res);
    });
  }
}



