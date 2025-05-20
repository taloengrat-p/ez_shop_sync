import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';

class BodyWidget extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final List<Widget>? actions;
  final Widget? header;
  final Widget? titleWidget;
  final bool isInitialLoading;
  const BodyWidget({
    super.key,
    required this.children,
    this.title,
    this.actions,
    this.header,
    this.titleWidget,
    this.isInitialLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: DimensionsKeys.pagePaddingHzt),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    titleWidget ?? Text(title ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ...actions?.toList() ?? [],
                  ],
                ),
              ),
              if (header != null) ...[const SizedBox(height: 8), header!],
            ],
          ),
        ),
        Expanded(
          child:
              isInitialLoading
                  ? const AppLoadingWidget()
                  : Container(
                    // margin: ,
                    padding: const EdgeInsets.only(
                      left: DimensionsKeys.pagePaddingHzt,
                      right: DimensionsKeys.pagePaddingHzt,
                    ),
                    child: Column(children: [...children, const SizedBox(height: 50)]),
                  ),
        ),
      ],
    );
  }
}
