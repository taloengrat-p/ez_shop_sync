// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppThemeAdapter extends TypeAdapter<AppTheme> {
  @override
  final int typeId = 6;

  @override
  AppTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppTheme(
      primaryColor: fields[1] as String,
      secondaryColor: fields[2] as String,
      accentColor: fields[3] as String,
      backgroundColor: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppTheme obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.primaryColor)
      ..writeByte(2)
      ..write(obj.secondaryColor)
      ..writeByte(3)
      ..write(obj.accentColor)
      ..writeByte(4)
      ..write(obj.backgroundColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppTheme _$AppThemeFromJson(Map<String, dynamic> json) => AppTheme(
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      accentColor: json['accentColor'] as String,
      backgroundColor: json['backgroundColor'] as String,
    );

Map<String, dynamic> _$AppThemeToJson(AppTheme instance) => <String, dynamic>{
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'accentColor': instance.accentColor,
      'backgroundColor': instance.backgroundColor,
    };
