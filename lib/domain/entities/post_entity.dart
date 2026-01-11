class PostEntity {
  final String id;
  final String leaderId;
  final String leaderName;
  final String? leaderProfileImageUrl;
  final String text;
  final String? imageUrl;
  final int likesCount;
  final DateTime createdAt;

  PostEntity({
    required this.id,
    required this.leaderId,
    required this.leaderName,
    this.leaderProfileImageUrl,
    required this.text,
    this.imageUrl,
    required this.likesCount,
    required this.createdAt,
  });
}
