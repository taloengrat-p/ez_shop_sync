import 'dart:developer';
import 'dart:io';

import 'package:ez_shop_sync/src/models/image_save_model.dart';
import 'package:ez_shop_sync/src/utils/extensions/list_string_extensions.dart';
import 'package:ez_shop_sync/src/utils/path_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class FolderFileUtils {
  static Future<String?> createFolder(String name) async {
    final appPath = await PathUtils.getAppPath();
    final path = [appPath, name].toJoinPath();

    final directory = Directory(path);

    if (await directory.exists()) {
      log('Directory already exists', name: 'createFolder');
      return directory.path;
    } else {
      try {
        await directory.create(recursive: true);
        log('Directory created: $path', name: 'createFolder');
        return directory.path;
      } catch (e) {
        log('Directory create error: $e', name: 'createFolder');
        return null;
      }
    }
  }

  static Future<ImageSaveModel> saveImageInApp(
      Uint8List imageBytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final fullFileName = '$fileName.png';
    final path = [directory.path, fullFileName].toJoinPath();
    final compressedImage = await FlutterImageCompress.compressWithList(
      imageBytes,
      minWidth: 800,
      minHeight: 800,
      quality: 80,
    );
    final file = File(path);
    await file.writeAsBytes(compressedImage);
    return ImageSaveModel(fileName: fullFileName, path: path);
  }

  static Future<Uint8List> getFileBytes(File imageFile) async {
    Uint8List imageBytes = await imageFile.readAsBytes();
    return imageBytes;
  }
}
