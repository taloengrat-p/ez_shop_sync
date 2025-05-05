import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/transactions_chart_details/transactions_chart_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class TransactionsChartDetailsCubit extends Cubit<TransactionsChartDetailsState> {
  final AppCubit appCubit;

  PeriodType periodType = PeriodType.week;
  num get totalSales => ordered.fold(0.0, (sum, item) => sum + item.totalPriceIncludeServiceCharge);
  num get averageIncome => ordered.fold(0.0, (sum, item) => sum + item.totalPriceIncludeServiceCharge);
  List<ProductOrder> ordered = [];
  Map<DateTime, List<ProductOrder>> dateTimeWithValue = {};
  TransactionsChartDetailsArgrument? argrument;

  TransactionsChartDetailsCubit({required this.appCubit}) : super(TransactionsChartDetailsInitial());

  void setArgruments(TransactionsChartDetailsArgrument argrument) {
    this.argrument = argrument;
    periodType = argrument.periodType;
    dateTimeWithValue = argrument.days;
    ordered = dateTimeWithValue.values.expand((orderList) => orderList).toList();
    emit(argrument);
  }
}
