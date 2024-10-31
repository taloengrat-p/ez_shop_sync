import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';

enum PeriodType {
  week,
  month,
  year,
  undefined;

  String get getLabel {
    switch (this) {
      case week:
        return LocaleKeys.thisWeekIncoming.tr();
      case month:
        return LocaleKeys.thisMonthIncoming.tr();
      case year:
        return LocaleKeys.thisYearIncoming.tr();

      default:
        return 'undefined';
    }
  }

  String get label {
    switch (this) {
      case week:
        return LocaleKeys.week.tr();
      case month:
        return LocaleKeys.month.tr();
      case year:
        return LocaleKeys.year.tr();
      default:
        return 'undefined';
    }
  }

  factory PeriodType.fromString(String value) {
    switch (value) {
      case 'week':
        return week;
      case 'month':
        return month;
      case 'year':
        return year;
      default:
        return undefined;
    }
  }
}
