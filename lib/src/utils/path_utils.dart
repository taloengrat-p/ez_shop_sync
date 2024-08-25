import 'package:path_provider/path_provider.dart';

class PathUtils {
  static Future<String> getAppPath() async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }
}
