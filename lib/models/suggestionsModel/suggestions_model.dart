class SuggestionsModel {
  final int id;
  final String type;
  final String firstname;
  final String lastname;
  final String username;
  final String profile;
  final String verify;
  final String location;
  final int followers;
  final int following;

  SuggestionsModel({
    required this.id,
    required this.type,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.profile,
    required this.verify,
    required this.location,
    required this.followers,
    required this.following,
  });

  factory SuggestionsModel.fromJson(Map<String, dynamic> json) {
    return SuggestionsModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      username: json['username'] ?? '',
      profile: json['profile'] ?? '',
      verify: json['verify'] ?? '0',
      location: json['location'] ?? '',
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
    );
  }
}
