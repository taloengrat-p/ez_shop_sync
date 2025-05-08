import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppPaginationLoadingWidget extends StatelessWidget {
  /// Refresh Content
  ///
  /// notice that: If child is  extends ScrollView,It will help you get the internal slivers and add footer and header in it.
  /// else it will put child into SliverToBoxAdapter and add footer and header
  final Widget? child;

  /// header indicator displace before content
  ///
  /// If reverse is false,header displace at the top of content.
  /// If reverse is true,header displace at the bottom of content.
  /// if scrollDirection = Axis.horizontal,it will display at left or right
  ///
  /// from 1.5.2,it has been change RefreshIndicator to Widget,but remember only pass sliver widget,
  /// if you pass not a sliver,it will throw error
  final Widget? header;

  /// footer indicator display after content
  ///
  /// If reverse is true,header displace at the top of content.
  /// If reverse is false,header displace at the bottom of content.
  /// if scrollDirection = Axis.horizontal,it will display at left or right
  ///
  /// from 1.5.2,it has been change LoadIndicator to Widget,but remember only pass sliver widget,
  //  if you pass not a sliver,it will throw error
  final Widget? footer;
  // This bool will affect whether or not to have the function of drop-up load.
  final bool enablePullUp;

  /// controll whether open the second floor function
  final bool enableTwoLevel;

  /// This bool will affect whether or not to have the function of drop-down refresh.
  final bool enablePullDown;

  /// callback when header refresh
  ///
  /// when the callback is happening,you should use [RefreshController]
  /// to end refreshing state,else it will keep refreshing state
  final VoidCallback? onRefresh;

  /// callback when footer loading more data
  ///
  /// when the callback is happening,you should use [RefreshController]
  /// to end loading state,else it will keep loading state
  final VoidCallback? onLoading;

  /// callback when header ready to twoLevel
  ///
  /// If you want to close twoLevel,you should use [RefreshController.closeTwoLevel]
  final OnTwoLevel? onTwoLevel;

  /// Controll inner state
  final RefreshController controller;

  /// child content builder
  final RefresherBuilder? builder;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final Axis? scrollDirection;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final bool? reverse;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final ScrollController? scrollController;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final bool? primary;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final ScrollPhysics? physics;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final double? cacheExtent;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final int? semanticChildCount;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final DragStartBehavior? dragStartBehavior;

  const AppPaginationLoadingWidget({
    super.key,
    this.child,
    this.header,
    this.footer,
    this.enablePullDown = true,
    this.enablePullUp = false,
    this.enableTwoLevel = false,
    this.onRefresh,
    this.onLoading,
    this.onTwoLevel,
    required this.controller,
    this.builder,
    this.scrollDirection,
    this.reverse,
    this.scrollController,
    this.primary,
    this.physics,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      enableTwoLevel: enableTwoLevel,
      header: ClassicHeader(
        idleText: LocaleKeys.refreshPagination_idleText.tr(),
        failedText: LocaleKeys.refreshPagination_failedText.tr(),
        refreshingText: LocaleKeys.refreshPagination_refreshingText.tr(),
        releaseText: LocaleKeys.refreshPagination_releaseText.tr(),
        completeText: LocaleKeys.refreshPagination_completeText.tr(),
        canTwoLevelText: LocaleKeys.refreshPagination_canTwoLevelText.tr(),
      ),
      footer: ClassicFooter(
        loadingText: LocaleKeys.loadingPagination_loadingText.tr(),
        canLoadingText: LocaleKeys.loadingPagination_canLoadingText.tr(),
        idleText: LocaleKeys.loadingPagination_idleText.tr(),
        noDataText: LocaleKeys.loadingPagination_noDataText.tr(),
        failedText: LocaleKeys.loadingPagination_failedText.tr(),
      ),
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}
