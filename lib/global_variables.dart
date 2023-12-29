
import 'controller/locale_controller.dart';
import 'controller/push_gms_controller.dart';
import 'controller/push_hms_controller.dart';
import 'controller/theme_controller.dart';
import 'model/app_properties.dart';

///App theme mode controller
final themeController = ThemeController();
///App locale controller
final localeController = LocaleController();
///Application properties
var appProperties = AppProperties();
///GMS push controller
final gmsController = PushGmsController();
///HMS push controller
final hmsController = PushHmsController();