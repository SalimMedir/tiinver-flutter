import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiinver_project/api_services/sp_services.dart';
import 'package:tiinver_project/db_keys.dart';
import 'models/login/user_login_model.dart';

String customEncode(String input) {
  const String encodeSet = " ~`!#\$%^&*()=+[]{}|;:'\",<>/?";
  return input.split('').map((char) {
    if (encodeSet.contains(char)) {
      return Uri.encodeComponent(char);
    } else {
      return char;
    }
  }).join('');
}

String postEncode(Map<String, dynamic> body) {
  return body.entries.map((entry) =>
  '${customEncode(entry.key)}=${customEncode(entry.value.toString())}'
  ).join('&');
}

Future<String> getApiKey() async{
  var sp = await SharedPreferencesService.getInstance();
  return sp.getString(DbKeys.userApiKey).toString();
}

Future<UserLoginModel?> getUserFromPreferences() async {
  var sp = await SharedPreferences.getInstance();
  String? userJson = sp.getString('userModel');
  if (userJson != null) {
    return UserLoginModel.fromJson(json.decode(userJson));
  }
  return null;
}