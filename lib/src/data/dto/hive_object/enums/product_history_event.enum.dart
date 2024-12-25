import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';

enum ProductHistoryEvent {
  create,
  update,
  delete,
  addToStock,
  removeFromStock,
  order,
  undefined;

  factory ProductHistoryEvent.fromString(String? value) {
    switch (value?.ignoreSensitiveCase()) {
      case 'create':
        return ProductHistoryEvent.create;
      case 'update':
        return ProductHistoryEvent.update;
      case 'delete':
        return ProductHistoryEvent.delete;
      case 'addtostock':
        return ProductHistoryEvent.addToStock;
      case 'removefromstock':
        return ProductHistoryEvent.removeFromStock;
      case 'order':
        return ProductHistoryEvent.order;

      default:
        return ProductHistoryEvent.undefined;
    }
  }

  @override
  String toString() {
    switch (this) {
      case ProductHistoryEvent.create:
        return 'create';
      case ProductHistoryEvent.update:
        return 'update';
      case ProductHistoryEvent.delete:
        return 'delete';
      case ProductHistoryEvent.addToStock:
        return 'addtostock';
      case ProductHistoryEvent.removeFromStock:
        return 'removefromstock';
      case ProductHistoryEvent.order:
        return 'order';

      default:
        return 'undefined';
    }
  }
}
