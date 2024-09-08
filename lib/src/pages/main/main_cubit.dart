import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/main_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<MainState> {
  int currentPage = 0;
  BaseCubit baseCubit;
  MainCubit({
    required this.baseCubit,
  }) : super(MainInitial());

  String get username => baseCubit.user?.username ?? '';

  String get userShortName => baseCubit.user?.username.toSubStringFirstToIndex(2) ?? '';

  void setCurrentPageView(int value) {
    currentPage = value;
  }
}
