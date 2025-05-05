import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_add_stock_request.dart';

abstract class IAddProductRepository {
  List<AddProduct> getAddProductByUserIdWithCurrentStore(List<String> request);
  Future<AddProduct> create(CreateAddProductRequest request);
  Future<AddProduct> update(String id, AddProduct updated);
  Future<void> delete(String id);
  Future<void> deleteAll(List<String> ids);
}
