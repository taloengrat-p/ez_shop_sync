import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/notification_settings/notification_settings_cubit.dart';
import 'package:ez_shop_sync/src/pages/notification_settings/notification_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/res/dimensions.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettingsPage> {
  late NotificationSettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = NotificationSettingsCubit();

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
      child: BlocListener<NotificationSettingsCubit, NotificationSettingsState>(
        listener: (context, state) {},
        child: BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
          builder: (context, state) {
            return BaseScaffolds(
              bodyPadding: const EdgeInsets.symmetric(horizontal: 16),
              appBar:
                  AppbarWidget(
                    context,
                    centerTitle: false,
                    title: LocaleKeys.notificationSettings_title.tr(),
                    actions: [],
                  ).build(),
              body: _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, NotificationSettingsState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(LocaleKeys.notificationSettings_orderSuccess.tr())),
              Row(
                children: [
                  Text(LocaleKeys.notificationSettings_off.tr()),
                  const SizedBox(width: 4),
                  Switch.adaptive(
                    value: false,
                    activeColor: ColorKeys.primary,
                    onChanged: (val) => _cubit.toggle(val),
                  ),
                  const SizedBox(width: 4),
                  Text(LocaleKeys.notificationSettings_on.tr()),
                ],
              ),
            ],
          ),
          Container(height: DimensionsKeys.heightBts),
        ],
      ),
    );
  }
}
