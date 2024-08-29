import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/tag_management/tag_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagManagementCubit extends Cubit<TagManagementState> {
  ScreenMode screenMode = ScreenMode.display;
  BaseCubit baseCubit;
  StoreRepository storeRepository;

  Map<String, bool> selected = {};
  bool get selectedEmpty =>
      selected.isEmpty || selected.values.every((e) => e == false);

  TagManagementCubit({
    required this.baseCubit,
    required this.storeRepository,
  }) : super(TagManagementInitial());

  List<Tag> get tags => baseCubit.store?.tags ?? [];

  void toggleDeleteMode() {
    screenMode = screenMode == ScreenMode.delete
        ? ScreenMode.display
        : ScreenMode.delete;
    if (screenMode == ScreenMode.display) {
      selected.clear();
    }

    emit(TagManagementRefreshState(DateTime.now()));
  }

  void refresh() {
    emit(TagManagementRefreshState(DateTime.now()));
  }

  void setSelect(String id) {
    if (screenMode == ScreenMode.display) {
      return;
    }

    selected[id] = !(selected[id] ?? false);
    emit(TagManagementRefreshState(DateTime.now()));
  }

  void deleteSelected() async {
    emit(TagManagementLoading());
    selected.removeWhere((key, value) => value == false);
    log('remove ${selected.keys}');

    Store storeUpdated = baseCubit.store!
      ..tags = baseCubit.store?.tags
          ?.where((e) => !selected.keys.toList().contains(e.id))
          .toList();
    await storeRepository.update(baseCubit.store!.id, storeUpdated);
    toggleDeleteMode();
    emit(TagManagementDeleteSuccess());
  }
}
