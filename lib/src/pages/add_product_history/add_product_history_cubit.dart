import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/add_product_history_repository.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/add_product_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AddProductHistoryCubit extends Cubit<AddProductHistoryState> {
  final AddProductHistoryRepository addProductHistoryRepository;

  AddProductHistoryCubit({required this.addProductHistoryRepository}) : super(AddProductHistoryInitial());

  final int itemLength = 10;

  List<AddProduct> orderItems = [];

  initialze() {
    emit(AddProductHistoryLoading());
    loadMoreItems();
    emit(AddProductHistorySuccess());
  }

  Future<void> loadMoreItems() async {
    emit(const AddProductHistoryLoadMore());
    final start = orderItems.length;
    final end = orderItems.length + itemLength;
    final orderLoaded = addProductHistoryRepository.getAllRange(start, end);
    orderItems.addAll(orderLoaded);
    emit(AddProductHistoryLoadMoreSuccess(start, end));
  }
}
