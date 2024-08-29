import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_cubit.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_router.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extendsions.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_preview_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:get_it/get_it.dart';

class ThemeSettingPage extends StatefulWidget {
  const ThemeSettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _ThemeSettingState createState() => _ThemeSettingState();
}

class _ThemeSettingState extends State<ThemeSettingPage> {
  late ThemeSettingCubit _cubit;
  final primaryController = GlobalKey<TextFormFieldColorPickerWidgetState>();
  final secondaryController = GlobalKey<TextFormFieldColorPickerWidgetState>();
  final accentController = GlobalKey<TextFormFieldColorPickerWidgetState>();
  final backgroundController = GlobalKey<TextFormFieldColorPickerWidgetState>();
  @override
  void initState() {
    super.initState();

    _cubit = ThemeSettingCubit(
      baseCubit: GetIt.I<BaseCubit>(),
      storeRepository: GetIt.I<StoreRepository>(),
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
      child: BlocListener<ThemeSettingCubit, ThemeSettingState>(
        listener: (context, state) {
          if (state is ThemeSettingSuccess) {
            ThemeSettingRouter(context).pop(state);
          } else if (state is ThemeSettingReset) {
            primaryController.currentState?.reset();
            secondaryController.currentState?.reset();
            accentController.currentState?.reset();
            backgroundController.currentState?.reset();
          }
        },
        child: BlocBuilder<ThemeSettingCubit, ThemeSettingState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                centerTitle: false,
                title: LocaleKeys.themeSettings.tr(),
                actions: [
                  TextButton(
                    onPressed: () {
                      _cubit.reset();
                    },
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: GetIt.I<BaseCubit>()
                            .appTheme
                            ?.primaryColor
                            .toColor()
                            .getContrast(),
                      ),
                    ),
                  )
                ],
              ).build(),
              body: _buildPage(context, state),
              bottomNavigationBar: ButtonWidget(
                disabled: false,
                margin: const EdgeInsets.all(16),
                label: 'SAVE',
                onPressed: _cubit.hasChange
                    ? () {
                        _cubit.doSaveAppTheme();
                      }
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, ThemeSettingState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ContainerPreviewWidget(
              height: 200,
              child: Container(
                width: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      width: double.infinity,
                      color: _cubit.primary,
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 10,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            'data',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _cubit.secondary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 3,
                            ),
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              _cubit.storeName,
                              style: TextStyle(fontSize: 3),
                            ),
                            Spacer(),
                            CircleAvatar(
                              radius: 2,
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            CircleAvatar(
                              radius: 2,
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    ButtonWidget(
                      label: 'Button',
                      height: 15,
                      backgroundColor: _cubit.accent,
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.bold),
                      margin: EdgeInsets.all(
                        3,
                      ),
                      radius: 3,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormFieldColorPickerWidget(
              key: primaryController,
              label: 'Primary Color',
              initialColor: _cubit.primary,
              onSelected: _cubit.setPrimary,
            ),
            TextFormFieldColorPickerWidget(
              key: secondaryController,
              label: 'Secondary Color',
              initialColor: _cubit.secondary,
              onSelected: _cubit.setSecondary,
            ),
            TextFormFieldColorPickerWidget(
              key: accentController,
              label: 'Third Color',
              initialColor: _cubit.accent,
              onSelected: _cubit.setAccent,
            ),
            TextFormFieldColorPickerWidget(
              key: backgroundController,
              label: 'Background Color',
              initialColor: _cubit.backgroundColor,
              onSelected: _cubit.setBackgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
