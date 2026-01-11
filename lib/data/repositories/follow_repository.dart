import '../services/firestore_service.dart';

class FollowRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> followUser(String userId, String leaderId) async {
    await _firestoreService.followUser(userId, leaderId);
  }

  Future<void> unfollowUser(String userId, String leaderId) async {
    await _firestoreService.unfollowUser(userId, leaderId);
  }

  Future<bool> isFollowing(String userId, String leaderId) async {
    return await _firestoreService.isFollowing(userId, leaderId);
  }
}
