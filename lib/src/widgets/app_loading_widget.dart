import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Stack(
          children: [
            Center(child: Lottie.asset('assets/loading.json')),
            Center(child: Image.asset('assets/images/logo.png', height: 100)),
          ],
        ),
      ),
    );
  }
}
