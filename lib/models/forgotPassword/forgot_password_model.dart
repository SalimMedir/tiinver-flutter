/// error : false
/// message : "Password Changed"

class ForgotPasswordModel {
  ForgotPasswordModel({
      bool? error, 
      String? message,}){
    _error = error;
    _message = message;
}

  ForgotPasswordModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
  }
  bool? _error;
  String? _message;
ForgotPasswordModel copyWith({  bool? error,
  String? message,
}) => ForgotPasswordModel(  error: error ?? _error,
  message: message ?? _message,
);
  bool? get error => _error;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    return map;
  }

}