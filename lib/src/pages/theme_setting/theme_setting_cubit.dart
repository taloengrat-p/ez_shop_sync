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
  Color primary = ColorKeys.primary;
  Color secondary = ColorKeys.secondary;
  Color accent = ColorKeys.accent;
  Color backgroundColor = ColorKeys.brightness;
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
  }) : super(ThemeSettingInitial());

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
}
