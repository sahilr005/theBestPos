// Dart imports:

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            // height: 100,
            child: Lottie.asset(
              'assets/json/loader.json',
              height: 30,
              width: 30,
            ),
          ),
        ),
      ),
    );
  }
}
