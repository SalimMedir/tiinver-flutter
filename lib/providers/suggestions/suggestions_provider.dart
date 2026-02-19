import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../../models/suggestionsModel/suggestions_model.dart';


class SuggestionsProvider with ChangeNotifier {

  final StreamController<List<SuggestionsModel>> _suggestionsController = StreamController.broadcast();
  Stream<List<SuggestionsModel>> get suggestionsStream => _suggestionsController.stream;

  List<SuggestionsModel> _suggestions = [];

  List<SuggestionsModel> get suggestions => _suggestions;

  Future<void> fetchSuggestions(int userId, String userApiKey) async {
    try {
      final response = await ApiService.get(
          Endpoint.getSuggestion(userId),
          header2(userApiKey)
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (!jsonResponse['error']) {
          _suggestions = (jsonResponse['users'] as List)
              .map((user) => SuggestionsModel.fromJson(user))
              .toList();
          _suggestionsController.add(_suggestions);
          notifyListeners();
        } else {
          _suggestionsController.addError('Failed to load suggestions');
        }
      } else {
        _suggestionsController.addError('Failed to load suggestions');
      }
    } catch (e) {
      _suggestionsController.addError(e.toString());
    }
  }


}