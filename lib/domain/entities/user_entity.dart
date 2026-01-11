class UserEntity {
  final String id;
  final String email;
  final String name;
  final String role; // 'worshipper' or 'leader'
  final String? profileImageUrl;
  final DateTime createdAt;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
  });

  bool get isWorshipper => role == 'worshipper';
  bool get isLeader => role == 'leader';
}
