// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreAdapter extends TypeAdapter<Store> {
  @override
  final int typeId = 3;

  @override
  Store read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Store(
      id: fields[1] as dynamic,
      info: fields[2] as BaseHiveData?,
      ownerId: fields[3] as String,
      name: fields[4] as String,
      address: fields[5] as String?,
      phoneNumbers: (fields[6] as List?)?.cast<String>(),
      email: fields[7] as String?,
      website: fields[8] as String?,
      description: fields[9] as String?,
      imageUrl: fields[10] as String?,
      tags: fields[12] == null ? [] : (fields[12] as List?)?.cast<String>(),
      storeTheme: fields[13] as AppTheme?,
      categories:
          fields[14] == null ? [] : (fields[14] as List?)?.cast<String>(),
      members: fields[15] == null ? [] : (fields[15] as List).cast<Member>(),
      products: fields[16] == null ? [] : (fields[16] as List?)?.cast<String>(),
      branches: fields[17] == null ? [] : (fields[17] as List?)?.cast<Branch>(),
      imageCoverUrl: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(17)
      ..writeByte(3)
      ..write(obj.ownerId)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.phoneNumbers)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.website)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.imageUrl)
      ..writeByte(11)
      ..write(obj.imageCoverUrl)
      ..writeByte(12)
      ..write(obj.tags)
      ..writeByte(13)
      ..write(obj.storeTheme)
      ..writeByte(14)
      ..write(obj.categories)
      ..writeByte(15)
      ..write(obj.members)
      ..writeByte(16)
      ..write(obj.products)
      ..writeByte(17)
      ..write(obj.branches)
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
      other is StoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      id: json['id'],
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      phoneNumbers: (json['phoneNumbers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      email: json['email'] as String?,
      website: json['website'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      storeTheme: json['storeTheme'] == null
          ? null
          : AppTheme.fromJson(json['storeTheme'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      members: (json['members'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      branches: (json['branches'] as List<dynamic>?)
          ?.map((e) => Branch.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageCoverUrl: json['imageCoverUrl'] as String?,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
      'ownerId': instance.ownerId,
      'name': instance.name,
      'address': instance.address,
      'phoneNumbers': instance.phoneNumbers,
      'email': instance.email,
      'website': instance.website,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'imageCoverUrl': instance.imageCoverUrl,
      'tags': instance.tags,
      'storeTheme': instance.storeTheme?.toJson(),
      'categories': instance.categories,
      'members': instance.members.map((e) => e.toJson()).toList(),
      'products': instance.products,
      'branches': instance.branches?.map((e) => e.toJson()).toList(),
    };
