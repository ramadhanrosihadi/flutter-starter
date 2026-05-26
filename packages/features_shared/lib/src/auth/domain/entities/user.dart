class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.roles = const [],
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final List<String> roles;
}
