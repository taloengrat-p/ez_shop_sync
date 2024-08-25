import 'package:hive/hive.dart';

abstract class BaseHiveObject {
  @HiveField(1)
  final String id;

  const BaseHiveObject({
    required this.id,
  });
}
