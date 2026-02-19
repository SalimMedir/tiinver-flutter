import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../../constant.dart';
import '../../models/feedTimeLineModel/feed_time_line_model.dart';
import '../../models/getUserModel/get_user_model.dart';
import '../signIn/sign_in_provider.dart';

class OtherUserProfileProvider extends ChangeNotifier{

  bool isLoading = false;

  GetUserModel? _userModel;

  GetUserModel? get userModel => _userModel;

  final StreamController<List<Activity>> _mediaController = StreamController<List<Activity>>.broadcast();
  Stream<List<Activity>> get mediaStream => _mediaController.stream;

  List<Activity> _media = [];

  List<Activity> get media => _media;

  Future<void> fetchMedia(int actorId, int id, int limit, int offset, String userApiKey) async {
    try {
      final response = await ApiService.get(
        Endpoint.getMedia(actorId ,id, limit, offset),
        header2(userApiKey),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (!jsonResponse['error']) {
          final List<Activity> activities = (jsonResponse['activities'] as List)
              .map((activity) => Activity.fromJson(activity))
              .toList();
          _mediaController.add(activities);
          _media = (jsonResponse['activities'] as List)
              .map((activity) => Activity.fromJson(activity))
              .toList();
          notifyListeners();
        } else {
          _mediaController.addError('Failed to load timeline');
        }
      } else {
        _mediaController.addError('Failed to load timeline');
      }
    } catch (e) {
      _mediaController.addError(e.toString());
    }
  }

  getOtherUserProfile(context,userId) async {
    try{

      isLoading = true;

      var res = await ApiService.get(
          Endpoint.getUser(
            userId,
            int.parse(Provider.of<SignInProvider>(context,listen: false).userId!),),
          header2(Provider.of<SignInProvider>(context,listen: false).userApiKey));

      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> jsonResponse = json.decode(res.body);
        if (jsonResponse['error'] == false) {

          _userModel = GetUserModel.fromJson(jsonResponse['userData']);

          // Assign values to variables
          // nameController.text = _userModel!.firstname!;
          // qualificationController.text = _userModel!.qualification!;
          // workController.text = _userModel!.work!;
          // schoolController.text = _userModel!.school!;
          // locationController.text = _userModel!.location!;

          //log("*******${name}******");

          notifyListeners();
        } else {
          throw Exception('Failed to load users');
        }
        //log(followingsList.toString());
      }
    }catch(e){
      print(e);
    }
    finally{
      isLoading = false;
    }
  }

  Future<void> blockUser({
    required String userId,
    required String userName,
    required String blockUserName,
    required String blockUserId,
    required String userApiKey,
  }) async {
    isLoading = true;
    notifyListeners();
    try {

      final body = {
        'username_blocked': blockUserName,
        'username': userName,
        'userId': userId,
        'user_blocked_id': blockUserId,
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header2(userApiKey),
          endPoint: Endpoint.blockUser);

      log("message: ${res.body}");
      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final message = jsonResponse['user'];
        log("message: ${res.body}");

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


  Future<void> reportUser({
    required String userId,
    required String userName,
    required String msg,
    required String userApiKey,
  }) async {
    isLoading = true;
    notifyListeners();
    try {

      final body = {
        'userId': userId,
        'username': userName,
        'message': msg,
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header2(userApiKey),
          endPoint: Endpoint.report);

      log("message: ${res.body}");
      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final message = jsonResponse['message'];
        log("message: ${res.body}");

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