
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pusher/status_bar_observer.dart';
import 'package:pusher/system_nav_bar_observer.dart';
import 'package:pusher/ui/screen/tab/push_gms_ctrl_screen.dart';
import 'package:pusher/ui/screen/tab/push_hms_ctrl_screen.dart';
import 'package:pusher/util/status_bar_util.dart';
import 'package:pusher_fl_core/pusher_fl_core.dart';
import 'package:pusher_fl_core/pusher_fl_core_ui.dart';

class TabBarScaffold extends StatefulWidget {

  const TabBarScaffold({super.key});

  @override
  State createState() => _TabBarScaffoldState();
}

class _TabBarScaffoldState extends State<TabBarScaffold> {

  final List<CupertinoTabView> _tabs = [];
  final List<GlobalKey<NavigatorState>> _navigationKeys = [];
  final List<Color> _statusBarTabsColors = List.from([
    Colors.black,
    Colors.black
  ], growable: false);

  final _bottomTabBarKey = GlobalKey();//Software tab bar item tap support

  var _selectedTabIndex = 0;

  _TabBarScaffoldState() {
    _navigationKeys.addAll([
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
    ]);
  }

  CupertinoTabView _buildTab(BuildContext context, {required GlobalKey<NavigatorState> navKey, required String routeName, required StatefulWidget payload}) {
    return CupertinoTabView(navigatorKey: navKey, routes: {
      routeName: (context) => payload
    },  navigatorObservers: [
      StatusBarObserver(),
      SystemNavBarObserver()
    ], onUnknownRoute: (route) {
      //custom route name on tab hack
      return MaterialPageRoute(settings: RouteSettings(name: routeName), builder: (context) => payload);
    },);
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs.isEmpty) {
      _tabs.addAll([
        _buildTab(context, navKey: _navigationKeys[0], routeName: kPushGmsCtrlTabRouteKey, payload: const PushGmsCtrlScreen()),
        _buildTab(context, navKey: _navigationKeys[1], routeName: kPushHmsCtrlTabRouteKey, payload: const PushHmsCtrlScreen()),
      ]);
    }

    final bottomBar = CuperBottomTabBar(key: _bottomTabBarKey, tabBarItems: [
      CuperTabBarItem(title: "GMS", onSvgIcon: RAssets.icGoogle, offSvgIcon: RAssets.icGoogle).buildItem(context),
      CuperTabBarItem(title: "HMS", onSvgIcon: RAssets.icHuawei, offSvgIcon: RAssets.icHuawei).buildItem(context),
    ],
      onTap: (newIndex) {
      final navKey = _navigationKeys[newIndex];
      if (newIndex == _selectedTabIndex && navKey.currentState?.canPop() == true) {
        navKey.currentState?.popUntilCan();
        return;
      }
      _statusBarTabsColors[_selectedTabIndex] = StatusBarUtil.bgColor;
      _selectedTabIndex = newIndex;
      StatusBarUtil.transformByBg(bgColor: _statusBarTabsColors[_selectedTabIndex]);
    },);

    return CupertinoPageScaffold(resizeToAvoidBottomInset: false, child: CupertinoTabScaffold(
      tabBar: bottomBar.buildBar(context), tabBuilder: (context, index) {
        return PopScope(canPop: false, onPopInvoked: (didPop) {
          if (!didPop) {
            return;
          }
          final state = _navigationKeys[_selectedTabIndex].currentState;
          if (state?.canPop() == false) {
            return;
          }
          state?.pop();
        }, child: _tabs[index]);
    }));
  }
}