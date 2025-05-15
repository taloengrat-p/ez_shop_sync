import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/auth/auth_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:ez_shop_sync/src/widgets/bottoms/bottom_sheet_select_store_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@Injectable()
class MoreCubit extends Cubit<MoreState> {
  AppCubit appCubit;
  AuthRepository authRepository;
  final UserRepository userRepository;
  List<Store> get stores => appCubit.stores;
  User? get user => appCubit.user;
  late Locale locale;
  String version = '';
  String buildNumber = '';
  LocalStorageService localStorageService;
  MoreCubit({
    required this.appCubit,
    required this.localStorageService,
    required this.authRepository,
    required this.userRepository,
  }) : super(MoreInitial()) {
    getAppVersion();
  }

  String get storeShortName => appCubit.store?.name.toSubStringFirstToIndex(2) ?? '';

  String get storeName => appCubit.store?.name ?? '';

  Store? get currentStore => appCubit.store;
  Branch? get currentBranch => appCubit.branch;

  String get userRoleOnStore => appCubit.userRoleOnStoreSelect;

  Future<void> doLogout() async {
    await appCubit.logout();
    emit(MoreLogoutSuccess());
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

  void selectStore(BottomSheetSelectStoreWidgetArgrument param) async {
    emit(MoreLoading());
    final result = await userRepository.updateSelectedBranchUnderStore(
      BaseRepoRequest(
        storeId: param.storeId,
        userId: appCubit.userId ?? '',
        branchId: param.branchId ?? '',
        data: null,
      ),
    );

    await appCubit.setCurrentStoreAndBranchById(
      param.storeId,
      branchId: param.branchId,
      origin: runtimeType.toString(),
    );

    result.when(
      success: (success) {
        emit(MoreChangeStore(storeId: param.storeId, branchId: param.branchId));
      },
      failure: (error, {errorType}) {
        emit(MoreFailure());
      },
    );
  }
}
