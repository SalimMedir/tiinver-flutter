import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiinver_project/api/api_services/api_services.dart';
import 'package:tiinver_project/constant.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import 'package:tiinver_project/routes/routes_name.dart';
import '../../api/endpoint/endpoint.dart';
import '../../db_keys.dart';
import '../../models/register/user_sign_up_model.dart';
import '../dashboard/dashboard_provider.dart';
import '../suggestions/suggestions_provider.dart';

class SignUpProvider extends ChangeNotifier{

  var emailC = TextEditingController();
  var passwordC = TextEditingController();
  var nameC = TextEditingController();
  var confirmPasswordC = TextEditingController();

  bool obscureText1 = true;

  bool obscureText2 = true;

  UserSignUp _userSignUPModel = UserSignUp();

  UserSignUp get userSignUPModel => _userSignUPModel;

  String? userApiKey;

  String? userId;

  bool isLoading = false;

  var fireStore = FirebaseFirestore.instance;

  Future<void> signUp(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {

      final body = {
        'email': emailC.text,
        'password': passwordC.text,
        'firstname': "",
        'lastname': "",
        'phoneNumber': "",
        'username': "",
        'fullname': nameC.text,
        'provider': 'email',
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header1,
          endPoint: Endpoint.register
      );

      final error = jsonDecode(res.body)["error"];
      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final message = jsonResponse['message'];
        log("message: ${res.body}");

        if(error){
          Get.snackbar("error", message);
        }else{
          Get.snackbar("success", message);

          _userSignUPModel = UserSignUp.fromJson(jsonResponse['user']);

          fireStore.collection("users").doc(_userSignUPModel.id.toString()).set({
            "id" : _userSignUPModel.id.toString(),
            "apiKey" : _userSignUPModel.apiKey.toString(),
            "email" : _userSignUPModel.email.toString(),
            "phone" : _userSignUPModel.phone.toString(),
            "subscribe" : _userSignUPModel.subscribe.toString(),
            "blocked_users" : _userSignUPModel.blockedUsers,
            "type" : _userSignUPModel.type.toString(),
            "username" : _userSignUPModel.username.toString(),
            "firstname" : _userSignUPModel.firstname.toString(),
            "lastname" : _userSignUPModel.lastname.toString(),
            "profile" : _userSignUPModel.profile.toString(),
            "verify" : _userSignUPModel.verify.toString(),
            "active" : _userSignUPModel.active.toString(),
            "followers" : _userSignUPModel.followers.toString(),
            "following" : _userSignUPModel.following.toString(),
            "location" : _userSignUPModel.location.toString(),
            "school" : _userSignUPModel.school.toString(),
            "qualification" : _userSignUPModel.qualification.toString(),
            "birthday" : _userSignUPModel.birthday.toString(),
            "work" : _userSignUPModel.work.toString(),
            "coinsAmount" : _userSignUPModel.coinsAmount.toString(),
            "stamp" : _userSignUPModel.stamp.toString(),
          });

          Provider.of<SignInProvider>(context,listen: false).
          storeApiKeyAndId(
              apiKey: _userSignUPModel.apiKey.toString(),
              id: _userSignUPModel.id.toString());
          Get.offAllNamed(RoutesName.bottomNavigationBar);

          var sp = await SharedPreferences.getInstance();
          sp.setString(DbKeys.userApiKey, _userSignUPModel.apiKey.toString());
          sp.setString(DbKeys.tiinverToken, _userSignUPModel.apiKey.toString());
          sp.setString(DbKeys.userId, _userSignUPModel.id.toString());
          sp.setString(DbKeys.userEmail, _userSignUPModel.email.toString());
          sp.setString(DbKeys.userPhone, _userSignUPModel.phone.toString());

          Provider.of<SuggestionsProvider>(context, listen: false).fetchSuggestions(
            int.parse(_userSignUPModel.id.toString()),
            jsonDecode(_userSignUPModel.apiKey.toString()),
          );

          Provider.of<DashboardProvider>(context, listen: false).fetchTimeline(
            int.parse(_userSignUPModel.id.toString()),
            100,
            0,
            _userSignUPModel.apiKey.toString(),
          );

          sp.setString('userModel', json.encode(_userSignUPModel.toJson()));

          notifyListeners();
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
