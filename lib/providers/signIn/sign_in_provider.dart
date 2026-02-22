import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiinver_project/api_services/sp_services.dart';
import 'package:tiinver_project/screens/auth_screens/signin_screen/sign_in_screen.dart';

import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../../constant.dart';
import '../../constants/firebase.dart';
import '../../db_keys.dart';
import '../../models/login/user_login_model.dart';
import '../../routes/routes_name.dart';
import '../dashboard/dashboard_provider.dart';
import '../suggestions/suggestions_provider.dart';


class SignInProvider with ChangeNotifier {

  bool obscureText = true;

  String? _userApiKey;
  String? _userId;
  String? _userEmail;
  String? _userPhone;

  String? get userApiKey => _userApiKey;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;

  bool isLoading = false;

  UserLoginModel _user = UserLoginModel();

  UserLoginModel get user => _user;

  // SignInProvider() {
  //   loadUserFromPreferences();
  // }

  // Future<void> loadUserFromPreferences() async {
  //   var sp = await SharedPreferences.getInstance();
  //   String? userJson = sp.getString('userModel');
  //   if (userJson != null) {
  //     _user = UserLoginModel.fromJson(json.decode(userJson));
  //   }
  //   notifyListeners();
  // }

  Future<void> login(String email, String password, context) async {
    isLoading = true;
    notifyListeners();
    try {

      final body = {
        'username': email,
        'password': password,
        'provider': 'email',
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header1,
          endPoint: Endpoint.login
      );

      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final message = jsonResponse['message'];
        log("message: ${res.body}");

        if(error){
          Get.snackbar("error", message);
        }else{
          Get.snackbar("success", message);
          Get.offAllNamed(RoutesName.bottomNavigationBar);

          _user = UserLoginModel.fromJson(jsonResponse['user']);

          fireStore.collection("users").doc(_user.id.toString()).set({
            "id" : _user.id.toString(),
            "apiKey" : _user.apiKey.toString(),
            "email" : _user.email.toString(),
            "phone" : _user.phone.toString(),
            "subscribe" : _user.subscribe.toString(),
            "blocked_users" : _user.blockedUsers,
            "type" : _user.type.toString(),
            "username" : _user.username.toString(),
            "firstname" : _user.firstname.toString(),
            "lastname" : _user.lastname.toString(),
            "profile" : _user.profile.toString(),
            "verify" : _user.verify.toString(),
            "active" : _user.active.toString(),
            "followers" : _user.followers.toString(),
            "following" : _user.following.toString(),
            "location" : _user.location.toString(),
            "school" : _user.school.toString(),
            "qualification" : _user.qualification.toString(),
            "birthday" : _user.birthday.toString(),
            "work" : _user.work.toString(),
            "coinsAmount" : _user.coinsAmount.toString(),
            "stamp" : _user.stamp.toString(),
          });

          var sp = await SharedPreferences.getInstance();
          sp.setString(DbKeys.userApiKey, _user.apiKey!);
          sp.setString(DbKeys.tiinverToken, _user.apiKey!);
          sp.setString(DbKeys.userId, _user.id!.toString());
          sp.setString(DbKeys.userEmail, _user.email!);
          sp.setString(DbKeys.userPhone, _user.phone!);
          _userApiKey = _user.apiKey;
          Provider.of<SuggestionsProvider>(context, listen: false).fetchSuggestions(
            int.parse(_user.id.toString()),
            _user.apiKey.toString(),
          );

          Provider.of<DashboardProvider>(context, listen: false).fetchTimeline(
            int.parse(userId.toString()),
            100,
            0,
            userApiKey.toString(),
          );

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

  storeApiKeyAndId({required String apiKey,required String id}) async {
    var sp = await SharedPreferences.getInstance();
    _userApiKey = apiKey;
    _userId = id;
    sp.setString(DbKeys.userApiKey, apiKey);
    sp.setString(DbKeys.userId, id);
    notifyListeners();
  }

  logout()async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(DbKeys.userApiKey, "null");
    Get.offAll(()=>SignInScreen());
    notifyListeners();
  }

  getApiKey() async {
    var  prefs = await SharedPreferencesService.getInstance();
    _userApiKey = prefs.getString(DbKeys.userApiKey).toString();
    _userId = prefs.getString(DbKeys.userId).toString();
    _userPhone = prefs.getString(DbKeys.userPhone).toString();
    _userEmail = prefs.getString(DbKeys.userEmail).toString();
    notifyListeners();
  }

  getUserApiKey(context) async {
    log("Message${DbKeys.userApiKey}");

    var  prefs = await SharedPreferencesService.getInstance();
    _userApiKey = prefs.getString(DbKeys.userApiKey).toString();
    _userId = prefs.getString(DbKeys.userId).toString();
    _userPhone = prefs.getString(DbKeys.userPhone).toString();
    _userEmail = prefs.getString(DbKeys.userEmail).toString();
    notifyListeners();
    debugPrint(userApiKey);
    debugPrint(userId);
    if(userApiKey != null && userApiKey != "null"){
      Navigator.pushReplacementNamed(context, RoutesName.bottomNavigationBar);
    }else {
      Navigator.pushReplacementNamed(context, RoutesName.onboardingScreen);
    }
  }

  hidePassword(){
    obscureText = !obscureText;
    notifyListeners();
  }

}
