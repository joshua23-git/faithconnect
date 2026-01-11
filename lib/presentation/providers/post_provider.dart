import 'package:flutter/foundation.dart';
import '../../data/repositories/post_repository.dart';
import '../../domain/entities/post_entity.dart';
import '../../data/models/post_model.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _postRepository = PostRepository();

  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadPosts() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _postRepository.getPostsStream().listen(
      (posts) {
        _posts = posts;
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

  void loadFollowingPosts(String userId) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _postRepository.getFollowingPostsStream(userId).listen(
      (posts) {
        _posts = posts;
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

  void loadLeaderPosts(String leaderId) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _postRepository.getLeaderPostsStream(leaderId).listen(
      (posts) {
        _posts = posts;
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

  Future<bool> createPost(PostEntity post) async {
    try {
      await _postRepository.createPost(post);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
