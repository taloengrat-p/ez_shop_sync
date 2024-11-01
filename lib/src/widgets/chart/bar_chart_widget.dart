import 'dart:async';

import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  final Widget? header;
  final PeriodType periodType;
  final Map<DateTime, List<ProductOrder>> days;
  final Color activeColor;
  BarChartWidget({
    super.key,
    this.header,
    required this.periodType,
    required this.days,
    required this.activeColor,
  });

  // List<Color> get availableColors => const <Color>[
  //       Colors.green,
  //       Colors.green,
  //       Colors.green,
  //       Colors.green,
  //       Colors.green,
  //       Colors.green,
  //     ];

  final Color barBackgroundInactive = Colors.grey.withOpacity(0.3);
  Color get barBackgroundColor => activeColor.withOpacity(0.3);
  Color get barColor => activeColor;
  Color get touchedBarColor => activeColor;

  num get maxValue => findMaxTotalPrice(days);

  num findMaxTotalPrice(Map<DateTime, List<ProductOrder>> ordersMap) {
    double maxTotalPrice = 0.0;

    for (var orders in ordersMap.values) {
      // Calculate the sum of total prices for the current date
      double currentTotalPrice = orders.fold(0.0, (sum, order) => sum + order.totalPriceIncludeServiceCharge);

      // Update the max total price if current is greater
      if (currentTotalPrice > maxTotalPrice) {
        maxTotalPrice = currentTotalPrice;
      }
    }

    return maxTotalPrice == 0 ? 1 : maxTotalPrice;
  }

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      refreshState();
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isPlaying = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                widget.header ?? const SizedBox(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      // isPlaying ? randomData() :
                      mainBarData(),
                      swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    required DateTime dateTime,
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 0.5 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide:
              isTouched ? BorderSide(color: widget.touchedBarColor) : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: widget.maxValue.toDouble(),
            color: (widget.periodType == PeriodType.month ? dateTime.isWeekActived() : dateTime.isDayActived())
                ? widget.barBackgroundColor
                : widget.barBackgroundInactive,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    return widget.days.entries
        .toList()
        .asMap()
        .map((index, value) {
          return MapEntry(
            index,
            makeGroupData(
              index,
              width: widget.periodType == PeriodType.year ? 12 : 22,
              value.value.fold(0, (previous, e) => previous + e.totalPriceIncludeServiceCharge),
              // isTouched: index == touchedIndex,
              dateTime: value.key,
            ),
          );
        })
        .values
        .toList();
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            weekDay =
                widget.days.keys.elementAt(rodIndex).toDisplayDependLocale(context, format: DateFormatConstance.EEEE);
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY).toString(),
                  style: const TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: widget.periodType == PeriodType.year ? 10 : 14,
    );
    Widget text;
    switch (widget.periodType) {
      case PeriodType.week:
        return Text(
            widget.days.keys.elementAt(value.toInt()).toDisplayDependLocale(context, format: DateFormatConstance.E),
            style: style);

      case PeriodType.month:
        final element = widget.days.keys.elementAt(value.toInt());
        final startDay = element.getWeekStartAndEndDates(element.year, element.month, element.day - 1);

        return Text('${startDay['start']!.day}-${startDay['end']!.day}');
      case PeriodType.year:
        final element = widget.days.keys.elementAt(value.toInt());

        return Text(
          element.toDisplayDependLocale(context, format: DateFormatConstance.MMM),
          style: style,
        );
      default:
        text = Text('', style: style);
        break;
    }
    return text;
  }

  // BarChartData randomData() {
  //   return BarChartData(
  //     barTouchData: BarTouchData(
  //       enabled: false,
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           getTitlesWidget: getTitles,
  //           reservedSize: 38,
  //         ),
  //       ),
  //       leftTitles: const AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: false,
  //         ),
  //       ),
  //       topTitles: const AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: false,
  //         ),
  //       ),
  //       rightTitles: const AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: false,
  //         ),
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //       show: false,
  //     ),
  //     barGroups: List.generate(8, (i) {
  //       switch (i) {
  //         case 0:
  //           return makeGroupData(
  //             0,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: widget.availableColors[Random().nextInt(widget.availableColors.length)],
  //           );
  //         case 1:
  //           return makeGroupData(
  //             1,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: widget.availableColors[Random().nextInt(widget.availableColors.length)],
  //           );
  //         case 2:
  //           return makeGroupData(
  //             2,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: widget.availableColors[Random().nextInt(widget.availableColors.length)],
  //           );
  //         case 3:
  //           return makeGroupData(
  //             3,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: widget.availableColors[Random().nextInt(widget.availableColors.length)],
  //           );
  //         case 4:
  //           return makeGroupData(
  //             4,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: widget.availableColors[Random().nextInt(widget.availableColors.length)],
  //           );
  //         case 5:
  //           return makeGroupData(
  //             5,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: widget.availableColors[Random().nextInt(widget.availableColors.length)],
  //           );
  //         case 6:
  //           return makeGroupData(
  //             6,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: widget.availableColors[Random().nextInt(widget.availableColors.length)],
  //           );
  //         case 7:
  //           return makeGroupData(
  //             7,
  //             Random().nextInt(15).toDouble() + 6,
  //             barColor: widget.availableColors[Random().nextInt(widget.availableColors.length)],
  //           );
  //         default:
  //           return throw Error();
  //       }
  //     }),
  //     gridData: const FlGridData(show: false),
  //   );
  // }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
