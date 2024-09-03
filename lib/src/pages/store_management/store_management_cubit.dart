import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreManagementCubit extends Cubit<StoreManagementState> {
  final BaseCubit baseCubit;
  final StoreRepository storeRepository;
  final UserRepository userRepository;

  Store? get store => baseCubit.store;
  StoreManagementCubit({
    required this.storeRepository,
    required this.baseCubit,
    required this.userRepository,
  }) : super(StoreManagementInitial());

  User? owner;
  String get ownerName => owner?.fullname ?? '--';
  String get storeDesc => (store?.description?.isEmpty ?? true) ? '--' : store?.description ?? '';

  void initial() {
    emit(StoreManagementLoading());
    owner = userRepository.getById(store!.ownerId);

    log('owner ${owner}');
    emit(StoreManagementSuccess());
  }

  void doDelete() async {
    emit(StoreManagementLoading());

    final storeBuffer = store;
    await storeRepository.delete(store!.id, name: storeBuffer?.name);
    baseCubit.setCurrentUser(baseCubit.user);
    emit(StoreManagementDeleteSuccess(storeBuffer));
  }
}
