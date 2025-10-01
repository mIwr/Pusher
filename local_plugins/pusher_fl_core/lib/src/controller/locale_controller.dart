
import 'dart:async';
import 'dart:ui';

///Locale manage controller
class LocaleController {

  ///Selected locale
  var _locale = const Locale("en");
  ///Selected locale
  Locale get locale => _locale;
  ///Selected locale
  set locale(Locale newVal) {
    if (_locale == newVal) {
      return;
    }
    _locale = newVal;
    _localeEventsController.add(_locale);
  }

  ///Locale update events stream controller
  final StreamController<Locale> _localeEventsController = StreamController.broadcast();
  ///Locale update events stream
  Stream<Locale> get onLocaleChange => _localeEventsController.stream;

  LocaleController({Locale initLocale = const Locale("en")}) {
    _locale = initLocale;
  }
}