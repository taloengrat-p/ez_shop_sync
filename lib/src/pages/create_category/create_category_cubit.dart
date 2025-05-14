import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  final AppCubit appCubit;
  final CategoryRepository categoryRepository;
  final StoreRepository storeRepository;
  BaseHiveData? info;
  String name = '';
  Color backgroundColor = Colors.white;
  Color borderColor = Colors.white;
  String? id;
  // IconData? iconData;
  ScreenMode screenMode = ScreenMode.create;

  Store? get currentStore => appCubit.store;

  CreateCategoryCubit({required this.appCubit, required this.categoryRepository, required this.storeRepository})
    : super(CreateCategoryInitial());

  setName(String? value) {
    name = value ?? '';
    emit(CreateCategoryRefresh(DateTime.now()));
  }

  setColor(Color? value) {
    backgroundColor = value ?? Colors.transparent;
    emit(CreateCategoryRefresh(DateTime.now()));
  }

  void doCreateSubmit() async {
    emit(CreateCategoryLoading());

    final categoryCreated = await categoryRepository.create(
      appCubit.request(
        Category(
          name: name.trim(),
          parentId: null,
          // iconData: iconData != null ? serializeIcon(iconData!) : null,
          color: backgroundColor.toHex(),
          borderColor: borderColor.toHex(),
        ),
      ),
    );

    categoryCreated.when(
      success: (tagResponse) async {
        await appCubit.loadCategoryByCurrentStore();
        emit(CreateCategorySuccess(tagResponse));
      },
      failure: (error) {
        emit(const CreateCategoryFailure());
      },
    );
  }

  void doSaveSubmit() async {
    emit(CreateCategoryLoading());

    final categoryCreated = await categoryRepository.update(
      appCubit.request(
        Category(
          id: id,
          name: name.trim(),
          parentId: null,
          // iconData: iconData != null ? serializeIcon(iconData!) : null,
          color: backgroundColor.toHex(),
          borderColor: borderColor.toHex(),
          info: info,
        ),
      ),
    );

    categoryCreated.when(
      success: (tagResponse) async {
        await appCubit.loadCategoryByCurrentStore();
        emit(const CreateCategoryUpdateSuccess());
      },
      failure: (error) {
        emit(const CreateCategoryFailure());
      },
    );
  }

  setBorderColor(Color value) {
    borderColor = value;
    emit(CreateCategoryRefresh(DateTime.now()));
  }

  void setArgrument(Category argruments) {
    info ??= argruments.info;
    id = argruments.id;
    borderColor = argruments.borderColor?.toColor() ?? Colors.white;
    backgroundColor = argruments.color?.toColor() ?? Colors.white;
    name = argruments.name;
    screenMode = ScreenMode.edit;
    emit(CreateCategoryInitial());
  }

  // setIcon(IconData? value) {
  //   iconData = value;
  // }
}
