import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  ProfileSettingsCubit() : super(ProfileSettingsInitial()) {}
}
