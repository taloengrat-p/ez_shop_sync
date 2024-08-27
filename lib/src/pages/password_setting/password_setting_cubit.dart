import 'package:ez_shop_sync/src/pages/password_setting/password_setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordSettingCubit extends Cubit<PasswordSettingState> {
  PasswordSettingCubit() : super(PasswordSettingInitial()) {}
}
