// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 7;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[1] as dynamic,
      info: fields[2] as BaseHiveData?,
      name: fields[7] as String,
      parentId: fields[8] as String?,
      borderColor: fields[10] as String?,
      color: fields[9] as String?,
      iconData: (fields[11] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(7)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.parentId)
      ..writeByte(9)
      ..write(obj.color)
      ..writeByte(10)
      ..write(obj.borderColor)
      ..writeByte(11)
      ..write(obj.iconData)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.info);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'],
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
      borderColor: json['borderColor'] as String?,
      color: json['color'] as String?,
      iconData: json['iconData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
      'name': instance.name,
      'parentId': instance.parentId,
      'color': instance.color,
      'borderColor': instance.borderColor,
      'iconData': instance.iconData,
    };
