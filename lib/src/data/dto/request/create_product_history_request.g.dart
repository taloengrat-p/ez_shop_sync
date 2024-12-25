// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_history_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProductHistoryRequest _$CreateProductHistoryRequestFromJson(
        Map<String, dynamic> json) =>
    CreateProductHistoryRequest(
      storeId: json['storeId'] as String,
      productTypeId: json['productTypeId'] as String?,
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      event: $enumDecode(_$ProductHistoryEventEnumMap, json['event']),
      newData: json['newData'] as Map<String, dynamic>?,
      oldData: json['oldData'] as Map<String, dynamic>?,
      info: BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateProductHistoryRequestToJson(
        CreateProductHistoryRequest instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'userId': instance.userId,
      'productId': instance.productId,
      'productTypeId': instance.productTypeId,
      'event': _$ProductHistoryEventEnumMap[instance.event]!,
      'oldData': instance.oldData,
      'newData': instance.newData,
      'info': instance.info.toJson(),
    };

const _$ProductHistoryEventEnumMap = {
  ProductHistoryEvent.create: 'create',
  ProductHistoryEvent.update: 'update',
  ProductHistoryEvent.delete: 'delete',
  ProductHistoryEvent.addToStock: 'addToStock',
  ProductHistoryEvent.removeFromStock: 'removeFromStock',
  ProductHistoryEvent.order: 'order',
  ProductHistoryEvent.undefined: 'undefined',
};
