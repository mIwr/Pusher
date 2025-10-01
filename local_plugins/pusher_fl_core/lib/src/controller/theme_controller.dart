
import 'dart:async';

import 'package:flutter/material.dart';

///Theme manage controller
class ThemeController {

  ///Theme mode
  var _mode = ThemeMode.system;
  ///Theme mode
  ThemeMode get mode => _mode;
  ///Theme mode
  set mode(ThemeMode newVal) {
    if (_mode == newVal) {
      return;
    }
    _mode = newVal;
    _themeModeEventsController.add(_mode);
  }

  ///Theme mode update events stream controller
  final StreamController<ThemeMode> _themeModeEventsController = StreamController.broadcast();
  ///Theme mode update events stream
  Stream<ThemeMode> get onThemeModeChange => _themeModeEventsController.stream;

  ThemeController({ThemeMode initMode = ThemeMode.system}) {
    _mode = initMode;
  }
}