import 'package:ez_shop_sync/src/pages/transactions_chart_details/transactions_chart_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsChartDetailsCubit extends Cubit<TransactionsChartDetailsState> {
  TransactionsChartDetailsCubit() : super(TransactionsChartDetailsInitial()) {}
}
