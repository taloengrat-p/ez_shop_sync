// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_history_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProductHistoryRequest _$CreateProductHistoryRequestFromJson(
        Map<String, dynamic> json) =>
    CreateProductHistoryRequest(
      storeId: json['storeId'] as String?,
      productTypeId: json['productTypeId'] as String?,
      userId: json['userId'] as String?,
      productId: json['productId'] as String,
      data: $enumDecode(_$ProductHistoryEventEnumMap, json['data']),
      newData: json['newData'] as Map<String, dynamic>?,
      oldData: json['oldData'] as Map<String, dynamic>?,
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      addStockId: json['addStockId'] as String?,
      refId: json['refId'] as String?,
    );

Map<String, dynamic> _$CreateProductHistoryRequestToJson(
        CreateProductHistoryRequest instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'userId': instance.userId,
      'info': instance.info?.toJson(),
      'data': _$ProductHistoryEventEnumMap[instance.data]!,
      'productId': instance.productId,
      'productTypeId': instance.productTypeId,
      'oldData': instance.oldData,
      'newData': instance.newData,
      'refId': instance.refId,
      'addStockId': instance.addStockId,
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
