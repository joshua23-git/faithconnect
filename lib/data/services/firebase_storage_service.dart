import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../core/constants/app_constants.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      final ref = _storage
          .ref()
          .child(AppConstants.profileImagesPath)
          .child('$userId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadPostImage(String postId, File imageFile) async {
    try {
      final ref = _storage
          .ref()
          .child(AppConstants.postImagesPath)
          .child('$postId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (e) {
      // Ignore errors if file doesn't exist
    }
  }
}
