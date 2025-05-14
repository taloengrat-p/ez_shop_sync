// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitType _$UnitTypeFromJson(Map<String, dynamic> json) => UnitType(
      name: StringLocale.fromJson(json['name'] as Map<String, dynamic>),
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      id: json['id'],
      shortName:
          StringLocale.fromJson(json['shortName'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UnitTypeToJson(UnitType instance) => <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
      'name': instance.name.toJson(),
      'shortName': instance.shortName.toJson(),
    };
