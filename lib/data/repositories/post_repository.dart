import '../../domain/entities/post_entity.dart';
import '../services/firestore_service.dart';
import '../models/post_model.dart';

class PostRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Future<String> createPost(PostEntity post) async {
    return await _firestoreService.createPost(post);
  }

  Stream<List<PostModel>> getPostsStream() {
    return _firestoreService.getPostsStream();
  }

  Stream<List<PostModel>> getLeaderPostsStream(String leaderId) {
    return _firestoreService.getLeaderPostsStream(leaderId);
  }

  Stream<List<PostModel>> getFollowingPostsStream(String userId) {
    return _firestoreService.getFollowingPostsStream(userId);
  }
}
