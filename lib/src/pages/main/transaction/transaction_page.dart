import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/transaction/transaction_cubit.dart';
import 'package:ez_shop_sync/src/utils/bottom_sheet_utils.dart';
import 'package:ez_shop_sync/src/utils/image_picker_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/body/body_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottom_sheet/bottom_menu_item.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late TransactionCubit cubit;
  @override
  void initState() {
    super.initState();
    log('[init]', name: runtimeType.toString());

    cubit = TransactionCubit(
      baseCubit: GetIt.I<BaseCubit>(),
    );
  }

  @override
  void dispose() {
    log('[dispose]', name: runtimeType.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffolds(
      appBar: AppbarWidget(
        context,
        title: cubit.baseCubit.store?.name,
        centerTitle: false,
      ).build(),
      body: Stack(
        children: [
          buildBody(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 28),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return BodyWidget(
      title: LocaleKeys.transactions.tr(),
      actions: [],
      header: Container(
        color: ColorKeys.primary,
        child: Row(
          children: [
            Expanded(
              child: ButtonWidget(
                label: 'Invoice History',
                axis: Axis.vertical,
                isLabelUpperCase: false,
                backgroundColor: ColorKeys.primary,
                icon: const Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: ButtonWidget(
                label: 'Create Invoice',
                innerRadius: 12,
                axis: Axis.vertical,
                isLabelUpperCase: false,
                backgroundColor: ColorKeys.primary,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: onCreateInvoice,
              ),
            ),
          ],
        ),
      ),
      children: [],
    );
  }

  Future<void> onCreateInvoice() async {
    final items = [
      BottomMenuItem(
        label: 'Camera',
        leading: Icon(Icons.photo_camera),
        value: 1,
      ),
      BottomMenuItem(
        label: 'Photo Gallary',
        leading: const Icon(Icons.photo),
        value: 2,
      ),
      BottomMenuItem(
        label: 'Product in Stock',
        leading: Icon(CupertinoIcons.cube_box),
        value: 3,
      ),
    ];
    final result = await BottomSheetUtils.showDragable(
      context,
      title: 'Create Invoice',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ...items.map(
              (e) => e,
            )
          ],
        ),
      ),
    );

    if (result == 1) {
      // do create invoice by choose image
      final image = await ImagePickerUtils.pickImage(imageSource: ImageSource.camera);
    } else if (result == 2) {
      // do create invoice by photo gallary
      final image = await ImagePickerUtils.pickImage(imageSource: ImageSource.gallery);
    } else if (result == 3) {
      // do create invoice by product in stock
    }
  }
}
