import '../../domain/entities/user_entity.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Future<UserModel?> getUser(String userId) async {
    return await _firestoreService.getUser(userId);
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _firestoreService.getUserStream(userId);
  }

  Future<List<UserModel>> getAllLeaders() async {
    return await _firestoreService.getAllLeaders();
  }
}
