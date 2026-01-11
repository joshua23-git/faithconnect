import 'package:flutter/foundation.dart';
import '../../data/repositories/message_repository.dart';
import '../../domain/entities/message_entity.dart';
import '../../data/models/message_model.dart';

class MessageProvider with ChangeNotifier {
  final MessageRepository _messageRepository = MessageRepository();

  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadMessages(String userId1, String userId2) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _messageRepository.getMessagesStream(userId1, userId2).listen(
      (messages) {
        _messages = messages;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> sendMessage(MessageEntity message) async {
    try {
      await _messageRepository.sendMessage(message);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
