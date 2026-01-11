import 'package:flutter/foundation.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/follow_repository.dart';
import '../../data/models/user_model.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final FollowRepository _followRepository = FollowRepository();

  List<UserModel> _leaders = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get leaders => _leaders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLeaders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _leaders = await _userRepository.getAllLeaders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> followUser(String userId, String leaderId) async {
    try {
      await _followRepository.followUser(userId, leaderId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> unfollowUser(String userId, String leaderId) async {
    try {
      await _followRepository.unfollowUser(userId, leaderId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> isFollowing(String userId, String leaderId) async {
    return await _followRepository.isFollowing(userId, leaderId);
  }
}
