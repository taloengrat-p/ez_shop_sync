import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  final NotificationType? type;
  final String? title;
  final String? desc;
  final dynamic createAt;
  final String? storeId;
  final Map<String, dynamic>? payload;
  DateTime get getCreateAt => (createAt as Timestamp).toDate();

  Notification({
    this.type,
    this.createAt,
    this.title,
    this.desc,
    this.storeId,
    this.payload,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}

enum NotificationType {
  storeInvite,
  undefined;

  String display() {
    switch (this) {
      case NotificationType.storeInvite:
        return 'Store Invitation';
      default:
        'Undefined';
    }

    return 'Undefined';
  }
}
