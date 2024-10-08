import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:flutter/material.dart';

class StepWidget extends StatelessWidget {
  final String title;
  final int number;
  final List<Widget>? children;
  const StepWidget({
    super.key,
    required this.number,
    required this.title,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ColorKeys.primary,
                child: Text(
                  number.toString(),
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(
                width: DimensionsKeys.m,
              ),
              Text(title)
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...children ?? [],
              ],
            ),
          )
        ],
      ),
    );
  }
}
