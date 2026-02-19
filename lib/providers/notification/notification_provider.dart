import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../signIn/sign_in_provider.dart';

class NotificationProvider with ChangeNotifier {
  bool _error = false;
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  bool get error => _error;
  List<dynamic> get notifications => _notifications;
  bool get isLoading => _isLoading;


  // NotificationProvider() {
  //   fetchNotifications();
  // }

  // Future<void> fetchNotifications() async {
  //   try {
  //     final response = await _notificationService.getNotifications();
  //     _notifications = response['notifications'];
  //     _error = response['error'];
  //   } catch (e) {
  //     _error = true;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  getNotification(context) async {
    try{

      _isLoading = true;

      var res = await ApiService.get(
          Endpoint.getNotification(
              int.parse(Provider.of<SignInProvider>(context,listen: false).userId!),
          ),
          header2(Provider.of<SignInProvider>(context,listen: false).userApiKey));

      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> jsonResponse = json.decode(res.body);
        if (jsonResponse['error'] == false) {

          _notifications = jsonResponse['notifications'];
          _error = jsonResponse['error'];

          notifyListeners();

          //log("*******${name}******");

        } else {
          throw Exception('Failed to load users');
        }
        //log(followingsList.toString());
      }
    }catch(e){
      print(e);
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }


}
