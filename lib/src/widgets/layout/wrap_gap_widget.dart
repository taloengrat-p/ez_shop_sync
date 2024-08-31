import 'package:flutter/cupertino.dart';

class WrapGapWidget extends StatelessWidget {
  final List<Widget> children;
  const WrapGapWidget({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: children,
    );
  }
}
