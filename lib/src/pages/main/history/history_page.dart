import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/main.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffolds(
      appBar: AppbarWidget(context, title: LocaleKeys.histories.tr(), centerTitle: false)
          .build(),
    );
  }
}
