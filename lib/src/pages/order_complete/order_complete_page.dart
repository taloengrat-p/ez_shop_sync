import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/pages/main/main_router.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_cubit.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_state.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_router.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCompletePage extends StatefulWidget {
  const OrderCompletePage({
    super.key,
  });

  @override
  _OrderCompleteState createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderCompletePage> {
  late OrderCompleteCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OrderCompleteCubit();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argruments = ModalRoute.of(context)?.settings.arguments;

      if (argruments is OrderCompleteArgrument) {
        _cubit.setArgruments(argruments);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<OrderCompleteCubit, OrderCompleteState>(
        listener: (context, state) {},
        child: BlocBuilder<OrderCompleteCubit, OrderCompleteState>(
          builder: (context, state) {
            return BaseScaffolds(
              body: _buildPage(context, state),
              bottomNavigationBar: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: ButtonWidget(
                  backgroundColor: Colors.black,
                  height: 44,
                  label: LocaleKeys.backToHomePage.tr(),
                  onPressed: () {
                    MainRouter(context).pushNamedAndRemoveUntil();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, OrderCompleteState state) {
    return SizedBox(
      width: double.infinity,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.check_circle_rounded,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                _cubit.argruments?.title ?? '',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(_cubit.createDate.toDisplayDependLocale(context, format: DateFormatConstance.D_MMM_YYYY_HH_mm)),
              const SizedBox(
                height: 16,
              ),
              buildTitleValueInfo(
                LocaleKeys.orderId.tr(),
                _cubit.transactionId,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitleValueInfo(String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: InkWell(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    decorationColor: Colors.blue,
                  ),
            ),
            onTap: () {
              if (_cubit.argruments?.transactionMethodType == TransactionMethodType.order) {
                OrderHistoryDetailRouter(context).replace(
                  argruments: OrderHistoryDetailArgruments(
                    productOrder: _cubit.argruments?.orderItems,
                  ),
                );
              } else if (_cubit.argruments?.transactionMethodType == TransactionMethodType.addProduct) {
                OrderHistoryDetailRouter(context).replace(
                  argruments: OrderHistoryDetailArgruments(
                    productOrder: _cubit.argruments?.orderItems,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
