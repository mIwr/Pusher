
import 'package:flutter/material.dart';
import 'package:pusher/global_variables.dart';
import 'package:pusher/status_bar_observer.dart';
import 'package:pusher/system_nav_bar_observer.dart';
import 'package:pusher/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pusher/ui/theme/app_day_theme.dart';
import 'package:pusher/ui/theme/app_night_theme.dart';

class PusherApp extends StatefulWidget {

  final Widget? startScreen;
  final String initialRouteName;

  PusherApp({this.startScreen, required this.initialRouteName});

  @override
  _PusherAppState createState() => _PusherAppState();
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
    final statusBarObs = StatusBarObserver();
    final navBarObs = SystemNavBarObserver();

    return StreamBuilder<Locale>(stream: localeController.onLocaleChange, initialData: localeController.locale, builder: (context, snapshot) {
      final val = snapshot.data ?? localeController.locale;

      return FutureBuilder(future: S.load(val), builder: (context, loadSnapshot) {
        return StreamBuilder<ThemeMode>(stream: themeController.onThemeModeChange, initialData: themeController.mode, builder: (context, themeSnapshot) {
          final mode = themeSnapshot.data ?? themeController.mode;

          return MaterialApp(localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ], navigatorObservers: [
            statusBarObs,
            navBarObs
          ], supportedLocales: S.delegate.supportedLocales,
            title: "Pusher", home: widget.initialRouteName.isNotEmpty ? null : widget.startScreen,
            initialRoute: widget.initialRouteName,
            themeMode: mode, theme: AppDayTheme.themeData, darkTheme: AppNightTheme.themeData,
            debugShowCheckedModeBanner: false, showSemanticsDebugger: false,
          );
        });
      });
    });
  }
}