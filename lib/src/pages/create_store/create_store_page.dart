// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/main.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_router.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_state.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_router.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:get_it/get_it.dart';

class CreateStorePage extends StatefulWidget {
  const CreateStorePage({
    super.key,
  });

  @override
  _CreateStoreState createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStorePage> {
  late CreateStoreCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CreateStoreCubit(
      storeRepository: GetIt.I<StoreRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
      userRepository: GetIt.I<UserRepository>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((time) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<CreateStoreCubit, CreateStoreState>(
        listener: (context, state) {
          if (state is CreateStoreSuccess) {
            CreateStoreRouter(context).pop();
          }
        },
        child: BlocBuilder<CreateStoreCubit, CreateStoreState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.createStore.tr(),
                actions: [],
              ).build(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormFieldUiWidget(
                          label: LocaleKeys.name.tr(),
                          onChanged: _cubit.setName,
                        ),
                        TextFormFieldUiWidget(
                          label: LocaleKeys.description.tr(),
                          onChanged: _cubit.setDescription,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: ButtonWidget(
                margin: const EdgeInsets.all(16),
                label: 'CREATE',
                onPressed: () {
                  _cubit.submit();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
