import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_router.dart';
import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_state.dart';
import 'package:flutter/material.dart';

abstract class BaseRouter {
  String name;
  BuildContext context;
  BaseRouter(this.context, {required this.name});

  Future<T?> navigate<T extends Object?>({Object? argruments, bool isVerifyPin = false}) async {
    if (isVerifyPin) {
      final result = PinVerifyRouter(context).navigate();
      if (result is PinVerifySuccess) {
        await Future.delayed(Duration.zero, () async {
          return await Navigator.of(context).pushNamed<T>(name, arguments: argruments);
        });
      } else {
        return null;
      }
      return null;
    } else {
      return await Navigator.of(context).pushNamed<T>(name, arguments: argruments);
    }
  }

  Future<dynamic> replace({Object? argruments}) async {
    Navigator.of(context).pushReplacementNamed(name, arguments: argruments);
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.pop(context, result);
  }

  Future<dynamic> pushNamedAndRemoveUntil({Object? argruments}) async {
    return await Navigator.of(context).pushNamedAndRemoveUntil(name, arguments: argruments, (route) => false);
  }

  void popUntil(int count) {
    var n = 0;
    Navigator.of(context).popUntil((route) {
      return n++ >= count;
    });
  }

  void popUntilThisScreen() {
    Navigator.popUntil(context, ModalRoute.withName(name));
  }
}
