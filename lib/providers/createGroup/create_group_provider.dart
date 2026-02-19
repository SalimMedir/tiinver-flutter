import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiinver_project/constants/images_path.dart';
import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../../constant.dart';

class CreateGroupProvider extends ChangeNotifier{

  var groupC = TextEditingController();

  int? groupToken;

  bool isLoading = false;

  Future<void> createGroup({
    creatorId,
    userApiKey,
    groupType
  }) async {
    isLoading = true;
    notifyListeners();
    try {

      Random random = Random();
      groupToken = random.nextInt(9000) + 1000; // Ensures the code is 4 digits
      groupToken.toString();

      final body = {
        'token': groupToken,
        'name': groupC.text,
        'description': 'Group Created Successfully',
        'profile_picture': ImagesPath.profileImage.toString(),
        'type': groupType,
        'creator': creatorId,
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header2(userApiKey),
          endPoint: Endpoint.createGroup
      );

      debugPrint("message: ${res.body}");
      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final message = jsonResponse['message'];
        debugPrint("message: ${res.body}");

        if(error){
          Get.snackbar("error", message);
        }else{
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

}