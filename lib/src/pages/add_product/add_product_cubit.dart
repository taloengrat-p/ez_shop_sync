import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/add_product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/add_product_history_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_product/add_product_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/utils/timer_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepository productRepository;
  final AddProductHistoryRepository addProductHistoryRepository;
  final AddProductRepository addProductRepository;
  final AppCubit appCubit;

  List<OrderItem> _products = [];
  AddProduct? _addProduct;
  List<OrderItem> get products => _products;
  TimerUtils timerUtils = TimerUtils();
  List<Product> productInStock = [];

  AddProductCubit({
    required this.productRepository,
    required this.addProductHistoryRepository,
    required this.appCubit,
    required this.addProductRepository,
  }) : super(AddProductInitial());

  num? totalPrice;
  String get totalPriceDisplay => totalPrice?.prefixCurrency() ?? '--';

  String get totalItems => products.fold<num>(0, (sum, item) => sum + (item.product?.quantity ?? 0)).toString();

  bool get disabledSubmit => totalPrice == null;

  void increaseProductQtyByIndex(int index) {
    final item = _products[index];
    if (item.product?.quantity == null) {
      throw ('item.quantity is null');
    }

    item.product?.quantity = (_products[index].product?.quantity ?? 0) + 1;
    emit(AddProductIncrease(productId: item.id, qty: item.product!.quantity!));

    timerUtils.debounceTime(const Duration(milliseconds: 500), () {
      addProductRepository.decreaseQty(
        BaseRepoRequest(
          storeId: appCubit.storeId ?? '',
          userId: appCubit.userId,
          data: AddProductDecreaseQtyRequest(
            cartId: appCubit.cart?.id,
            productId: item.product?.id,
            qty: item.product?.quantity ?? 0,
          ),
        ),
      );
    });
  }

  void decreaseProductQtyByIndex(int index) {
    final item = _products[index];
    if (item.product?.quantity == null) {
      throw ('item.quantity is null');
    }

    if (item.product?.quantity == 1) {
      return;
    }

    item.product?.quantity = _products[index].product!.quantity! - 1;
    emit(AddProductDecrease(productId: item.id, qty: item.product!.quantity!));

    timerUtils.debounceTime(const Duration(milliseconds: 500), () {
      addProductRepository.decreaseQty(
        BaseRepoRequest(
          storeId: appCubit.storeId ?? '',
          userId: appCubit.userId,
          data: AddProductDecreaseQtyRequest(
            cartId: appCubit.cart?.id ?? '',
            productId: item.product?.id,
            qty: item.product?.quantity ?? 0,
          ),
        ),
      );
    });
  }

  void initial() async {
    _addProduct = appCubit.addProduct;
    _products = appCubit.addProduct?.addProductItems.map((e) => e).toList() ?? [];
    productInStock = await getProductsByCartItems();
    emit(AddProductInitial());
  }

  void deleteItemFromCart(String id) async {
    await appCubit.deleteItemFromCart(id);
    _products.removeWhere((e) => e.id == id);
    emit(AddProductRemoveItemSuccess(id));
  }

  void submit() async {
    if (_addProduct == null) {
      throw Exception('submit _addProduct == null');
    }

    emit(AddProductLoading());

    final addProductCompleted = await addProductHistoryRepository.create(
      BaseRepoRequest(storeId: appCubit.storeId!, userId: appCubit.userId!, data: _addProduct!.copyWith()),
    );

    emit(AddProductSuccess(addProductCompleted.response));
  }

  Future<List<Product>> getProductsByCartItems() async {
    final productStockFromCartItem = await productRepository.getByIds(
      appCubit.store!.id,
      _products.map((e) => e.product?.id.toString() ?? '').toList(),
      appMode: AppMode.server,
    );

    return productStockFromCartItem.response ?? [];
  }

  void setTotalPrice(String? value) {
    totalPrice = num.tryParse(value ?? '0') ?? 0;
    _addProduct?.amountCost = totalPrice ?? 0;
    emit(AddProductUpdateTotalPrice(totalPrice));
  }
}
