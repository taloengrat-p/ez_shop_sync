import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extendsions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreCubit extends Cubit<MoreState> {
  BaseCubit baseCubit;
  bool isTh = false;
  List<Store> get stores => baseCubit.stores;

  MoreCubit({
    required this.baseCubit,
  }) : super(MoreInitial());

  String get storeShortName =>
      baseCubit.store?.name.toSubStringFirstToIndex(2) ?? '';

  String get userShortName =>
      baseCubit.user?.username.toSubStringFirstToIndex(2) ?? '';

  String get storeName => baseCubit.store?.name ?? '';

  String get username => baseCubit.user?.username ?? '';

  Store? get currentStore => baseCubit.store;

  String get appVersion => '1.0.0';

  doLogout() {}

  void changeLanguage(bool value) {
    isTh = !isTh;
    baseCubit.setLanguage();
    emit(MoreRefresh(DateTime.now()));
  }
}
