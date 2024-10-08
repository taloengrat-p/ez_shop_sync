import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MoreCubit extends Cubit<MoreState> {
  BaseCubit baseCubit;
  List<Store> get stores => baseCubit.stores;
  late Locale locale;
  String version = '';
  String buildNumber = '';
  LocalStorageService localStorageService;
  MoreCubit({
    required this.baseCubit,
    required this.localStorageService,
  }) : super(MoreInitial()) {
    getAppVersion();
  }

  String get storeShortName => baseCubit.store?.name.toSubStringFirstToIndex(2) ?? '';

  String get storeName => baseCubit.store?.name ?? '';

  String get username => baseCubit.user?.username ?? '';

  Store? get currentStore => baseCubit.store;

  doLogout() {}

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

  void changeStore(String id) {
    baseCubit.setCurrentStoreById(id);
    emit(MoreChangeStore(id));
  }
}
