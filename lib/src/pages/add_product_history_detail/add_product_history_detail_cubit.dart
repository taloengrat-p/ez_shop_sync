// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/add_product_history_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AddProductHistoryDetailCubit extends Cubit<AddProductHistoryDetailState> {
  final AddProductHistoryRepository addProductHistoryRepository;
  final AppCubit appCubit;

  AddProductHistoryDetailArgruments? _argruments;
  AddProduct? _addProductHistory;

  AddProduct? get order => _addProductHistory;

  AddProductHistoryDetailCubit(this.addProductHistoryRepository, this.appCubit)
    : super(AddProductHistoryDetailInitial());

  void initialize(AddProductHistoryDetailArgruments argruments) async {
    _argruments = argruments;

    if (argruments.addProduct != null) {
      emit(AddProductHistoryDetailInitialLoading());
      _addProductHistory = _argruments?.addProduct;
      emit(AddProductHistoryDetailSuccess());
    } else {
      if (_argruments?.addProduct == null && _argruments?.addProductId != null) {
        emit(AddProductHistoryDetailInitialLoading());

        final result = await addProductHistoryRepository.getDetailById(appCubit.request(_argruments!.addProductId!));

        result.when(
          success: (response) {
            _addProductHistory = response;

            emit(AddProductHistoryDetailSuccess());
          },
          failure: (error) {
            emit(const AddProductHistoryDetailFailure());
          },
        );
      }
    }
  }
}
