import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../../models/connectedUsers/connected_users_model.dart';
import '../signIn/sign_in_provider.dart';

class ConnectedUsersProvider extends ChangeNotifier{

  List<ConnectedUser> _connectedUsers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ConnectedUser> get connectedUsers => _connectedUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  //

  fetchConnectedUsers(context) async {
    try{

      _isLoading = true;

      final res = await ApiService.get(
          Endpoint.getConnectedUser(int.parse(Provider.of<SignInProvider>(context,listen: false).userId!)),
          header2(Provider.of<SignInProvider>(context,listen: false).userApiKey));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final jsonResponse = json.decode(res.body);
        if (!jsonResponse['error']) {
          _connectedUsers = (jsonResponse['data'] as List)
              .map((user) => ConnectedUser.fromJson(user))
              .toList();
        } else {
          _errorMessage = 'Failed to load connected users';
        }
      } else {
        _errorMessage = 'Failed to load connected users';
      }
    }catch(e){
      _errorMessage = e.toString();    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

}