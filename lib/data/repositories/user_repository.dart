import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository{

  final user = FirebaseAuth.instance.currentUser;
  final _storage = FirebaseStorage.instance;

  Future<void> updateProfile(String photoURL) async {
    await user!.updatePhotoURL(photoURL);
  }

  Future<void> pickAndUploadImage(XFile pickedFile)async {
    File image = File(pickedFile.path);
    // Upload the image to Firebase Storage
    final user = this.user;
    if (user != null) {
      final ref = _storage.ref().child('user_profile_images').child(
          '${user.uid}.jpg');
      await ref.putFile(image);
      // Save the image URL to the user's profile
      final imageUrl = await ref.getDownloadURL();
      // add image to firestore
      await updateProfile(imageUrl);
    }
  }

}