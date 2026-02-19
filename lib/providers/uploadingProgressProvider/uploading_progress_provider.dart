import 'package:flutter/foundation.dart';

class UploadingProgressBarProvider with ChangeNotifier{
  bool _isUploading = false;
  bool get isUploading => _isUploading;
  Future<void> setVisibility(bool visibility) async {
    _isUploading = visibility;
    notifyListeners();
  }
}