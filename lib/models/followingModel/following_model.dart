class FollowingModel {
  bool? error;
  String? message;
  List<FollowingUsers>? users;

  FollowingModel({this.error, this.message, this.users});

  FollowingModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['users'] != null) {
      users = <FollowingUsers>[];
      json['users'].forEach((v) {
        users!.add(new FollowingUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowingUsers {
  int? id;
  String? type;
  String? firstname;
  String? lastname;
  String? username;
  bool? isFollowed;
  String? profile;
  String? verify;
  String? active;
  int? followers;
  int? following;
  String? location;

  FollowingUsers(
      {this.id,
        this.type,
        this.firstname,
        this.lastname,
        this.username,
        this.isFollowed,
        this.profile,
        this.verify,
        this.active,
        this.followers,
        this.following,
        this.location});

  FollowingUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    username = json['username'];
    isFollowed = json['isFollowed'];
    profile = json['profile'];
    verify = json['verify'];
    active = json['active'];
    followers = json['followers'];
    following = json['following'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['username'] = this.username;
    data['isFollowed'] = this.isFollowed;
    data['profile'] = this.profile;
    data['verify'] = this.verify;
    data['active'] = this.active;
    data['followers'] = this.followers;
    data['following'] = this.following;
    data['location'] = this.location;
    return data;
  }
}