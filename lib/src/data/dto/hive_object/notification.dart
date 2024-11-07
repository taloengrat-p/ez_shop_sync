import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable(explicitToJson: true)
class Notification {
  String? id;
  final NotificationType? type;
  final String? title;
  final String? desc;
  final dynamic createAt;
  final Map<String, dynamic>? payload;
  DateTime get getCreateAt => (createAt as Timestamp).toDate();

  Notification({
    this.type,
    this.createAt,
    this.title,
    this.desc,
    this.payload,
    this.id,
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
