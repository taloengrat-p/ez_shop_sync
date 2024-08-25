import 'package:ez_shop_sync/src/utils/bottom_sheet_utils.dart';
import 'package:ez_shop_sync/src/utils/image_picker_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottom_sheet/model/bottom_sheet_menu_model.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffolds(
      appBar: AppbarWidget(title: 'Transactions', centerTitle: false).build(),
      body: buildBody(),
    );
  }

  TextStyle get textStyle => const TextStyle(fontSize: 24, color: Colors.white);

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 70),
      child: Column(
        children: [
          Expanded(
            child: ButtonWidget(
              label: 'Create Invoice',
              textStyle: textStyle,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 40,
              ),
              onPressed: onCreateInvoice,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ButtonWidget(
              label: 'Invoice History',
              textStyle: textStyle,
              icon: Icon(
                Icons.history_rounded,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onCreateInvoice() async {
    final result = await BottomSheetUtils.showMenu(
      context,
      title: 'Create Invoice',
      items: [
        BottomSheetMenuModel(
          label: 'Camera',
          icon: Icon(Icons.photo_camera),
          value: 1,
        ),
        BottomSheetMenuModel(
          label: 'Photo Gallary',
          icon: const Icon(Icons.photo),
          value: 2,
        ),
        BottomSheetMenuModel(
          label: 'Product in Stock',
          icon: Icon(CupertinoIcons.cube_box),
          value: 3,
        ),
      ],
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
