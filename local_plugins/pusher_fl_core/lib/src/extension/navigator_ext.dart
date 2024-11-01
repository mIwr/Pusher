
import 'package:flutter/widgets.dart';

extension NavigatorExt on Navigator {
  ///Pop screens until root
  static void popUntilCan(BuildContext context) {
    Navigator.popUntil(context, (route) => Navigator.canPop(context) == false);
  }
}

extension NavigatorStateExt on NavigatorState {
  ///Pop screens until root
  void popUntilCan() {
    popUntil((route) => canPop() == false);
  }
}