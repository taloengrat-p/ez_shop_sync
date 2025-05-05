
// import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  final AppCubit baseCubit;
  final UserRepository userRepository;
  ScreenMode screenMode = ScreenMode.display;

  User? get user => baseCubit.user;

  ProfileSettingsCubit({
    required this.baseCubit,
    required this.userRepository,
  }) : super(ProfileSettingsInitial());

  String? displayNameEditor;

  // String? phoneEditor;
  // String? phoneOriginal;

  String? emailOriginal;
  String? emailEditor;

  String get displayNameOriginal => baseCubit.currentUsername;

  String get profilePhoneNumber =>
      user?.phoneNumber.elseDisplay() ?? elseDisplay();

  bool get hasEditChange => (displayNameEditor != displayNameOriginal);
  // ((phoneEditor != phoneOriginal) || (emailEditor != emailOriginal)) &&
  //     ((phoneEditor?.isNotEmpty ?? false) && (emailEditor?.isNotEmpty ?? false));

  String get profileEmail => user?.email.elseDisplay() ?? elseDisplay();

  Future<void> initial() async {
    emit(ProfileSettingsLoading());
    await user?.reload();
    displayNameEditor = displayNameOriginal;
    // phoneOriginal = user?.phoneNumber ?? '';
    emailOriginal = user?.email;

    doSetPhoneNumber(user?.phoneNumber);
    doSetEmail(user?.email);
    // doSetDesc(user?.description);
    emit(ProfileSettingsInitial());
  }

  void doEdit() {
    screenMode = ScreenMode.edit;
    emit(ProfileSettingsModeChange(screenMode));
  }

  void doCancelEdit() {
    screenMode = ScreenMode.display;
    // doSetName(nameOriginal);
    // doSetDesc(descOriginal);
    emit(ProfileSettingsModeChange(screenMode));
  }

  void doSave() async {
    emit(ProfileSettingsLoading());

    if (displayNameEditor != displayNameOriginal) {
      await baseCubit.updateDisplayName(displayNameEditor);
      initial();
      screenMode = ScreenMode.display;
      emit(const ProfileSettingsUpdateSuccess());
    }
  }

  doSetName(String? value) {
    displayNameEditor = value?.trim() ?? '';
    emit(ProfileSettingsRefresh(DateTime.now()));
    // nameEditor = value;
  }

  doSetDesc(String? value) {
    // descEditor = value;
  }

  doSetEmail(String? value) {
    emailEditor = value;
    emit(ProfileSettingsRefresh(DateTime.now()));
  }

  void doSetPhoneNumber(String? phoneNumber) {
    // phoneEditor = phoneNumber?.trim() ?? '';
    emit(ProfileSettingsRefresh(DateTime.now()));
  }

  void verifyEmail() async {
    emit(ProfileSettingsLoading());
    try {
      await baseCubit.user?.sendEmailVerification();
      emit(
        ProfileSettingsSendVerifyEmail(baseCubit.user?.email ?? ''),
      );
    } catch (e) {
      emit(const ProfileSettingsFailure());
    }
  }

  void refresh() {
    emit(ProfileSettingsRefresh(DateTime.now()));
  }
}
