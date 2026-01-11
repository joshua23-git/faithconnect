import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/models/post_model.dart';
import '../../data/models/message_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/entities/message_entity.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Operations
  Future<void> createUser(UserEntity user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .set((user as UserModel).toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  Future<List<UserModel>> getAllLeaders() async {
    final snapshot = await _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: AppConstants.roleLeader)
        .get();
    return snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList();
  }

  // Post Operations
  Future<String> createPost(PostEntity post) async {
    final docRef = await _firestore
        .collection(AppConstants.postsCollection)
        .add((post as PostModel).toMap());
    return docRef.id;
  }

  Stream<List<PostModel>> getPostsStream() {
    return _firestore
        .collection(AppConstants.postsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<PostModel>> getLeaderPostsStream(String leaderId) {
    return _firestore
        .collection(AppConstants.postsCollection)
        .where('leaderId', isEqualTo: leaderId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<PostModel>> getFollowingPostsStream(String userId) {
    return _firestore
        .collection(AppConstants.followersCollection)
        .doc(userId)
        .collection('following')
        .snapshots()
        .asyncMap((snapshot) async {
      final followingIds = snapshot.docs.map((doc) => doc.id).toList();
      if (followingIds.isEmpty) return <PostModel>[];
      
      final postsSnapshot = await _firestore
          .collection(AppConstants.postsCollection)
          .where('leaderId', whereIn: followingIds)
          .orderBy('createdAt', descending: true)
          .get();
      
      return postsSnapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList();
    });
  }

  // Follow Operations
  Future<void> followUser(String userId, String leaderId) async {
    await _firestore
        .collection(AppConstants.followersCollection)
        .doc(userId)
        .collection('following')
        .doc(leaderId)
        .set({'followedAt': FieldValue.serverTimestamp()});
  }

  Future<void> unfollowUser(String userId, String leaderId) async {
    await _firestore
        .collection(AppConstants.followersCollection)
        .doc(userId)
        .collection('following')
        .doc(leaderId)
        .delete();
  }

  Future<bool> isFollowing(String userId, String leaderId) async {
    final doc = await _firestore
        .collection(AppConstants.followersCollection)
        .doc(userId)
        .collection('following')
        .doc(leaderId)
        .get();
    return doc.exists;
  }

  // Message Operations
  Future<void> sendMessage(MessageEntity message) async {
    final conversationId = _getConversationId(message.senderId, message.receiverId);
    await _firestore
        .collection(AppConstants.messagesCollection)
        .doc(conversationId)
        .collection('messages')
        .add((message as MessageModel).toMap());
  }

  Stream<List<MessageModel>> getMessagesStream(String userId1, String userId2) {
    final conversationId = _getConversationId(userId1, userId2);
    return _firestore
        .collection(AppConstants.messagesCollection)
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList());
  }

  String _getConversationId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}
