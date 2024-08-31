import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreManagementCubit extends Cubit<StoreManagementState> {
  final BaseCubit baseCubit;
  final StoreRepository storeRepository;

  Store? get store => baseCubit.store;
  StoreManagementCubit({
    required this.storeRepository,
    required this.baseCubit,
  }) : super(StoreManagementInitial());
}
