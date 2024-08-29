import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class CreateTagCubit extends Cubit<CreateTagState> {
  String name = '';
  Color backgroundColor = Colors.white;
  Color borderColor = Colors.white;
  BaseCubit baseCubit;
  StoreRepository storeRepository;

  Store? get currentStore => baseCubit.store;

  CreateTagCubit({
    required this.storeRepository,
    required this.baseCubit,
  }) : super(CreateTagInitial());

  setName(String? value) {
    name = value?.trim() ?? '';
    emit(CreateTagRefresh(DateTime.now()));
  }

  setColor(Color? value) {
    backgroundColor = value ?? Colors.transparent;
    emit(CreateTagRefresh(DateTime.now()));
  }

  void doSubmit() async {
    emit(CreateTagLoading());
    final storeUpdated = await storeRepository.update(
      currentStore!.id,
      currentStore!
        ..tags?.add(
          Tag(
            id: const Uuid().v1(),
            name: name,
            color: backgroundColor.toHex(),
            borderColor: borderColor.toHex(),
          ),
        ),
    );

    emit(CreateTagSuccess());
  }

  setBorderColor(Color value) {
    borderColor = value;
    emit(CreateTagRefresh(DateTime.now()));
  }
}
