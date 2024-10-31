import 'dart:developer';

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
  String toDisplay({String? format}) {
    String formattedDate = DateFormat(format ?? DateFormatConstance.D_MMM_YYYY_HH_mm).format(this);

    return formattedDate;
  }

  int getWeekOfMonth() {
    // Find the first day of the month
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Calculate the offset for the first day (e.g., Monday = 1, Sunday = 7)
    int firstDayOffset = firstDayOfMonth.weekday;

    // Calculate the week number, assuming each week starts on Monday
    int weekNumber = ((day + firstDayOffset - 2) / 7).floor() + 1;

    return weekNumber;
  }

  Map<String, DateTime> getMondayAndSundayOfWeek(
    int weekOfMonth,
  ) {
    // Get the first day of the month
    DateTime firstDayOfMonth = getFirstDayOfMonth();
    DateTime lastDayOfMonth = getLastDayByMonth();
    bool isFirstWeek = isFirstWeekOfMonth();
    bool isLastWeek = isLastWeekOfMonth();
    log('firstDayOfMonth $firstDayOfMonth, lastDayOfMonth $lastDayOfMonth, isFirstWeek: $isFirstWeek, isLastWeek: $isLastWeek');
    // Calculate the start day of the specified week
    int startDay = (weekOfMonth - 1) * 7 + 1;
    DateTime weekStart = DateTime(year, month, startDay);

    // Find the Monday of that week
    int daysToMonday = (DateTime.monday - weekStart.weekday + 7) % 7;
    DateTime mondayOfWeek = weekStart.add(Duration(days: daysToMonday));

    // Find the Sunday of that week
    DateTime sundayOfWeek = mondayOfWeek.add(Duration(days: 6));

    return {
      "monday": isFirstWeek ? firstDayOfMonth : mondayOfWeek,
      "sunday": isFirstWeek
          ? firstDayOfMonth.add(Duration(days: (DateTime.sunday - weekStart.weekday + 7) % 7))
          : sundayOfWeek,
    };
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

  bool isActived() {
    DateTime today = DateTime.now();
    return isBefore(today) || isAtSameMomentAs(today);
  }

  List<DateTime> getCurrentWeek() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday; // Monday = 1, Sunday = 7
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1)); // Adjust to start from Monday

    return List<DateTime>.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  List<DateTime> getDaysInMonth() {
    var daysInMonth = DateTime(year, month + 1, 0).day;
    return List<DateTime>.generate(daysInMonth, (i) => DateTime(year, month, i + 1));
  }

  List<DateTime> getAllMonthsInYear() {
    return List<DateTime>.generate(12, (i) => DateTime(year, i + 1, 1));
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
    return where((day) => day.isActived()).toList();
  }
}
