import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/widgets/buttons/action_button_group.dart';
import 'package:flutter/material.dart';

enum ConfirmDialogResult {
  cancel,
  ok;
}

class ConfirmDialogUiWidget {
  BuildContext context;
  String? cancelLabel;
  String? confirmLabel;
  Widget? header;
  String? title;
  String? desc;
  bool barrierDismissible;
  bool closeByBackButton;
  Color? confirmColor;
  Color? cancelColor;
  // HtmlWidget? htmlWidget;
  ConfirmDialogUiWidget(
    this.context, {
    this.cancelLabel,
    this.confirmLabel,
    this.title,
    this.desc,
    this.header,
    this.barrierDismissible = true,
    this.closeByBackButton = true,
    this.cancelColor,
    this.confirmColor,
    // this.htmlWidget,
  });

  Future<ConfirmDialogResult?> show() async {
    return await showDialog<ConfirmDialogResult?>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (builder) {
          return PopScope(
            canPop: closeByBackButton == true,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Dialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorKeys.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                            padding: const EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ...[
                                    if (header != null) header!,
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                  if (title != null) ...[
                                    Text(
                                      title!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                  // htmlWidget ??
                                  Text(
                                    desc ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ActionButtonGroupWidget(
                            cancelLabel: cancelLabel,
                            confirmLabel: confirmLabel,
                            confirmColor: confirmColor,
                            cancelColor: cancelColor,
                            onCancel: () {
                              Navigator.pop(context, ConfirmDialogResult.cancel);
                            },
                            onConfirm: () {
                              Navigator.pop(context, ConfirmDialogResult.ok);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // if (AliceLogUtils.isShowAliceLogDevTools(context))
                //   Align(
                //     alignment: Alignment.bottomRight,
                //     child: Container(
                //       margin: const EdgeInsets.only(right: 16, bottom: 16),
                //       child: const FloatingDebugDialogData(),
                //     ),
                //   )
              ],
            ),
          );
        });
  }
}
