class Comment {
  final int id;
  final String commentText;
  final String stamp;
  final int userId;
  final String firstname;
  final String lastname;
  final String profile;

  Comment({
    required this.id,
    required this.commentText,
    required this.stamp,
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.profile,
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
