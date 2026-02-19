import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../../constant.dart';
import '../../models/searchModel/search_model.dart';

class SearchProvider extends ChangeNotifier{

  final StreamController<List<SearchUsers>> _searchController = StreamController<List<SearchUsers>>.broadcast();
  Stream<List<SearchUsers>> get searchStream => _searchController.stream;

  final Map<int, bool> _loadingStates = {};
  bool isLoadingForUser(int userId) => _loadingStates[userId] ?? false;

  List<SearchUsers> _users = [];

  List<SearchUsers> get users => _users;

  var searchC = TextEditingController();

  bool isLoading = false;

  clearSearch(){
    searchC.text = "";
    users.clear();
    notifyListeners();
  }

  void setLoadingState(int userId, bool isLoading) {
    _loadingStates[userId] = isLoading;
    notifyListeners();
  }

  Future<void> searchUsers({
    required String userApiKey,
    String? userId,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final body = {
        'key': searchC.text,
        'userId': userId,
      };

      final res = await ApiService.post(
        requestBody: postEncode(body),
        headers: header2(userApiKey),
        endPoint: Endpoint.search,
      );

      log("message: ${res.body}");
      if (res.statusCode == 200 || res.statusCode == 201) {
        final jsonResponse = json.decode(res.body);
        final searchModel = SearchModel.fromJson(jsonResponse);
        final List<SearchUsers> users = searchModel.users ?? [];
        _searchController.add(users);
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (error) {
      _searchController.addError(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void dispose() {
    _searchController.close();
    super.dispose();
  }

}