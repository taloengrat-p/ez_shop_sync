// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductType _$ProductTypeFromJson(Map<String, dynamic> json) => ProductType(
      id: json['id'],
      name: json['name'] as String? ?? '',
      price: json['price'] as num? ?? 0,
      quantity: json['quantity'] as num? ?? 0,
      image: json['image'] as String?,
      desc: json['desc'] as String?,
    );

Map<String, dynamic> _$ProductTypeToJson(ProductType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'image': instance.image,
      'desc': instance.desc,
    };
