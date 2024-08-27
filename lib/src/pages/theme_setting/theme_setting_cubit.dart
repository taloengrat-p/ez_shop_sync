import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSettingCubit extends Cubit<ThemeSettingState> {
  ThemeSettingCubit() : super(ThemeSettingInitial()) {}
}
