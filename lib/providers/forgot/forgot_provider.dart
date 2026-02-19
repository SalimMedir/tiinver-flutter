import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tiinver_project/api_services/forgot_password_services/forgot_password_services.dart';
import 'package:tiinver_project/routes/routes_name.dart';
import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../../constant.dart';
import '../../models/forgotPassword/forgot_password_model.dart';


class ForgotProvider with ChangeNotifier {

  var emailC = TextEditingController();
  var passwordC = TextEditingController();
  var confirmPasswordC = TextEditingController();

  bool obscureText1 = true;

  bool obscureText2 = true;

  ForgotPasswordModel? _userForgotModel;

  ForgotPasswordModel? get userForgotModel => _userForgotModel;

  bool isLoading = false;

  ForgotPasswordModel? _user;

  final ForgotPasswordApiServices _apiService = ForgotPasswordApiServices();

  ForgotPasswordModel? get user => _user;

  Future<void> newPasswordReset() async {
    isLoading = true;
    notifyListeners();
    try {

      final body = {
        'phoneOrEmail': emailC.text,
        'newPassword': passwordC.text,
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header1,
          endPoint: Endpoint.forgotPassword
      );

      log("Status In Provider: ${res.body}");
      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final message = jsonResponse['message'];
        log("message: ${res.body}");

        if(error){
          Get.snackbar("error", message);
        }else{
          Get.snackbar("success", message);
          Get.offAllNamed(RoutesName.signIn);
        }
      }
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }finally{
      isLoading = false;
      notifyListeners();
    }

  }

  Future<void> emailExist() async {
    String email = emailC.text;
    isLoading = true;
    notifyListeners();
    try {

      final body = {
        'phoneOrEmail': email,
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header1,
          endPoint: "https://tiinver.com/api/v1/isPhoneOrEmailExiste"
      );

      log("Status In Provider: ${res.body}");
      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final message = jsonResponse['message'];
        log("message: ${res.body}");

        if(error){
          Get.snackbar("error", message);
        }else{
          Get.snackbar("success", message);
          Get.toNamed(RoutesName.newPassword);
          // final user = UserLoginModel.fromJson(jsonResponse);
          // var sp = await SharedPreferences.getInstance();
          // sp.setString(DbKeys.userApiKey, jsonDecode(res.body)["user"]["apiKey"].toString());
          // sp.setString('userModel', json.encode(user.toJson()));
          // Get.offAllNamed(RoutesName.bottomNavigationBar);
        }
      }
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  hidePassword(){
    obscureText1 = !obscureText1;
    notifyListeners();
  }

  hideConfirmPassword(){
    obscureText2 = !obscureText2;
    notifyListeners();
  }


}
