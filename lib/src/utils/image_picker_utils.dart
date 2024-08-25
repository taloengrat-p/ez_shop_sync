import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class ImagePickerUtils {
  static Future<File?> pickImage({ImageSource imageSource = ImageSource.gallery}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);
    File image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
      return image;
    }

    return null;
  }
}
