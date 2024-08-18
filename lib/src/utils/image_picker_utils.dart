import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    File image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
      return image;
    }

    return null;
  }
}
