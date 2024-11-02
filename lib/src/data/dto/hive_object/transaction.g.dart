// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 14;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[1] as dynamic,
      transactionType: fields[7] as String,
      method: fields[8] as String,
      valueId: fields[9] as String,
      totalPrice: fields[10] as num,
      storeId: fields[11] as String,
    )
      ..createDate = fields[2] as DateTime?
      ..createBy = fields[3] as String?
      ..updateDate = fields[4] as DateTime?
      ..updateBy = fields[5] as String?
      ..syncDatetime = fields[6] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(11)
      ..writeByte(7)
      ..write(obj.transactionType)
      ..writeByte(8)
      ..write(obj.method)
      ..writeByte(9)
      ..write(obj.valueId)
      ..writeByte(10)
      ..write(obj.totalPrice)
      ..writeByte(11)
      ..write(obj.storeId)
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
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'],
      transactionType: json['transactionType'] as String,
      method: json['method'] as String,
      valueId: json['valueId'] as String,
      totalPrice: json['totalPrice'] as num,
      storeId: json['storeId'] as String,
    )
      ..createDate = json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String)
      ..createBy = json['createBy'] as String?
      ..updateDate = json['updateDate'] == null
          ? null
          : DateTime.parse(json['updateDate'] as String)
      ..updateBy = json['updateBy'] as String?
      ..syncDatetime = json['syncDatetime'] == null
          ? null
          : DateTime.parse(json['syncDatetime'] as String);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createDate': instance.createDate?.toIso8601String(),
      'createBy': instance.createBy,
      'updateDate': instance.updateDate?.toIso8601String(),
      'updateBy': instance.updateBy,
      'syncDatetime': instance.syncDatetime?.toIso8601String(),
      'transactionType': instance.transactionType,
      'method': instance.method,
      'valueId': instance.valueId,
      'totalPrice': instance.totalPrice,
      'storeId': instance.storeId,
    };
