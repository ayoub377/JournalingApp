import 'package:emotions_journaling/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/profile_page_controller.dart';

class ProfileModel with ChangeNotifier {
  final _controller = locator<ProfilePageController>();


  XFile? pickedImage;

  Future<void> pickImage() async {
    pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  Future<void> uploadImage() async {
    if (pickedImage != null) {
      await _controller.uploadImage(pickedImage!);
      notifyListeners();
    }
  }
}
