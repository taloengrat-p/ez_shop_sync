import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class ResultEncryp {
  final String value;
  final String salt;

  ResultEncryp({
    required this.value,
    required this.salt,
  });

  @override
  String toString() => 'PasswordEncryp(password: $value, salt: $salt)';
}

class CryptoUtils {
  static ResultEncryp encrypPassword(
    String value, {
    int lengthSalt = 5,
    String? saltInput,
  }) {
    final String salt = saltInput ?? generateUuid(lengthSalt);
    final valueAndSalt = value + salt;
    var bytes = utf8.encode(valueAndSalt);
    var digest = crypto.md5.convert(bytes);

    return ResultEncryp(value: digest.toString(), salt: salt);
  }

  static bool verifyPassword({
    required String passwordInput,
    required String salt,
    required String passwordHash,
  }) {
    final valueAndSalt = passwordInput.trim() + salt;
    var bytes = utf8.encode(valueAndSalt);
    var digest = crypto.md5.convert(bytes);

    return digest.toString() == passwordHash;
  }

  static String generateUuid(int length) {
    var uuid = const Uuid();
    String fullUuid =
        uuid.v4().replaceAll('-', ''); // Remove hyphens to get 32 characters
    if (length > fullUuid.length) {
      throw Exception("Requested length exceeds the UUID length");
    }

    return fullUuid.substring(0, length); // Trim to the desired length
  }
}
