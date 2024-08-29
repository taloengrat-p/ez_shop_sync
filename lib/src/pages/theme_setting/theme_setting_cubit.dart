import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_state.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSettingCubit extends Cubit<ThemeSettingState> {
  late Color primary;
  late Color secondary;
  late Color accent;
  late Color backgroundColor;

  StoreRepository storeRepository;
  BaseCubit baseCubit;

  String get storeName => baseCubit.store?.name ?? '';
  Store? get store => baseCubit.store;

  bool get hasChange =>
      primary != ColorKeys.primary ||
      secondary != ColorKeys.secondary ||
      accent != ColorKeys.accent ||
      backgroundColor != ColorKeys.brightness;
  ThemeSettingCubit({
    required this.baseCubit,
    required this.storeRepository,
  }) : super(ThemeSettingInitial()) {
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
      store!.id,
      store!
        ..storeTheme = AppTheme(
          primaryColor: primary.toHex(),
          secondaryColor: secondary.toHex(),
          accentColor: accent.toHex(),
          backgroundColor: backgroundColor.toHex(),
        ),
    );

    ColorKeys.primary = primary;
    ColorKeys.secondary = secondary;
    ColorKeys.accent = accent;
    ColorKeys.brightness = backgroundColor;
    emit(ThemeSettingSuccess());
  }

  void reset() {
    initColor();
    emit(const ThemeSettingReset());
  }
}
