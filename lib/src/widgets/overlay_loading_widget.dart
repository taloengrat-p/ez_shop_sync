import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OverlayLoadingWidget extends StatelessWidget {
  const OverlayLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(0.6),
          child: Center(child: Lottie.asset('assets/loading.json')),
        ),
        Center(child: Image.asset('assets/images/logo.png', height: 100)),
      ],
    );
  }
}
