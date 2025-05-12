import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/tag/tag_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Injectable()
class CreateTagCubit extends Cubit<CreateTagState> {
  final AppCubit appCubit;
  final StoreRepository storeRepository;
  final TagRepository tagRepository;

  String name = '';
  Color backgroundColor = Colors.white;
  Color borderColor = Colors.white;

  Store? get currentStore => appCubit.store;

  CreateTagCubit({required this.storeRepository, required this.appCubit, required this.tagRepository})
    : super(CreateTagInitial());

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

    final tagId = const Uuid().v1();
    final tagCreated = await tagRepository.create(
      appCubit.request(Tag(id: tagId, name: name, color: backgroundColor.toHex(), borderColor: borderColor.toHex())),
    );

    tagCreated.when(
      success: (tagResponse) async {
        final storeUpdated = await storeRepository.update(
          appCubit.request(currentStore!..tags?.add(tagCreated.response?.id)),
        );

        storeUpdated.when(
          success: (response) {
            appCubit.loadTagsByCurrentStore();
            log('storeUpdated ${storeUpdated.response?.tags}');
            emit(CreateTagSuccess(tagResponse));
          },
          failure: (error) {
            emit(const CreateTagFailure());
          },
        );
      },
    );
  }

  setBorderColor(Color value) {
    borderColor = value;
    emit(CreateTagRefresh(DateTime.now()));
  }
}
