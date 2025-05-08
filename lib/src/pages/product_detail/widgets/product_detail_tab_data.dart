import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:flutter/widgets.dart';

class ProductDetailTabData extends StatefulWidget {
  final IconData? emptyIcon;
  const ProductDetailTabData({super.key, this.emptyIcon});

  @override
  _ProductDetailTabDataState createState() => _ProductDetailTabDataState();
}

class _ProductDetailTabDataState extends State<ProductDetailTabData> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyDataWidget(height: 200, icon: widget.emptyIcon, message: LocaleKeys.productStatisticEmpty.tr()),
    );
  }
}
