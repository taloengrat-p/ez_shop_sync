// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 4;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[1] as dynamic,
      createDate: fields[2] as DateTime?,
      createBy: fields[3] as String?,
      updateDate: fields[4] as DateTime?,
      updateBy: fields[5] as String?,
      storeId: fields[7] == null ? [] : (fields[7] as List?)?.cast<String>(),
      firstName: fields[8] as String,
      lastName: fields[9] as String,
      phoneNumber: fields[10] as String?,
      email: fields[11] as String,
      username: fields[12] as String,
      profilePictureUrl: fields[13] as String?,
      storeLatest: fields[14] as String?,
      carts: fields[15] == null ? [] : (fields[15] as List).cast<String>(),
      addProducts:
          fields[16] == null ? [] : (fields[16] as List).cast<String>(),
    )..syncDatetime = fields[6] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(16)
      ..writeByte(7)
      ..write(obj.storeId)
      ..writeByte(8)
      ..write(obj.firstName)
      ..writeByte(9)
      ..write(obj.lastName)
      ..writeByte(10)
      ..write(obj.phoneNumber)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.username)
      ..writeByte(13)
      ..write(obj.profilePictureUrl)
      ..writeByte(14)
      ..write(obj.storeLatest)
      ..writeByte(15)
      ..write(obj.carts)
      ..writeByte(16)
      ..write(obj.addProducts)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.createDate)
      ..writeByte(3)
      ..write(obj.createBy)
      ..writeByte(4)
      ..write(obj.updateDate)
      ..writeByte(5)
      ..write(obj.updateBy)
      ..writeByte(6)
      ..write(obj.syncDatetime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      createDate: json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String),
      createBy: json['createBy'] as String?,
      updateDate: json['updateDate'] == null
          ? null
          : DateTime.parse(json['updateDate'] as String),
      updateBy: json['updateBy'] as String?,
      storeId:
          (json['storeId'] as List<dynamic>?)?.map((e) => e as String).toList(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String,
      username: json['username'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      storeLatest: json['storeLatest'] as String?,
      carts: (json['carts'] as List<dynamic>).map((e) => e as String).toList(),
      addProducts: (json['addProducts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    )..syncDatetime = json['syncDatetime'] == null
        ? null
        : DateTime.parse(json['syncDatetime'] as String);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'createDate': instance.createDate?.toIso8601String(),
      'createBy': instance.createBy,
      'updateDate': instance.updateDate?.toIso8601String(),
      'updateBy': instance.updateBy,
      'syncDatetime': instance.syncDatetime?.toIso8601String(),
      'storeId': instance.storeId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'username': instance.username,
      'profilePictureUrl': instance.profilePictureUrl,
      'storeLatest': instance.storeLatest,
      'carts': instance.carts,
      'addProducts': instance.addProducts,
    };
