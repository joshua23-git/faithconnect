import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? get currentUser => _authService.currentUser;
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final userCredential = await _authService.signUpWithEmailPassword(
      email: email,
      password: password,
    );
    
    final user = UserModel(
      id: userCredential.user!.uid,
      email: email,
      name: name,
      role: role,
      createdAt: DateTime.now(),
    );
    
    await _firestoreService.createUser(user);
    return user;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _authService.signInWithEmailPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
