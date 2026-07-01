class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime joinDate;
  final int dashPoints;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.joinDate,
    this.dashPoints = 0,
  });
}
