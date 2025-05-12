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
      info: fields[2] as BaseHiveData?,
      transactionType: fields[7] as String,
      method: fields[8] as String,
      valueId: fields[9] as String,
      totalPrice: fields[10] as num,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(6)
      ..writeByte(7)
      ..write(obj.transactionType)
      ..writeByte(8)
      ..write(obj.method)
      ..writeByte(9)
      ..write(obj.valueId)
      ..writeByte(10)
      ..write(obj.totalPrice)
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
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'],
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      transactionType: json['transactionType'] as String,
      method: json['method'] as String,
      valueId: json['valueId'] as String,
      totalPrice: json['totalPrice'] as num,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'info': instance.info?.toJson(),
      'transactionType': instance.transactionType,
      'method': instance.method,
      'valueId': instance.valueId,
      'totalPrice': instance.totalPrice,
    };
