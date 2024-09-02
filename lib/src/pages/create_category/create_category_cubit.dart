import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker_plus/Serialization/iconDataSerialization.dart';
import 'package:uuid/uuid.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  final BaseCubit baseCubit;
  final CategoryRepository categoryRepository;
  final StoreRepository storeRepository;

  String name = '';
  Color backgroundColor = Colors.white;
  Color borderColor = Colors.white;
  IconData? iconData;

  Store? get currentStore => baseCubit.store;

  CreateCategoryCubit({
    required this.baseCubit,
    required this.categoryRepository,
    required this.storeRepository,
  }) : super(CreateCategoryInitial());

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
    final tagCreated = await categoryRepository.create(Category(
      id: tagId,
      name: name,
      parentId: null,
      iconData: iconData != null ? serializeIcon(iconData!) : null,
      color: backgroundColor.toHex(),
      borderColor: borderColor.toHex(),
    ));

    final storeUpdated = await storeRepository.update(
      currentStore!.id,
      currentStore!..categories?.add(tagCreated.id),
    );

    baseCubit.loadCategoryByCurrentStore();
    log('storeUpdated ${storeUpdated.tags}');
    emit(CreateCategorySuccess(tagCreated));
  }

  setBorderColor(Color value) {
    borderColor = value;
    emit(CreateCategoryRefresh(DateTime.now()));
  }

  setIcon(IconData? value) {
    iconData = value;
  }
}
