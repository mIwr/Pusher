
import 'package:flutter/widgets.dart';

enum Screens {
  pushGmsCtrlTab, pushHmsCtrlTab, projCtor, msgCtor,
  notePicker,
}

const kHomeRouteKey = "/push";
const kPushGmsCtrlTabRouteKey = "/push/gms";
const kPushHmsCtrlTabRouteKey = "/push/hms";
const kProjCtorRouteKey = "push/proj";
const kMsgCtorRouteKey = "push/proj/msg";

const kNotePickerRouteKey = "./pick/text";

extension ScreensExt on Screens {

  static Screens? from(String routeName) {
    switch (routeName) {
      case kPushGmsCtrlTabRouteKey: return Screens.pushGmsCtrlTab;
      case kPushHmsCtrlTabRouteKey: return Screens.pushHmsCtrlTab;
      case kProjCtorRouteKey: return Screens.projCtor;
      case kMsgCtorRouteKey: return Screens.msgCtor;
      case kNotePickerRouteKey: return Screens.notePicker;
    }

    return null;
  }

  RouteSettings routeSettings ({Object? arguments}) => RouteSettings(name: routeName, arguments: arguments);

  String get routeName {
    switch (this) {
      case Screens.pushGmsCtrlTab: return kPushGmsCtrlTabRouteKey;
      case Screens.pushHmsCtrlTab: return kPushHmsCtrlTabRouteKey;
      case Screens.projCtor: return kProjCtorRouteKey;
      case Screens.msgCtor: return kMsgCtorRouteKey;
      case Screens.notePicker: return kNotePickerRouteKey;
    }
  }

  String get className {
    switch (this) {
      case Screens.pushGmsCtrlTab: return "PushGmsCtrlScreen";
      case Screens.pushHmsCtrlTab: return "PushHmsCtrlScreen";
      case Screens.projCtor: return "ProjCtorScreen";
      case Screens.msgCtor: return "ProjMsgCtorScreen";
      case Screens.notePicker: return "NotePickerScreen";
    }
  }
}