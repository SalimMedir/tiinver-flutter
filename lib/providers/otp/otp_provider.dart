import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/api/api_services/api_services.dart';
import 'package:tiinver_project/api/endpoint/endpoint.dart';
import 'package:tiinver_project/constant.dart';
import 'package:tiinver_project/routes/routes_name.dart';

import '../signUp/sign_up_provider.dart';

class OtpProvider extends ChangeNotifier{

  late Timer _timer;
  int _start = 60;

  int get start => _start;
  int? code;

  bool isLoading = false;

  Future<void> otpSend(email) async {
    Random random = Random();
    code = random.nextInt(9000) + 1000; // Ensures the code is 4 digits
    code.toString();
    isLoading = true;
    notifyListeners();
    try {

      var body = {
        'to': email,
        'subject': "OTP",
        'message': code.toString(),
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header1,
          endPoint: Endpoint.sendOtp
      );

      debugPrint(res.body);
      var error = jsonDecode(res.body)["error"];
      if(res.statusCode == 200 || res.statusCode == 201){
        var message = jsonDecode(res.body)["message"];
        if(error){
          Get.snackbar("error", message);
        }else{
          startTimer();
          Get.toNamed(RoutesName.otpVerificationScreen);
          Get.snackbar("success", message);
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

  otpVerification(int otp,context)async {
    if(code == otp){
      isLoading = true;
      notifyListeners();
      await Provider.of<SignUpProvider>(context, listen: false).signUp(context).whenComplete(() async{
        // Provider.of<SignUpProvider>(context, listen: false).storeUserApiKey();
        isLoading = false;
        notifyListeners();
      }).onError((error, stackTrace) {
        Get.snackbar("Error", "$error");
        isLoading = false;
      },);
    }else{
      Get.snackbar("Error", "Invalid Pin");
    }

  }

  void startTimer() {
    _start = 60;
    notifyListeners();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        timer.cancel();
        performFunction();
      } else {
        _start--;
        notifyListeners();
      }
    });
  }

  void performFunction() {
    code = 0;
    notifyListeners();
  }

@override
void dispose() {
  _timer.cancel();
  super.dispose();
}


}