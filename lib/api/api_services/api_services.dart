import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ApiError implements Exception {
  final String message;
  final int? statusCode;

  ApiError(this.message, {this.statusCode});

  @override
  String toString() => 'ApiError(statusCode: $statusCode, message: $message)';
}

void _toastError(String message) {
  Fluttertoast.showToast(msg: message);
}

void _handleResponseErrors(http.Response response) {
  final parsed = response.body.isNotEmpty ? jsonDecode(response.body) : null;
  final message = parsed is Map<String, dynamic>
      ? (parsed['message']?.toString() ?? 'Erreur API')
      : 'Erreur API';

  if (response.statusCode < 200 || response.statusCode >= 300) {
    _toastError(message);
    throw ApiError(message, statusCode: response.statusCode);
  }

  if (parsed is Map<String, dynamic> && parsed['error'] == true) {
    _toastError(message);
    throw ApiError(message, statusCode: response.statusCode);
  }
}

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
      _handleResponseErrors(response);
      return response;
    } on SocketException {
      const message = 'Vérifiez votre connexion';
      _toastError(message);
      throw ApiError(message);
    } on TimeoutException {
      const message = 'Délai d\'attente dépassé';
      _toastError(message);
      throw ApiError(message);
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
      _handleResponseErrors(response);
      return response;
    } on SocketException {
      const message = 'Vérifiez votre connexion';
      _toastError(message);
      throw ApiError(message);
    } on TimeoutException {
      const message = 'Délai d\'attente dépassé';
      _toastError(message);
      throw ApiError(message);
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
      _handleResponseErrors(response);
      return response;
    } on SocketException {
      const message = 'Vérifiez votre connexion';
      _toastError(message);
      throw ApiError(message);
    } on TimeoutException {
      const message = 'Délai d\'attente dépassé';
      _toastError(message);
      throw ApiError(message);
    } on Exception catch (e) {
      log(e.runtimeType.toString());
      log(e.toString());
      rethrow;
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
      _handleResponseErrors(response);
      return response;
    } on SocketException {
      const message = 'Vérifiez votre connexion';
      _toastError(message);
      throw ApiError(message);
    } on TimeoutException {
      const message = 'Délai d\'attente dépassé';
      _toastError(message);
      throw ApiError(message);
    } on Exception catch (e) {
      log(e.runtimeType.toString());
      log(e.toString());
      rethrow;
    }
  }
}
