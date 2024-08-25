import 'package:hive/hive.dart';

abstract class BaseHiveObject {
  @HiveField(1)
  final String id;

  @HiveField(2, defaultValue: null)
  DateTime? createDate;

  @HiveField(3, defaultValue: null)
  DateTime? createBy;

  @HiveField(4, defaultValue: null)
  DateTime? updateDate;

  @HiveField(5, defaultValue: null)
  DateTime? updateBy;

  BaseHiveObject({
    required this.id,
    this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
  });
}
