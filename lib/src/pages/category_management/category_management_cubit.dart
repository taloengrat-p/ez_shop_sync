import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/category_management/category_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class CategoryManagementCubit extends Cubit<CategoryManagementState> {
  final AppCubit appCubit;
  final StoreRepository storeRepository;
  final CategoryRepository categoryRepository;

  ScreenMode screenMode = ScreenMode.display;
  Map<String, bool> selected = {};
  bool get selectedEmpty => selected.isEmpty || selected.values.every((e) => e == false);
  List<Category> get tags => appCubit.categories;

  CategoryManagementCubit({required this.appCubit, required this.storeRepository, required this.categoryRepository})
    : super(CategoryManagementInitial());

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
        appCubit.categories.where((e) => !selected.keys.toList().contains(e.id)).map((e) => e.id.toString()).toList();
    Store storeUpdated = appCubit.store!..categories = categoryListUpdate;

    await storeRepository.update(
      BaseRepoRequest(storeId: appCubit.storeId ?? '', userId: appCubit.userId ?? '', data: storeUpdated),
    );
    appCubit.loadCategoryByCurrentStore();
    toggleDeleteMode();
    emit(CategoryManagementSuccess());
  }
}
