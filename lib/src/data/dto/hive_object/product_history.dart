import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/product_history_event.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'product_history.g.dart';

@HiveType(typeId: 10)
class ProductHistory extends BaseHiveObject {
  @HiveField(7)
  final String event;
  ProductHistoryEvent get eventType => ProductHistoryEvent.fromString(event);

  @HiveField(8)
  final String productId;

  @HiveField(9)
  final Map<String, dynamic>? oldData;

  @HiveField(10)
  final Map<String, dynamic>? newData;

  ProductHistory({
    required this.productId,
    required super.id,
    required this.event,
    this.newData,
    this.oldData,
  });
  String titleDisplay({Product? product}) {
    switch (eventType) {
      case ProductHistoryEvent.create:
        return LocaleKeys.productHistory_create.tr();
      case ProductHistoryEvent.update:
        return LocaleKeys.productHistory_update.tr();
      case ProductHistoryEvent.delete:
        return LocaleKeys.productHistory_delete.tr();
      case ProductHistoryEvent.addToStock:
        return LocaleKeys.productHistory_addStock.tr();
      case ProductHistoryEvent.removeFromStock:
        return LocaleKeys.productHistory_removeFromStockFormat.tr();
      default:
        return 'Undefined';
    }
  }

  String descDisplay({Product? product}) {
    switch (eventType) {
      case ProductHistoryEvent.create:
        final newDataValue = newData?['quantity'];

        return newDataValue != null
            ? LocaleKeys.productHistory_createWithStockFormat.tr(
                args: [
                  newDataValue.toString(),
                  LocaleKeys.units_piece.tr(),
                ],
              )
            : LocaleKeys.productHistory_createFormat.tr();
      case ProductHistoryEvent.update:
        final fieldName = oldData?['fieldName'];
        final oldDataValue = oldData?['data'];
        final newDataValue = newData?['data'];

        return oldDataValue != null
            ? LocaleKeys.productHistory_updateFormat.tr(args: [fieldName, oldDataValue, newDataValue])
            : LocaleKeys.productHistory_updateFirstFormat.tr(args: [fieldName, newDataValue]);
      case ProductHistoryEvent.delete:
        final priceCategpry = oldData?['priceCategpry'];
        final productName = product?.name;

        return priceCategpry != null
            ? LocaleKeys.productHistory_deletePriceCategory.tr(
                args: [priceCategpry, productName ?? ''],
              )
            : LocaleKeys.productHistory_deleteProduct.tr(
                args: [productName ?? ''],
              );

      case ProductHistoryEvent.addToStock:
        final priceCategpry = newData?['priceCategory'];
        final qty = newData?['qty'];
        final addStockName = priceCategpry ?? product?.name ?? LocaleKeys.products.tr();

        return LocaleKeys.productHistory_addToStockFormat
            .tr(args: [addStockName, '$qty ${LocaleKeys.units_piece.tr()}']);
      case ProductHistoryEvent.removeFromStock:
        final priceCategpry = oldData?['priceCategpry'];
        final qty = oldData?['qty'];
        final removedName = priceCategpry ?? product?.name ?? LocaleKeys.products.tr();

        return LocaleKeys.productHistory_removeFromStockFormat.tr(
          args: [
            removedName,
            qty,
            LocaleKeys.units_piece.tr(),
          ],
        );

      default:
        return 'Undefined messsage.';
    }
  }
}
