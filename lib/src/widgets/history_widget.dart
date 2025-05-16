import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryWidget extends StatelessWidget {
  final Widget leading;
  final Widget? trailing;
  final String title;
  final DateTime? dateTime;
  final String? desc;
  final EdgeInsets? padding;
  const HistoryWidget({
    super.key,
    required this.title,
    required this.leading,
    this.trailing,
    required this.dateTime,
    this.desc,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(width: 8),
          Expanded(child: buildInfo(context)),
          const SizedBox(width: 8),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }

  Widget buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (desc != null) Text(desc ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(CupertinoIcons.time_solid, color: Colors.grey, size: 18),
            const SizedBox(width: 8),
            Flexible(child: Text(dateTime?.toDisplayConditionTimeAgoDisplay(context) ?? '--')),
          ],
        ),
      ],
    );
  }
}
