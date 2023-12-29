
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pusher/controller/model/controller_update_event.dart';
import 'package:pusher/controller/model/controller_update_event_type.dart';
import 'package:pusher/global_constants.dart';
import 'package:pusher/global_variables.dart';
import 'package:pusher/model/hms/hms_project_config.dart';
import 'package:pusher/model/hms/push_hms.dart';
import 'package:pusher/model/push_target_type.dart';
import 'package:pusher/screens_enum.dart';
import 'package:pusher/ui/screen/hms/hms_push_proj_ctor_screen.dart';
import 'package:pusher/ui/screen/note_picker_screen.dart';
import 'package:pusher/ui/view/app_snack_bar.dart';
import 'package:pusher/ui/view/app_text_field.dart';
import 'package:pusher/ui/view/radio_button_widget.dart';
import 'package:pusher/ui/view/text_button_accent.dart';
import 'package:pusher/util/db/push_targets_db_util.dart';
import 'package:pusher/util/secure_storage_util.dart';
import 'package:pusher/generated/l10n.dart';
import 'package:pusher/generated/assets.dart';

class PushHmsCtrlScreen extends StatefulWidget {

  @override
  State createState() => _PushHmsCtrlScreen();
}

class _PushHmsCtrlScreen extends State<PushHmsCtrlScreen> {

  List<int> _projKeys = [];
  final _selectedProjIdNotifier = ValueNotifier<int?>(null);
  final _targetTypeNotifier = ValueNotifier<PushTargetType>(PushTargetType.token);
  final _targetTextController = TextEditingController();

  final _pushPayloadTextController = TextEditingController();
  final _validateOnlyPushNotifier = ValueNotifier<bool>(false);
  final _logTextController = TextEditingController();
  final _processingNotifier = ValueNotifier<bool>(false);

  StreamSubscription? _projectsUpdListener;
  StreamSubscription? _selectedProjUpdListener;
  StreamSubscription? _targetsUpdListener;
  StreamSubscription? _targetUpdListener;

  @override
  void initState() {
    super.initState();
    final selectedProj = hmsController.selected;
    if (selectedProj != null) {
      _selectedProjIdNotifier.value = selectedProj.id;
    }
    _projKeys = hmsController.generateOrderedList().map((e) => e.id).toList();
    _projectsUpdListener = hmsController.onProjectsCollectionUpdate.listen(_onProjectsUpd);
    _selectedProjUpdListener = hmsController.onSelectedProjUpdate.listen(_onSelectedProjUpd);
    _targetsUpdListener = hmsController.onProjectTargetsCollectionUpdate.listen(_onProjTargetsUpd);
    _targetUpdListener = hmsController.onTargetUpdate.listen(_onTargetUpd);
  }

  @override
  void dispose() {
    _projectsUpdListener?.cancel();
    _selectedProjUpdListener?.cancel();
    _targetsUpdListener?.cancel();
    _targetUpdListener?.cancel();
    super.dispose();
  }

  void _onProjectsUpd(HashMap<int, HmsProjectConfig> upd) {
    SecureStorageUtil.setHmsProjects(upd.values.toList(growable: false));
    setState(() {
      _projKeys = hmsController.generateOrderedList().map((e) => e.id).toList();
    });
  }

  void _onSelectedProjUpd(HmsProjectConfig? upd) {
    _selectedProjIdNotifier.value = upd?.id;
  }

  void _onProjTargetsUpd(MapEntry<HmsProjectConfig, HashMap<String, PushTargetType>> upd) {
    final List<MapEntry<String, String>> tokens = [];
    final List<MapEntry<String, String>> topics = [];
    upd.value.forEach((key, value) {
      if (value == PushTargetType.token) {
        tokens.add(MapEntry(key, upd.key.id.toString()));
      } else {
        topics.add(MapEntry(key, upd.key.id.toString()));
      }
    });
    if (tokens.isEmpty) {
      PushTargetsDbUtil.clearDeviceTokens(servicePrefix: PushTargetsDbUtil.kHmsServicePrefix);
    } else {
      PushTargetsDbUtil.insertOrReplaceDeviceTokens(servicePrefix: PushTargetsDbUtil.kHmsServicePrefix, items: tokens);
    }
    if (topics.isEmpty) {
      PushTargetsDbUtil.clearPushTopics(servicePrefix: PushTargetsDbUtil.kHmsServicePrefix);
    } else {
      PushTargetsDbUtil.insertOrReplacePushTopics(servicePrefix: PushTargetsDbUtil.kHmsServicePrefix, items: topics);
    }
  }

  void _onTargetUpd(ControllerUpdateEvent<MapEntry<String, PushTargetType>> upd) {
    if (upd.type == ControllerUpdateEventType.deleted) {
      if (upd.item.value == PushTargetType.token) {
        PushTargetsDbUtil.deleteDeviceTokens(servicePrefix: PushTargetsDbUtil.kHmsServicePrefix, ids: [upd.item.key]);
      } else {
        PushTargetsDbUtil.deletePushTopics(servicePrefix: PushTargetsDbUtil.kHmsServicePrefix, ids: [upd.item.key]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Theme.of(context);
    final currColorScheme = currTheme.colorScheme;
    final primaryTextTheme = currTheme.primaryTextTheme;
    final genTextTheme = currTheme.textTheme;

    return Scaffold(body: SafeArea(child: GestureDetector(onTap: () {
      FocusScope.of(context).unfocus();
    }, child: Stack(children: [
      SingleChildScrollView(physics: BouncingScrollPhysics(), padding: EdgeInsets.symmetric(horizontal: 16), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 8), child: Text(S.current.push_ctrl_panel_hms_project, style: primaryTextTheme.displaySmall)),
        Stack(alignment: Alignment.centerLeft, children: [
          DropdownButtonHideUnderline(child: Padding(padding: EdgeInsets.only(right: 144), child: DropdownButton2<int>(value: hmsController.selected?.id,
              buttonStyleData: ButtonStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12))),
              customButton: Container(height: kAppBtnHeight, padding: EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: currColorScheme.secondaryContainer, borderRadius: BorderRadius.circular(12)), child: Stack(alignment: Alignment.centerLeft, children: [
                Padding(padding: EdgeInsets.only(right: 32), child: ValueListenableBuilder<int?>(valueListenable: _selectedProjIdNotifier, builder: (context, val, child) {
                  return Text(val?.toString() ?? S.current.push_ctrl_panel_hms_project, style: genTextTheme.bodyLarge);
                },)),
                Align(alignment: Alignment.centerRight, child: SizedBox(width: 16, height: 16, child: SvgPicture.asset(R.ASSETS_IC_CHEVRON_DOWN_SVG,
                    height: 16, width: 16, colorFilter: ColorFilter.mode(currColorScheme.primary, BlendMode.srcIn))))
              ])),
              isExpanded: true, dropdownStyleData: DropdownStyleData(maxHeight: 200, decoration: BoxDecoration(color: currColorScheme.primaryContainer, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)))),
              items: _projKeys.map((item) => DropdownMenuItem(value: item, child: Text(item.toString(), style: primaryTextTheme.labelLarge))).toList(growable: false), onChanged: (selected) {
                if (selected == null) {
                  hmsController.deselectProj();
                  return;
                }
                hmsController.selectProj(id: selected);
              }))),
          Align(alignment: Alignment.centerRight, child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(width: 40, height: 40,
                child: TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                    shape: CircleBorder(), padding: EdgeInsets.all(4)), onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(settings: Screens.projCtor.routeSettings(), builder: (context) => HmsPushProjectCtorScreen()));
                }, child: SvgPicture.asset(R.ASSETS_IC_PLUS_SVG, width: 20, height: 20,
                    colorFilter: ColorFilter.mode(currColorScheme.secondary, BlendMode.srcIn)))
            ),
            Padding(padding: EdgeInsets.only(left: 8)),
            SizedBox(width: 40, height: 40,
              child: ValueListenableBuilder<int?>(valueListenable: _selectedProjIdNotifier, builder: (context, val, child) {
                return TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                    shape: CircleBorder(), padding: EdgeInsets.all(4)), onPressed: val == null ? null : () {
                  Navigator.of(context).push(MaterialPageRoute(settings: Screens.projCtor.routeSettings(), builder: (context) => HmsPushProjectCtorScreen(initConfig: hmsController.projects[val])));
                }, child: SvgPicture.asset(R.ASSETS_IC_EDIT_SVG, width: 20, height: 20,
                  colorFilter: ColorFilter.mode(val == null ? currColorScheme.surface : currColorScheme.secondary, BlendMode.srcIn),));
              },),
            ),
            Padding(padding: EdgeInsets.only(left: 8)),
            SizedBox(width: 40, height: 40,
              child: ValueListenableBuilder<int?>(valueListenable: _selectedProjIdNotifier, builder: (context, val, child) {
                return TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                    shape: CircleBorder(), padding: EdgeInsets.all(4)), onPressed: val == null ? null : () {
                  hmsController.removeProj(projId: val);
                  AppSnackBar.showSimpleTextSnack(context, text: val.toString() + " - " + S.current.general_deleted);
                }, child: SvgPicture.asset(R.ASSETS_IC_TRASH_SVG, width: 20, height: 20,
                    colorFilter: ColorFilter.mode(val == null ? currColorScheme.surface : currColorScheme.secondary, BlendMode.srcIn)));
              },),
            )
          ],),)
        ],),
        Padding(padding: EdgeInsets.only(top: 16)),
        ValueListenableBuilder<PushTargetType>(valueListenable: _targetTypeNotifier, builder: (context, val, child) {
          return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            RadioButton<PushTargetType>(semanticLabel: PushTargetType.token.generateLocalizedName(intl: S.current), value: PushTargetType.token, groupValue: val,
                title: Text(PushTargetType.token.generateLocalizedName(intl: S.current), style: primaryTextTheme.bodyMedium), onChanged: (newVal) {
                  if (newVal == null || val == newVal) {
                    return;
                  }
                  _targetTypeNotifier.value = newVal;
                }),
            Padding(padding: EdgeInsets.only(top: 4)),
            RadioButton<PushTargetType>(semanticLabel: PushTargetType.topic.generateLocalizedName(intl: S.current), value: PushTargetType.topic, groupValue: val,
                title: Text(PushTargetType.topic.generateLocalizedName(intl: S.current), style: primaryTextTheme.bodyMedium), onChanged: (newVal) {
                  if (newVal == null || val == newVal) {
                    return;
                  }
                  _targetTypeNotifier.value = newVal;
                })
          ]);
        },),
        Padding(padding: EdgeInsets.only(top: 8)),
        Stack(alignment: Alignment.centerLeft, children: [
          Padding(padding: EdgeInsets.only(right: 48), child: ValueListenableBuilder<PushTargetType>(valueListenable: _targetTypeNotifier, builder: (context, val, child) {
            return AppTextField(hintText: val.generateLocalizedName(intl: S.current), controller: _targetTextController, autofocus: false, autocorrect: false, maxLines: 3, enableSuggestions: false);
          },
          )),
          Align(alignment: Alignment.centerRight, child: SizedBox(width: 40, height: 40,
              child: TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                  shape: CircleBorder(), padding: EdgeInsets.all(4)), onPressed: () {
                final List<String> targets = [];
                final id = hmsController.selected?.id;
                if (id != null) {
                  switch(_targetTypeNotifier.value) {
                    case PushTargetType.token:
                      targets.addAll(hmsController.getProjectTargets(id, targetType: PushTargetType.token).map((e) => e.key));
                      break;
                    case PushTargetType.topic:
                      targets.addAll(hmsController.getProjectTargets(id, targetType: PushTargetType.topic).map((e) => e.key));
                      break;
                  }
                }

                Navigator.of(context).push(MaterialPageRoute(settings: Screens.notePicker.routeSettings(), builder: (context) => NotePickerScreen(title: S.current.push_target_history, items: targets, onPick: (selected) {
                  _targetTextController.text = selected;
                })));
              }, child: SvgPicture.asset(R.ASSETS_IC_HISTORY_SVG, width: 20, height: 20, colorFilter: ColorFilter.mode(currColorScheme.secondary, BlendMode.srcIn))
              )
          ))
        ]),
        Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 8), child: Text(S.current.push_ctrl_panel_msg_payload, style: primaryTextTheme.displaySmall)),
        AppTextField(controller: _pushPayloadTextController, autofocus: false, autocorrect: false, maxLines: 8, hintText: "JSON", enableSuggestions: false),
        Padding(padding: EdgeInsets.only(top: 8)),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ValueListenableBuilder<bool>(valueListenable: _validateOnlyPushNotifier, builder: (context, val, child) {
            return Checkbox(value: val, onChanged: (newVal) {
              if (newVal == null) {
                return;
              }
              _validateOnlyPushNotifier.value = newVal;
            });
          }),
          Padding(padding: EdgeInsets.only(left: 4)),
          Flexible(child: GestureDetector(onTap: () {
            _validateOnlyPushNotifier.value = !_validateOnlyPushNotifier.value;
          }, child:  Text(S.current.push_ctrl_panel_hms_validate_only_hint, style: primaryTextTheme.bodyMedium)))
        ]),
        Padding(padding: EdgeInsets.only(top: 16)),
        Text(S.current.push_ctrl_panel_send_log_hint, style: primaryTextTheme.displaySmall),
        Padding(padding: EdgeInsets.only(top: 8)),
        AppTextField(autofocus: false, autocorrect: false, enableSuggestions: false, readonly: true, maxLines: 8, controller: _logTextController),
        Padding(padding: EdgeInsets.only(top: kAppBtnHeight + 12))
      ])),
      Align(alignment: Alignment.bottomCenter, child: Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 12), child: SizedBox(width: MediaQuery.of(context).size.width,
          child: TextButtonAccent(content: S.current.general_send, onPressed: () async {
            if (_processingNotifier.value) {
              return;
            }
            final proj = hmsController.selected;
            if (proj == null) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.push_ctrl_panel_project_not_selected_err);
              return;
            }
            final targetVal = _targetTextController.text;
            if (targetVal.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.push_ctrl_panel_msg_target_not_stated_err);
              return;
            }
            try {
              var text = _pushPayloadTextController.text;
              if (!text.startsWith('{')) {
                text = '{' + text;
              }
              if (!text.endsWith('}')) {
                text += '}';
              }
              final Map<String, dynamic> pushMap = json.decode(text);
              final push = PushHms.from(pushMap);
              if (push == null) {
                AppSnackBar.showSimpleTextSnack(context, text: S.current.push_ctrl_panel_msg_payload_parse_err);
                return;
              }
              _processingNotifier.value = true;
              final res = await hmsController.sendPush(target: targetVal, targetType: _targetTypeNotifier.value, project: proj, validateOnly: _validateOnlyPushNotifier.value, data: push.data ?? "", notification: push.notification, android: push.android, apns: push.apns);
              _processingNotifier.value = false;
              var msg = DateTime.now().toIso8601String() + " -> ";
              final msgId = res.result;
              if (msgId != null) {
                msg += "Sent - " + msgId + '\n';
              } else {
                final err = res.error;
                msg += "Send fail";
                if (err != null) {
                  msg += " - " + err.statusMsg + " (" + err.statusCode.toString() + ')';
                }
              }
              _logTextController.text += msg + '\n';
            } catch(error) {
              print(error);
              AppSnackBar.showSimpleTextSnack(context, text: S.current.push_ctrl_panel_msg_payload_parse_err);
              if (_processingNotifier.value) {
                _processingNotifier.value = false;
              }
              return;
            }
          },)
      ),))
    ]))));
  }
}