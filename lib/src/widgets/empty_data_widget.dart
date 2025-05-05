import 'package:ez_shop_sync/res/drawables.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter/cupertino.dart';
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
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const ClassicHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(height: 55.0, child: Center(child: body));
        },
      ),
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
          if (widget.message.isNotNull)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(widget.message!, textAlign: TextAlign.center),
            ),
        ],
      ),
    );
  }
}
