import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton(signalsReady: true)
class AddProductHistoryDetailCubit extends Cubit<AddProductHistoryDetailState> {
  AddProductHistoryDetailCubit() : super(AddProductHistoryDetailInitial());
}
