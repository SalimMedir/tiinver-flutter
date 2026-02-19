import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;


class ForgotPasswordApiServices {

  var data;

  final String baseUrl = 'https://tiinver.com/api/v1';

  Future forgotPassword(String email, String newPassword) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    debugPrint("UserName $email $newPassword");

    var body = {
      'phoneOrEmail': email,
      'newPassword': newPassword,
    };

    String encodedBody = body.entries
        .map((entry) =>
    '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}')
        .join('&');

    final response = await http.post(
      Uri.parse('$baseUrl/forgotpassword'),
      headers: headers,
      body: encodedBody,
    );

    data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {

      debugPrint("Response $data");
      debugPrint(data["message"].toString());
      log("Status code ${response.statusCode}");
      Get.snackbar("${data["message"]}", "");


    } else {

      log("Status code ${response.statusCode}");
      debugPrint("Response $data");
      Get.snackbar("Failed to Change Password", "");
      throw Exception('Failed to Change Password');

    }
  }
}
