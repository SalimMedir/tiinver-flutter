class ConnectedUser {
  int? userId;
  String? firstname;
  String? lastname;
  String? username;
  String? profile;

  ConnectedUser({this.userId, this.firstname, this.lastname, this.username, this.profile});

  ConnectedUser.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    username = json['username'];
    profile = json['profile'];
  }
}
