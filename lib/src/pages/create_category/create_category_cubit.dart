import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Singleton()
class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  final AppCubit appCubit;
  final CategoryRepository categoryRepository;
  final StoreRepository storeRepository;

  String name = '';
  Color backgroundColor = Colors.white;
  Color borderColor = Colors.white;
  IconData? iconData;

  Store? get currentStore => appCubit.store;

  CreateCategoryCubit({required this.appCubit, required this.categoryRepository, required this.storeRepository})
    : super(CreateCategoryInitial());

  setName(String? value) {
    name = value?.trim() ?? '';
    emit(CreateCategoryRefresh(DateTime.now()));
  }

  setColor(Color? value) {
    backgroundColor = value ?? Colors.transparent;
    emit(CreateCategoryRefresh(DateTime.now()));
  }

  void doSubmit() async {
    emit(CreateCategoryLoading());

    final tagId = const Uuid().v1();
    final tagCreated = await categoryRepository.create(
      BaseRepoRequest(
        storeId: appCubit.storeId ?? '',
        userId: appCubit.userId ?? '',
        data: Category(
          id: tagId,
          name: name,
          parentId: null,
          // iconData: iconData != null ? serializeIcon(iconData!) : null,
          color: backgroundColor.toHex(),
          borderColor: borderColor.toHex(),
        ),
      ),
    );

    tagCreated.when(
      success: (tagResponse) async {
        final storeUpdated = await storeRepository.update(
          BaseRepoRequest(
            storeId: appCubit.storeId ?? '',
            userId: appCubit.userId ?? '',
            data: currentStore!..categories?.add(tagResponse.id),
          ),
        );

        storeUpdated.when(
          success: (response) {
            appCubit.loadCategoryByCurrentStore();
            log('storeUpdated ${response.tags}');
            emit(CreateCategorySuccess(tagResponse));
          },
        );
      },
    );
  }

  setBorderColor(Color value) {
    borderColor = value;
    emit(CreateCategoryRefresh(DateTime.now()));
  }

  setIcon(IconData? value) {
    iconData = value;
  }
}
