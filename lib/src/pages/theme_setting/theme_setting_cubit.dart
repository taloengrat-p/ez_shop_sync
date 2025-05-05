import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_state.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class ThemeSettingCubit extends Cubit<ThemeSettingState> {
  late Color primary;
  late Color secondary;
  late Color accent;
  late Color backgroundColor;

  StoreRepository storeRepository;
  AppCubit appCubit;

  String get storeName => appCubit.store?.name ?? '';
  Store? get store => appCubit.store;

  bool get hasChange =>
      primary != ColorKeys.primary ||
      secondary != ColorKeys.secondary ||
      accent != ColorKeys.accent ||
      backgroundColor != ColorKeys.brightness;
  ThemeSettingCubit({required this.appCubit, required this.storeRepository}) : super(ThemeSettingInitial()) {
    initColor();
  }

  initColor() {
    primary = ColorKeys.primary;
    secondary = ColorKeys.secondary;
    accent = ColorKeys.accent;
    backgroundColor = ColorKeys.brightness;
  }

  setPrimary(Color p1) {
    primary = p1;
    emit(ThemeSettingRefresh(DateTime.now()));
  }

  setAccent(Color p1) {
    accent = p1;
    emit(ThemeSettingRefresh(DateTime.now()));
  }

  setBackgroundColor(Color p1) {
    backgroundColor = p1;
    emit(ThemeSettingRefresh(DateTime.now()));
  }

  setSecondary(Color p1) {
    secondary = p1;
    emit(ThemeSettingRefresh(DateTime.now()));
  }

  doSaveAppTheme() {
    emit(ThemeSettingLoading());
    storeRepository.update(
      BaseRepoRequest(
        storeId: appCubit.storeId ?? '',
        userId: appCubit.userId ?? '',
        data:
            store!
              ..storeTheme = AppTheme(
                primaryColor: primary.toHex(),
                secondaryColor: secondary.toHex(),
                accentColor: accent.toHex(),
                backgroundColor: backgroundColor.toHex(),
              ),
      ),
    );

    ColorKeys.primary = primary;
    ColorKeys.secondary = secondary;
    ColorKeys.accent = accent;
    ColorKeys.brightness = backgroundColor;
    emit(ThemeSettingSuccess());
    appCubit.refresh();
  }

  void reset() {
    initColor();
    emit(const ThemeSettingReset());
  }
}
