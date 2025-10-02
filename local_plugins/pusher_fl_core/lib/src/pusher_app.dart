
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'global_variables.dart';
import 'generated/l10n.dart';
import 'screens_enum.dart';
import 'ui/theme/app_day_theme.dart';
import 'ui/theme/app_night_theme.dart';

class PusherApp extends StatefulWidget {

  final Widget Function(BuildContext context) homeRouteScreenGenerator;

  final Widget? startScreen;
  final String initialRouteName;
  final List<NavigatorObserver>? navigatorObservers;

  const PusherApp({super.key, this.startScreen, required this.initialRouteName, required this.homeRouteScreenGenerator, this.navigatorObservers});

  @override
  State createState() => _PusherAppState();
}

class _PusherAppState extends State<PusherApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<NavigatorObserver> navObservers = [
      _FocusCleanerWorkaroundObserver()
    ];
    final widgetNavObservers = widget.navigatorObservers;
    if (widgetNavObservers != null && widgetNavObservers.isNotEmpty) {
      navObservers.addAll(widgetNavObservers);
    }
    final Map<String, Widget Function(BuildContext context)> routes = {
      kHomeRouteKey: widget.homeRouteScreenGenerator,
    };

    return StreamBuilder<Locale>(stream: localeController.onLocaleChange, initialData: localeController.locale, builder: (context, snapshot) {
      final val = snapshot.data ?? localeController.locale;

      return FutureBuilder(future: FlCoreLocalizations.load(val), builder: (context, loadSnapshot) {
        return StreamBuilder<ThemeMode>(stream: themeController.onThemeModeChange, initialData: themeController.mode, builder: (context, themeSnapshot) {
          final mode = themeSnapshot.data ?? themeController.mode;

          return MaterialApp(localizationsDelegates: const [
            FlCoreLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ], navigatorObservers: navObservers, supportedLocales: FlCoreLocalizations.delegate.supportedLocales,
            title: "Pusher", home: widget.initialRouteName.isNotEmpty ? null : widget.startScreen,
            initialRoute: widget.initialRouteName, routes: routes,
            themeMode: mode, theme: AppDayTheme.themeData, darkTheme: AppNightTheme.themeData,
            debugShowCheckedModeBanner: false, showSemanticsDebugger: false,
          );
        });
      });
    });
  }
}

class _FocusCleanerWorkaroundObserver extends NavigatorObserver {

  //Unfocus after navigator.pop - Flutter issue workaround https://github.com/flutter/flutter/issues/145155
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await Future.delayed(Duration.zero);
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

}