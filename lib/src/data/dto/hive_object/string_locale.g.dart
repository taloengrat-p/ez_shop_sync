// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_locale.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StringLocaleAdapter extends TypeAdapter<StringLocale> {
  @override
  final int typeId = 21;

  @override
  StringLocale read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StringLocale(
      en: fields[1] as String,
      th: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StringLocale obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.en)
      ..writeByte(2)
      ..write(obj.th);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StringLocaleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StringLocale _$StringLocaleFromJson(Map<String, dynamic> json) => StringLocale(
      en: json['en'] as String,
      th: json['th'] as String,
    );

Map<String, dynamic> _$StringLocaleToJson(StringLocale instance) =>
    <String, dynamic>{
      'en': instance.en,
      'th': instance.th,
    };
