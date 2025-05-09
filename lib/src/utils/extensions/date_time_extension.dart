import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:ez_shop_sync/src/utils/extensions/int_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

extension DateTimeNullableExtension on DateTime? {
  String toDisplayDependLocale(BuildContext context, {String? format}) {
    if (this == null) {
      return ApplicationConstance.emptyData;
    }

    String formattedDate = DateFormat(
      format ?? DateFormatConstance.D_MMM_YYYY_HH_mm,
      context.locale.languageCode,
    ).format(this!);

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
  String toDisplayConditionTimeAgoDisplay(BuildContext context) {
    final timeMessage = millisecondsSinceEpoch;
    final now = DateTime.now().millisecondsSinceEpoch;

    final spaceTime = (now - timeMessage) / 1000;

    if (spaceTime <= 3600) {
      // over 1 hour
      final minute = (spaceTime).toInt().toMinute().toString();

      return minute == '0' ? 'now' : '{}m'.tr(args: [minute]);
    } else if (spaceTime > 3600 && spaceTime <= 86400) {
      return toDisplayTimeDependLocale(context);
    } else {
      return toDisplayDateDependLocale(context);
    }
  }

  String toDisplay({String? format}) {
    String formattedDate = DateFormat(format ?? DateFormatConstance.D_MMM_YYYY_HH_mm).format(this);

    return formattedDate;
  }

  int getMonthYear() {
    final now = DateTime.now();

    return now.month;
  }

  int getWeekMonth() {
    // Find the first day of the month
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Calculate the offset for the first day (e.g., Monday = 1, Sunday = 7)
    int firstDayOffset = firstDayOfMonth.weekday;

    // Calculate the week number, assuming each week starts on Monday
    int weekNumber = ((day + firstDayOffset - 2) / 7).floor() + 1;

    return weekNumber;
  }

  String displayRangeByWeekOfMonth() {
    return getFirstDaysOfWeeks().day.toString();
  }

  Map<String, DateTime> getWeekStartAndEndDates(int year, int month, int weekNumber) {
    // Start with the first day of the month
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Calculate the first Monday in the month or use the first day if there's no Monday in the month
    int daysToFirstMonday = (DateTime.monday - firstDayOfMonth.weekday) % 7;
    DateTime firstMonday = firstDayOfMonth.add(Duration(days: daysToFirstMonday));
    DateTime weekStart = firstMonday.add(Duration(days: (weekNumber - 1) * 7));

    // If the calculated week start is before the current month, set it to the first day of the month
    if (weekStart.month < month) {
      weekStart = firstDayOfMonth;
    }

    // Calculate the end of the week (6 days after the start of the week)
    // DateTime weekEnd = weekStart.add(Duration(days: 6));
    int daysToSunday = DateTime.sunday - weekStart.weekday;
    DateTime weekEnd = weekStart.add(Duration(days: daysToSunday));
    // If the week end is beyond the last day of the month, set it to the last day of the month
    DateTime lastDayOfMonth = DateTime(year, month + 1, 1).subtract(const Duration(days: 1));
    if (weekEnd.month > month) {
      weekEnd = lastDayOfMonth;
    }

    return {"start": weekStart, "end": weekEnd};
  }

  DateTime getFirstDaysOfWeeks() {
    late DateTime firstDaysOfWeeks;

    // Get the first day of the month
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Calculate the first Monday of the month
    int daysToFirstMonday = (DateTime.monday - firstDayOfMonth.weekday) % 7;
    DateTime firstMonday = firstDayOfMonth.add(Duration(days: daysToFirstMonday));

    // If the first Monday is not in the current month, start from the first day of the month
    DateTime startDay = firstMonday.month == month ? firstMonday : firstDayOfMonth;

    // Add each first day of the week until we reach the next month
    while (startDay.month == month) {
      firstDaysOfWeeks = startDay;
      startDay = startDay.add(const Duration(days: 7)); // Move to the next week
    }

    return firstDaysOfWeeks;
  }

  DateTime getStartOfWeek() {
    int daysToSubtract = weekday - DateTime.monday;
    return subtract(Duration(days: daysToSubtract));
  }

  DateTime getEndOfWeek() {
    int daysToAdd = DateTime.sunday - weekday;
    return add(Duration(days: daysToAdd));
  }

  DateTime getFirstDayOfMonth() {
    return DateTime(year, month, 1);
  }

  DateTime getLastDayByMonth() {
    DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);

    return firstDayOfNextMonth.subtract(const Duration(days: 1));
  }

  bool isFirstWeekOfMonth() {
    return day <= 7;
  }

  bool isLastWeekOfMonth() {
    DateTime lastDay = DateTime(year, month + 1, 1).subtract(const Duration(days: 1));
    return day >= lastDay.day - 6;
  }

  bool isDayActived() {
    DateTime today = DateTime.now();
    return isBefore(today) || isAtSameMomentAs(today);
  }

  bool isWeekActived() {
    DateTime today = DateTime.now();

    int toDayWeekMonth = today.getWeekMonth();

    return toDayWeekMonth >= day;
  }

  List<DateTime> getCurrentWeek() {
    int currentWeekday = weekday; // Monday = 1, Sunday = 7
    DateTime startOfWeek = subtract(Duration(days: currentWeekday - 1)); // Adjust to start from Monday

    log('startOfWeek $startOfWeek');
    return List<DateTime>.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  List<DateTime> getDaysInMonth() {
    var daysInMonth = DateTime(year, month + 1, 0).day;
    return List<DateTime>.generate(daysInMonth, (i) => DateTime(year, month, i + 1));
  }

  List<DateTime> getAllMonthsInYear() {
    return List<DateTime>.generate(12, (i) => DateTime(year, i + 1, 1));
  }

  String toTransactionFormatId() {
    final now = DateTime.now();
    String fullUuid = const Uuid().v4();
    String shortUuid = fullUuid.replaceAll('-', '').substring(0, 6);
    final formatted = DateFormat('yyyyMMddHHmmss').format(now);
    String transactionId = '$formatted-$shortUuid';

    return transactionId;
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

  List<DateTime> whereDayActived() {
    return where((day) => day.isDayActived()).toList();
  }
}
