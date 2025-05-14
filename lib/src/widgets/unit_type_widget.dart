import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/unit_type.dart';
import 'package:flutter/cupertino.dart';

class UnitTypeWidget extends StatelessWidget {
  const UnitTypeWidget({super.key, required this.unitType});

  final UnitType? unitType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${LocaleKeys.locales_enValue.tr(args: [unitType?.name.en ?? '-'])} ( ${unitType?.shortName.en} )'),
          Text('${LocaleKeys.locales_thValue.tr(args: [unitType?.name.th ?? '-'])} ( ${unitType?.shortName.th} )'),
        ],
      ),
    );
  }
}
