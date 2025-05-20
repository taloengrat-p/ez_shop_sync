import 'package:hive_flutter/hive_flutter.dart';

part 'notification_feature_type.enum.g.dart';

@HiveType(typeId: 22)
enum NotificationFeatureType {
  @HiveField(0)
  orderSuccess,
}
