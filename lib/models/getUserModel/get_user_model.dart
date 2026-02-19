class GetUserModel {
  int? id;
  String? type;
  String? firstname;
  String? lastname;
  String? username;
  bool? isFollowed;
  int? followers;
  int? following;
  String? verify;
  String? active;
  String? profile;
  String? location;
  String? school;
  String? qualification;
  String? birthday;
  String? work;
  String? stamp;

  GetUserModel({
    this.id,
    this.type,
    this.firstname,
    this.lastname,
    this.username,
    this.isFollowed,
    this.followers,
    this.following,
    this.verify,
    this.active,
    this.profile,
    this.location,
    this.school,
    this.qualification,
    this.birthday,
    this.work,
    this.stamp,
  });

  GetUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    username = json['username'];
    isFollowed = json['isFollowed'];
    followers = json['followers'];
    following = json['following'];
    verify = json['verify'];
    active = json['active'];
    profile = json['profile'];
    location = json['location'];
    school = json['school'];
    qualification = json['qualification'];
    birthday = json['birthday'];
    work = json['work'];
    stamp = json['stamp'];
  }
}
