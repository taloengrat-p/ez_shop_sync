import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/notification/notification_cubit.dart';
import 'package:ez_shop_sync/src/pages/notification/notification_state.dart';
import 'package:ez_shop_sync/src/pages/notification_detail/notification_detail_router.dart';
import 'package:ez_shop_sync/src/pages/notification_detail/notification_detail_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  final _cubit = GetIt.I.get<NotificationCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argruments = ModalRoute.of(context)?.settings.arguments;

      if (argruments is NotificationArgrument) {
        _cubit.initial(argrument: argruments);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      bloc: _cubit,
      listener: (context, state) {},
      child: BlocBuilder<NotificationCubit, NotificationState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            onRefresh: () async {
              _cubit.initial(force: true);
            },
            isEmpty: _cubit.notifications.isEmpty,
            emptyIcon: Icons.notifications,
            appBar:
                AppbarWidget(
                  context,
                  centerTitle: false,
                  title: LocaleKeys.notifications_title.tr(),
                  actions: [],
                ).build(),
            body: _buildPage(context, state),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, NotificationState state) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _cubit.notifications.length,
      itemBuilder: (context, index) {
        final item = _cubit.notifications[index];
        return InkWell(
          onTap: () {
            NotificationDetailRouter(context).navigate(argruments: NotificationDetailArgrument(item));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.store_mall_directory_rounded)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(item.type?.display() ?? ''), Text(item.title ?? '')],
                  ),
                ),
                Text(item.getCreateAt.toLocal().toDisplayConditionTimeAgoDisplay(context)),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(color: Colors.grey);
      },
    );
  }
}
