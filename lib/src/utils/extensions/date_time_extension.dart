import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime? {
  String toDisplayDependLocale(
    BuildContext context, {
    String? format,
  }) {
    if (this == null) {
      return ApplicationConstance.emptyData;
    }

    String formattedDate =
        DateFormat(format ?? DateFormatConstance.D_MMM_YYYY_HH_mm, context.locale.languageCode).format(this!);

    return formattedDate;
  }

  String toDisplayDateDependLocale(BuildContext context) {
    return toDisplayDependLocale(context, format: DateFormatConstance.D_MMM_YYYY);
  }

  String toDisplayTimeDependLocale(BuildContext context) {
    return toDisplayDependLocale(context, format: DateFormatConstance.HH_mm);
  }
}
