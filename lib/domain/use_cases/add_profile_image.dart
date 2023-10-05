import 'package:emotions_journaling/data/repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';

class AddImageToProfile{

  final UserRepository _userRepository;

  AddImageToProfile(this._userRepository);

  Future<void> call(XFile pickedFile) async {
    return _userRepository.pickAndUploadImage(pickedFile);
  }

}