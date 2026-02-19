class Activity {
  int? id;
  int? actor;
  String? verb;
  String? object;
  String? objectUrl;
  String? message;
  int? likes;
  int? comment;
  int? share;
  bool? isLiked;
  List<Comment>? comments;
  String? stamp;
  int? userId;
  String? username;
  String? firstname;
  String? lastname;
  String? profile;
  String? verify;
  String? location;
  int? followers;
  int? following;

  Activity({
    this.id,
    this.actor,
    this.verb,
    this.object,
    this.objectUrl,
    this.message,
    this.likes,
    this.comment,
    this.share,
    this.isLiked,
    this.comments,
    this.stamp,
    this.userId,
    this.username,
    this.firstname,
    this.lastname,
    this.profile,
    this.verify,
    this.location,
    this.followers,
    this.following,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      actor: json['actor'],
      verb: json['verb'],
      object: json['object'],
      objectUrl: json['object_url'],
      message: json['message'],
      likes: json['likes'],
      comment: json['comment'],
      share: json['share'],
      isLiked: json['isLiked'],
      comments: (json['comments'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
      stamp: json['stamp'],
      userId: json['userId'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      profile: json['profile'],
      verify: json['verify'],
      location: json['location'],
      followers: json['followers'],
      following: json['following'],
    );
  }

  bool isImages() {
    return object == 'photos';
  }

  bool isVideos() {
    return object == 'videos';
  }

  bool isImage() {
    return objectUrl != null && (objectUrl!.endsWith('.jpg') || objectUrl!.endsWith('.jpeg') || objectUrl!.endsWith('.png'));
  }

  bool isVideo() {
    return objectUrl != null && objectUrl!.endsWith('.mp4');
  }
}

class Comment {
  int? id;
  String? commentText;
  String? stamp;
  int? userId;
  String? firstname;
  String? lastname;
  String? profile;

  Comment({
    this.id,
    this.commentText,
    this.stamp,
    this.userId,
    this.firstname,
    this.lastname,
    this.profile,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      commentText: json['commentText'],
      stamp: json['stamp'],
      userId: json['userId'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      profile: json['profile'],
    );
  }
}
