import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:flutter/material.dart';

extension DateTimeNullableExtension on DateTime? {
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

  String format(String format) {
    if (this == null) {
      return '--';
    }

    String formattedDate = DateFormat(format).format(this!);

    return formattedDate;
  }
}

extension DateTimeExtension on DateTime {
  DateTime getStartOfWeek() {
    int daysToSubtract = weekday - DateTime.monday;
    return subtract(Duration(days: daysToSubtract));
  }

  DateTime getEndOfWeek() {
    int daysToAdd = DateTime.sunday - weekday;
    return add(Duration(days: daysToAdd));
  }
}

extension ListDateTimeExtension on List<DateTime> {
  String displayWeekFormat(BuildContext context) {
    if (first.month == last.month && first.year == last.year) {
      return '${first.day} - ${last.day} ${first.toDisplayDependLocale(context, format: DateFormatConstance.MMMM_YYYY)}';
    } else if (first.month != last.month && first.year == last.year) {
      return '${first.toDisplayDependLocale(context, format: DateFormatConstance.DD_MMMM)} - ${last.toDisplayDependLocale(context, format: DateFormatConstance.DD_MMMM)} ${last.year}';
    } else {
      return '${first.toDisplayDependLocale(context, format: DateFormatConstance.D_MMM_YYYY)} - ${last.toDisplayDependLocale(context, format: DateFormatConstance.D_MMM_YYYY)}';
    }
  }
}
