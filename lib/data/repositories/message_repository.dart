import '../../domain/entities/message_entity.dart';
import '../services/firestore_service.dart';
import '../models/message_model.dart';

class MessageRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> sendMessage(MessageEntity message) async {
    await _firestoreService.sendMessage(message);
  }

  Stream<List<MessageModel>> getMessagesStream(String userId1, String userId2) {
    return _firestoreService.getMessagesStream(userId1, userId2);
  }
}
