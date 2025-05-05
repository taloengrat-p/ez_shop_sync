import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/pages/notification_detail/notification_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/notification_detail/notification_detail_router.dart';
import 'package:ez_shop_sync/src/pages/notification_detail/notification_detail_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/action_button_group.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class NotificationDetailPage extends StatefulWidget {
  const NotificationDetailPage({super.key});

  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetailPage> {
  final _cubit = GetIt.I<NotificationDetailCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argrument = ModalRoute.of(context)?.settings.arguments;
      if (argrument is NotificationDetailArgrument) {
        _cubit.intialize(argrument);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationDetailCubit, NotificationDetailState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is NotificationDetailSuccess) {
          NotificationDetailRouter(context).pop();
        }
      },
      child: BlocBuilder<NotificationDetailCubit, NotificationDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isLoading: state is NotificationDetailLoading,
            appBar: AppbarWidget(context, centerTitle: false, title: "NotificationDetail", actions: []).build(),
            body: _buildPage(context, state),
            bottomNavigationBar: ActionButtonGroupWidget(
              margin: const EdgeInsets.all(16),
              direction: Axis.horizontal,
              confirmLabel: 'Accept',
              cancelLabel: 'Reject',
              onConfirm: () {
                _cubit.doAccept();
              },
              onCancel: () {
                _cubit.doReject();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, NotificationDetailState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),
          const CircleAvatar(radius: 40, child: Icon(Icons.store_rounded, size: 40)),
          const SizedBox(height: 16),
          Text('You received an invitation from ', style: Theme.of(context).textTheme.titleMedium?.copyWith()),
          Text(
            _cubit.argrument?.notification.title ?? '',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          Container(height: DimensionsKeys.heightBts),
        ],
      ),
    );
  }
}
