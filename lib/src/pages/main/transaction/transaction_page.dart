import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';

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
    );
  }
}
