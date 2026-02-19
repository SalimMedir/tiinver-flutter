class UserLoginModel {
  int? id;
  String? apiKey;
  String? email;
  String? phone;
  String? subscribe;
  List<dynamic>? blockedUsers;
  String? type;
  String? username;
  String? firstname;
  String? lastname;
  String? profile;
  String? verify;
  String? active;
  int? followers;
  int? following;
  String? location;
  String? school;
  String? qualification;
  String? birthday;
  String? work;
  int? coinsAmount;
  String? stamp;

  UserLoginModel({
    this.id,
    this.apiKey,
    this.email,
    this.phone,
    this.subscribe,
    this.blockedUsers,
    this.type,
    this.username,
    this.firstname,
    this.lastname,
    this.profile,
    this.verify,
    this.active,
    this.followers,
    this.following,
    this.location,
    this.school,
    this.qualification,
    this.birthday,
    this.work,
    this.coinsAmount,
    this.stamp,
  });

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    apiKey = json['apiKey'];
    email = json['email'];
    phone = json['phone'];
    subscribe = json['subscribe'];
    blockedUsers = json['blocked_users'];
    type = json['type'];
    username = json['username'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    profile = json['profile'];
    verify = json['verify'];
    active = json['active'];
    followers = json['followers'];
    following = json['following'];
    location = json['location'];
    school = json['school'];
    qualification = json['qualification'];
    birthday = json['birthday'];
    work = json['work'];
    coinsAmount = json['coinsAmount'];
    stamp = json['stamp'];
  }
}
