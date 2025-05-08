import 'package:ez_shop_sync/res/drawables.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/widgets/app_pagination_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmptyDataWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final String? message;
  final IconData? icon;
  final Function()? onRefresh;
  final Function()? onLoading;
  const EmptyDataWidget({super.key, this.height, this.width, this.message, this.icon, this.onRefresh, this.onLoading});

  @override
  State<EmptyDataWidget> createState() => _EmptyDataWidgetState();
}

class _EmptyDataWidgetState extends State<EmptyDataWidget> {
  final _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await widget.onRefresh?.call();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await widget.onLoading?.call();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return AppPaginationLoadingWidget(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          widget.icon != null
              ? Icon(widget.icon, size: 120, color: Colors.grey)
              : Image.asset(Drawables.emptyData, height: widget.height, width: widget.width),
          const SizedBox(height: 24),
          if (widget.message.isNotNull)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
