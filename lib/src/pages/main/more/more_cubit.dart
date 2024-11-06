import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/auth/auth_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MoreCubit extends Cubit<MoreState> {
  BaseCubit baseCubit;
  AuthRepository authRepository;
  final UserRepository userRepository;
  List<Store> get stores => baseCubit.stores;
  late Locale locale;
  String version = '';
  String buildNumber = '';
  LocalStorageService localStorageService;
  MoreCubit({
    required this.baseCubit,
    required this.localStorageService,
    required this.authRepository,
    required this.userRepository,
  }) : super(MoreInitial()) {
    getAppVersion();
  }

  String get storeShortName => baseCubit.store?.name.toSubStringFirstToIndex(2) ?? '';

  String get storeName => baseCubit.store?.name ?? '';

  Store? get currentStore => baseCubit.store;

  Future<void> doLogout() async {
    await authRepository.logout();
  }

  Future<void> changeLanguage(BuildContext context, bool value) async {
    emit(MoreLoading());
    await context.setLocale(value ? ApplicationConstance.localeTH : ApplicationConstance.localeEN);
    emit(MoreSuccess());
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;

    emit(MoreRefresh(DateTime.now()));
  }

  void setLocale(Locale value) {
    locale = value;
    emit(MoreRefresh(DateTime.now()));
  }

  Future<void> clickPinSetting() async {
    final securePINKey = await localStorageService.getSecure(ApplicationConstance.securePINKey);

    if (securePINKey?.isNotEmpty ?? false) {
      emit(const MoreClickPinSetting(PinType.setting));
    } else {
      emit(const MoreClickPinSetting(PinType.create));
    }
  }

  void refresh() {
    emit(MoreRefresh(DateTime.now()));
  }

  void selectStore(String id) async {
    emit(MoreLoading());
    final result = await userRepository.updateSelectedStore(id);
    baseCubit.setCurrentStoreById(id);
    result.when(
      success: (success) {
        emit(MoreChangeStore(id));
      },
      failure: (error, {errorType}) {
        emit(MoreFailure());
      },
    );
  }
}
