import 'package:emotions_journaling/domain/use_cases/add_profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePageController{

  final AddImageToProfile _addImageToProfile;
  final auth = FirebaseAuth.instance;

  ProfilePageController(this._addImageToProfile);


  Future<void> uploadImage(XFile pickedImage) async {

      await _addImageToProfile.call(pickedImage);
  }

}
