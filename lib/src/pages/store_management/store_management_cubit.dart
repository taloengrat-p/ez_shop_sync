import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreManagementCubit extends Cubit<StoreManagementState> {
  final BaseCubit baseCubit;
  final StoreRepository storeRepository;
  final UserRepository userRepository;
  ScreenMode screenMode = ScreenMode.display;

  Store? get store => baseCubit.store;
  StoreManagementCubit({
    required this.storeRepository,
    required this.baseCubit,
    required this.userRepository,
  }) : super(StoreManagementInitial());

  User? owner;

  String? nameOriginal;
  String? descOriginal;

  String? nameEditor;
  String? descEditor;

  bool get hasChange =>
      ((nameEditor != nameOriginal) || (descEditor != descOriginal)) &&
      ((nameEditor?.isNotEmpty ?? false) && (descEditor?.isNotEmpty ?? false));

  String get ownerName => owner?.fullname ?? '--';
  String get storeDesc => (store?.description?.isEmpty ?? true) ? '--' : store?.description ?? '';

  void initial() {
    emit(StoreManagementLoading());
    owner = userRepository.getById(store!.ownerId);

    nameOriginal = store?.name;
    descOriginal = store?.description;

    doSetName(store?.name);
    doSetDesc(store?.description);
    emit(StoreManagementSuccess());
  }

  void doDelete() async {
    emit(StoreManagementLoading());

    final storeBuffer = store;
    await storeRepository.delete(store!.id, name: storeBuffer?.name);
    baseCubit.setCurrentUser(baseCubit.user);
    emit(StoreManagementDeleteSuccess(storeBuffer));
  }

  void doEdit() {
    screenMode = ScreenMode.edit;
    emit(StoreManagementScreenModeChange(screenMode));
  }

  void doCancelEdit() {
    screenMode = ScreenMode.display;
    doSetName(nameOriginal);
    doSetDesc(descOriginal);
    emit(StoreManagementScreenModeChange(screenMode));
  }

  void doSave() async {
    emit(StoreManagementLoading());
    await storeRepository.update(
      store!.id,
      store!
        ..name = nameEditor?.trim() ?? ''
        ..description = descEditor?.trim(),
    );
    screenMode = ScreenMode.display;
    emit(StoreManagementUpdateSuccess());
  }

  doSetName(String? value) {
    nameEditor = value;
    emit(StoreManagementRefresh(DateTime.now()));
  }

  doSetDesc(String? value) {
    descEditor = value;
    emit(StoreManagementRefresh(DateTime.now()));
  }
}
