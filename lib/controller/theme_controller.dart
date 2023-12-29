
import 'dart:async';

import 'package:flutter/material.dart';

class ThemeController {

  var _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  set mode(ThemeMode newVal) {
    if (_mode == newVal) {
      return;
    }
    _mode = newVal;
    _themeModeEventsController.add(_mode);
  }

  StreamController<ThemeMode> _themeModeEventsController = StreamController.broadcast();
  Stream<ThemeMode> get onThemeModeChange => _themeModeEventsController.stream;

  ThemeController({ThemeMode initMode = ThemeMode.system}) {
    _mode = initMode;
  }
}