import 'dart:io';

extension ListStringExtensions on List {
  String toJoinPath() {
    return join(Platform.pathSeparator);
  }
}
