class ChatUser {
  ChatUser({
    required this.profile,
    required this.firstname,
    required this.isActive,
    required this.id,
    required this.email,
    // required this.pushToken,
  });
  late String profile;
  late String firstname;
  late bool isActive;
  late String id;
  late String email;
  // late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    profile = json['profile'] ?? '';
    firstname = json['firstname'] ?? '';
    isActive = json['isActive'] ?? false;
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    // pushToken = json['pushToken'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['profile'] = profile;
    data['firstname'] = firstname;
    data['isActive'] = isActive;
    data['id'] = id;
    data['email'] = email;
    // data['push_token'] = pushToken;
    return data;
  }
}
