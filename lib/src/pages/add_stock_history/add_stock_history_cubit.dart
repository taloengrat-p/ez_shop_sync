import 'package:ez_shop_sync/src/pages/add_stock_history/add_stock_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddStockHistoryCubit extends Cubit<AddStockHistoryState> {
  AddStockHistoryCubit() : super(AddStockHistoryInitial()) {}
}
