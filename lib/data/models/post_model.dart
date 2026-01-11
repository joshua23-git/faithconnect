import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.id,
    required super.leaderId,
    required super.leaderName,
    super.leaderProfileImageUrl,
    required super.text,
    super.imageUrl,
    required super.likesCount,
    required super.createdAt,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      leaderId: data['leaderId'] ?? '',
      leaderName: data['leaderName'] ?? '',
      leaderProfileImageUrl: data['leaderProfileImageUrl'],
      text: data['text'] ?? '',
      imageUrl: data['imageUrl'],
      likesCount: data['likesCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leaderId': leaderId,
      'leaderName': leaderName,
      'leaderProfileImageUrl': leaderProfileImageUrl,
      'text': text,
      'imageUrl': imageUrl,
      'likesCount': likesCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
