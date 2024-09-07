import 'package:flutter/cupertino.dart';

class WrapGapWidget extends StatelessWidget {
  final List<Widget> children;
  const WrapGapWidget({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: children,
    );
  }
}
