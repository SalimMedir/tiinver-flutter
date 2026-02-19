import 'package:flutter/foundation.dart';

class ChatActivitySendButtonProvider with ChangeNotifier{
  bool _isTextButton = true;
  bool _isVisible = false;
  bool get isTextButton => _isTextButton;
  bool get isVisible => _isVisible;
  Future<void> setVisibility() async{
    _isTextButton =! _isTextButton;
    notifyListeners();
  }
  Future<void> animationVisibility(bool visibility) async{
    _isVisible = visibility;
    notifyListeners();
  }
}