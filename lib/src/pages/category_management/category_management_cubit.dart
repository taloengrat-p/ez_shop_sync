import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/category_management/category_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryManagementCubit extends Cubit<CategoryManagementState> {
  ScreenMode screenMode = ScreenMode.display;
  BaseCubit baseCubit;
  StoreRepository storeRepository;
  CategoryRepository categoryRepository;
  Map<String, bool> selected = {};
  bool get selectedEmpty => selected.isEmpty || selected.values.every((e) => e == false);
  List<Category> get tags => baseCubit.categories;

  CategoryManagementCubit({
    required this.baseCubit,
    required this.storeRepository,
    required this.categoryRepository,
  }) : super(CategoryManagementInitial());

  void toggleDeleteMode() {
    screenMode = screenMode == ScreenMode.delete ? ScreenMode.display : ScreenMode.delete;
    if (screenMode == ScreenMode.display) {
      selected.clear();
    }

    emit(CategoryManagementRefresh(DateTime.now()));
  }

  void refresh() {
    emit(CategoryManagementRefresh(DateTime.now()));
  }

  void setSelect(String id) {
    if (screenMode == ScreenMode.display) {
      return;
    }

    selected[id] = !(selected[id] ?? false);
    emit(CategoryManagementRefresh(DateTime.now()));
  }

  void deleteSelected() async {
    emit(CategoryManagementLoading());
    selected.removeWhere((key, value) => value == false);
    log('remove ${selected.keys}');

    final categoryListUpdate =
        baseCubit.categories.where((e) => !selected.keys.toList().contains(e.id)).map((e) => e.id).toList();
    Store storeUpdated = baseCubit.store!..categories = categoryListUpdate;

    await storeRepository.update(baseCubit.store!.id, storeUpdated);
    baseCubit.loadCategoryByCurrentStore();
    toggleDeleteMode();
    emit(CategoryManagementSuccess());
  }
}
