import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();

  User? _currentUser;
  UserEntity? _currentUserEntity;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  UserEntity? get currentUserEntity => _currentUserEntity;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _authRepository.authStateChanges.listen((user) {
      _currentUser = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _currentUserEntity = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final user = await _userRepository.getUser(userId);
      _currentUserEntity = user;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      _currentUserEntity = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.signIn(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _currentUser = null;
    _currentUserEntity = null;
    notifyListeners();
  }
}
