import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user_data.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class StoreManagementCubit extends Cubit<StoreManagementState> {
  final AppCubit appCubit;
  final StoreRepository storeRepository;
  final UserRepository userRepository;
  ScreenMode screenMode = ScreenMode.display;

  Store? get store => appCubit.store;
  StoreManagementCubit({required this.storeRepository, required this.appCubit, required this.userRepository})
    : super(StoreManagementInitial());

  UserData? owner;

  String? nameOriginal;
  String? descOriginal;

  String? nameEditor;
  String? descEditor;

  bool get hasChange =>
      ((nameEditor != nameOriginal) || (descEditor != descOriginal)) &&
      ((nameEditor?.isNotEmpty ?? false) && (descEditor?.isNotEmpty ?? false));

  String get ownerName => store?.ownerId.elseDisplay() ?? elseDisplay();
  String get storeDesc => store?.description.elseDisplay() ?? elseDisplay();
  String get storeName => store?.name.elseDisplay() ?? elseDisplay();

  void initial() {
    emit(StoreManagementLoading());
    // owner = userRepository.getById(store!.ownerId);

    nameOriginal = store?.name;
    descOriginal = store?.description;

    doSetName(store?.name);
    doSetDesc(store?.description);
    emit(StoreManagementSuccess());
  }

  void doDelete() async {
    emit(StoreManagementLoading());

    final storeBuffer = store;
    await storeRepository.delete(appCubit.request(store?.id ?? ''));
    appCubit.setCurrentUser(appCubit.user);
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
      appCubit.request(
        store!
          ..name = nameEditor?.trim() ?? ''
          ..description = descEditor?.trim(),
      ),
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
