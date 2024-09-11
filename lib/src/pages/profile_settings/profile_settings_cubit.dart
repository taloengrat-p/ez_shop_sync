import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_page.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  final BaseCubit baseCubit;
  final UserRepository userRepository;
  ScreenMode screenMode = ScreenMode.display;

  User? get user => baseCubit.user;

  ProfileSettingsCubit({
    required this.baseCubit,
    required this.userRepository,
  }) : super(ProfileSettingsInitial());

  // String? nameOriginal;
  // String? descOriginal;

  // String? nameEditor;
  // String? descEditor;

  String? phoneEditor;
  String? phoneOriginal;

  String? emailOriginal;
  String? emailEditor;

  String get profileName => user?.fullname.elseDisplay() ?? elseDisplay();

  String get profilePhoneNumber => user?.phoneNumber.elseDisplay() ?? elseDisplay();

  bool get hasEditChange =>
      ((phoneEditor != phoneOriginal) || (emailEditor != emailOriginal)) &&
      ((phoneEditor?.isNotEmpty ?? false) && (emailEditor?.isNotEmpty ?? false));

  String get profileEmail => user?.email.elseDisplay() ?? elseDisplay();

  void initial() {
    emit(ProfileSettingsLoading());

    phoneOriginal = user?.phoneNumber;
    emailOriginal = user?.email;

    doSetPhoneNumber(user?.phoneNumber);
    doSetEmail(user?.email);
    // doSetDesc(user?.description);
    emit(ProfileSettingsSuccess());
  }

  void doDelete() async {
    emit(ProfileSettingsLoading());

    await userRepository.delete(user!.id);
    baseCubit.setCurrentUser(baseCubit.user);
    emit(ProfileSettingsDeleteSuccess());
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
    final resultUpdated = await userRepository.update(
      user!.id,
      user!
        ..phoneNumber = phoneEditor
        ..email = (emailEditor ?? emailOriginal) ?? ''
        ..updateBy = user?.username,
    );

    log('resultUpdated ${resultUpdated}');
    baseCubit.updateCurrentUser(resultUpdated);
    initial();
    screenMode = ScreenMode.display;
    emit(ProfileSettingsUpdateSuccess());
  }

  doSetName(String? value) {
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
    phoneEditor = phoneNumber;
    emit(ProfileSettingsRefresh(DateTime.now()));
  }
}
