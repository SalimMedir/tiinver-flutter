import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<http.Response> delete(
      String endPoint,
      Map<String, String> headers,
      ) async {
    try {
      final Uri url = Uri.parse(endPoint);
      http.Response response = await http.delete(
        url,
        headers: headers,
      );
      log('url:: $url');
      log('headers:: $headers');
      log('status code:: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 204) {
        log('___success___');
        return response;
      } else {
        return response;
      }
    } on SocketException {
      throw Exception('SocketException');
    } on TimeoutException {
      throw Exception('TimeoutException');
    }
  }

  static Future<http.Response> get(
      String endPoint,
      Map<String, String> headers,
      ) async {
    try {
      final Uri url = Uri.parse(endPoint);
      http.Response response = await http.get(
        url,
        headers: headers,
      );
      log('url:: $url');
      log('headers:: $headers');
      log('status code:: ${response.statusCode}');
      log('response:: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('___success___');
        return response;
      } else {
        return response;
      }
    } on SocketException {
      throw Exception('SocketException');
    } on TimeoutException {
      throw Exception('TimeoutException');
    }
    // throw Exception('error');
  }

  static Future<http.Response> post({
    required String requestBody,
    required headers,
    required String endPoint,
  }) async {
    try {
      final Uri url = Uri.parse(endPoint);
      http.Response response = await http.post(
        url,
        headers: headers,
        body: requestBody,
      );
      log('hears:: $headers');
      log('url:: $url');
      log('status code:: ${response.statusCode}');
      log('body:: $requestBody');
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('___success___');
        return response;
      } else {
        return response;
      }
    } on SocketException {
      throw Exception('SocketException');
    } on TimeoutException {
      throw Exception('TimeoutException');
    } on Exception catch (e) {
      log(e.runtimeType.toString());
      log(e.toString());
      throw Exception('error');
    }
  }
  static Future<http.Response> put({
    required Map<String, dynamic> requestBody,
    required headers,
    required String endPoint,
  }) async {
    try {
      final Uri url = Uri.parse(endPoint);
      http.Response response = await http.put(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );
      log('hears:: $headers');
      log('url:: $url');
      log('status code:: ${response.statusCode}');
      log('body:: $requestBody');
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('___success___');
        return response;
      } else {
        return response;
      }
    } on SocketException {
      throw Exception('SocketException');
    } on TimeoutException {
      throw Exception('TimeoutException');
    } on Exception catch (e) {
      log(e.runtimeType.toString());
      log(e.toString());
      throw Exception('error');
    }
  }
}
