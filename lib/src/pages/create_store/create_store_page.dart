// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_router.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_state.dart';
import 'package:ez_shop_sync/src/pages/main/main_router.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_router.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_state.dart';
import 'package:ez_shop_sync/src/routes/routes.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreateStorePage extends StatefulWidget {
  const CreateStorePage({super.key});

  @override
  _CreateStoreState createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStorePage> {
  final _cubit = GetIt.I<CreateStoreCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argruments = ModalRoute.of(context)?.settings.arguments;

      if (argruments is CreateStoreArgrument) {
        _cubit.initial(argruments);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateStoreCubit, CreateStoreState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is CreateStoreSuccess) {
          if (_cubit.argruments != null) {
            OrderCompleteRouter(context).replace(
              argruments: const OrderCompleteArgrument(title: 'Create Store Success', from: Routes.ROUTE_CREATESTORE),
            );
          } else {
            CreateStoreRouter(context).pop();
          }
        }
      },
      child: BlocBuilder<CreateStoreCubit, CreateStoreState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isLoading: state is CreateStoreLoading,
            appBar:
                AppbarWidget(
                  context,
                  centerTitle: false,
                  title: LocaleKeys.createStore.tr(),
                  actions: [
                    if (_cubit.argruments != null)
                      TextButton(
                        onPressed: () {
                          MainRouter(context).replace();
                        },
                        child: Text(
                          LocaleKeys.button_skip.tr(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueAccent),
                        ),
                      ),
                  ],
                ).build(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: [
                      const CircleAvatar(radius: 44, child: Icon(Icons.store_mall_directory_rounded, size: 44)),
                      const SizedBox(height: 16),
                      AppTextFormFieldUiWidget(label: LocaleKeys.name.tr(), onChanged: _cubit.setName, autofocus: true),
                      AppTextFormFieldUiWidget(
                        label: LocaleKeys.optionalField.tr(args: [LocaleKeys.description.tr()]),
                        onChanged: _cubit.setDescription,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: ButtonWidget(
              disabled: _cubit.name.isEmpty,
              margin: const EdgeInsets.all(16),
              label: 'CREATE',
              onPressed: () {
                _cubit.submit();
              },
            ),
          );
        },
      ),
    );
  }
}
