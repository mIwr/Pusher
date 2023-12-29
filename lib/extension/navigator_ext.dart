
import 'package:flutter/widgets.dart';

extension NavigatorExt on Navigator {
  static void popUntilCan(BuildContext context) {
    Navigator.popUntil(context, (route) => Navigator.canPop(context) == false);
  }
}

extension NavigatorStateExt on NavigatorState {
  void popUntilCan() {
    popUntil((route) => canPop() == false);
  }
}