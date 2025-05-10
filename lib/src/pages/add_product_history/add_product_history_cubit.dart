import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/add_product_history_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/add_product_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AddProductHistoryCubit extends Cubit<AddProductHistoryState> {
  final int itemLength = 10;
  final AddProductHistoryRepository addProductHistoryRepository;

  final AppCubit appCubit;

  List<AddProduct> orderItems = [];
  QueryDocumentSnapshot? lastDocument;

  AddProductHistoryCubit({required this.addProductHistoryRepository, required this.appCubit})
    : super(AddProductHistoryInitial());

  Future<void> initialze() async {
    emit(const AddProductHistoryInitialLoading());
    await loadMoreItems(disabledState: true);
    emit(AddProductHistorySuccess());
  }

  Future<void> loadMoreItems({bool refresh = false, bool disabledState = false}) async {
    if (!disabledState) {
      emit(const AddProductHistoryLoadMore());
    }

    final start = orderItems.length;
    final end = orderItems.length + itemLength;

    final orderLoaded = await addProductHistoryRepository.getItemsByLimit(
      appCubit.request(
        PaginationIndexRequest(start: start, end: end, lastDocument: refresh ? null : lastDocument, limit: 10),
      ),
    );

    orderLoaded.when(
      success: (response) {
        if (refresh) {
          orderItems.clear();
        }

        lastDocument = response.lastDocument;
        orderItems.addAll(response.orders);
        if (!disabledState) {
          emit(AddProductHistoryLoadMoreSuccess(start, end));
        }
      },
      failure: (error) {
        emit(const AddProductHistoryFailure());
      },
    );
  }
}
