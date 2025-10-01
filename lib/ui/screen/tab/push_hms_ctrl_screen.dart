
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pusher/ui/screen/hms/hms_push_proj_ctor_screen.dart';
import 'package:pusher_core/pusher_core.dart';
import 'package:pusher_core/pusher_core_model.dart';
import 'package:pusher_fl_core/pusher_fl_core.dart';
import 'package:pusher_fl_core/pusher_fl_core_ui.dart';

class PushHmsCtrlScreen extends StatefulWidget {

  const PushHmsCtrlScreen({super.key});

  @override
  State createState() => _PushHmsCtrlScreen();
}

class _PushHmsCtrlScreen extends State<PushHmsCtrlScreen> {

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

  @override
  void initState() {
    super.initState();
    final selectedProj = hmsController.activeProj;
    if (selectedProj != null) {
      _selectedProjIdNotifier.value = selectedProj.id;
    }
    _projectsUpdListener = hmsController.onProjectsCollectionUpdate.listen(_onProjectsUpd);
    _selectedProjUpdListener = hmsController.onSelectedProjectUpdate.listen(_onSelectedProjUpd);
    _targetsUpdListener = hmsController.onTargetsCollectionUpdate.listen(_onProjTargetsUpd);
  }

  @override
  void dispose() {
    _projectsUpdListener?.cancel();
    _selectedProjUpdListener?.cancel();
    _targetsUpdListener?.cancel();
    super.dispose();
  }

  void _onProjectsUpd(HashMap<int, HmsProjectConfig> upd) {
    SecureStorageUtil.setHmsProjects(upd.values.toList(growable: false));
    if (!context.mounted) {
      return;
    }
    setState(() {});
  }

  void _onSelectedProjUpd(HmsProjectConfig? upd) {
    _selectedProjIdNotifier.value = upd?.id;
  }

  void _onProjTargetsUpd(HashMap<int, HashMap<String, PushTargetType>> upd) {
    final List<MapEntry<String, String>> tokens = [];
    final List<MapEntry<String, String>> topics = [];
    for (final entry in upd.entries) {
      for (final targetEntry in entry.value.entries) {
        if (targetEntry.value == PushTargetType.token) {
          tokens.add(MapEntry(targetEntry.key, entry.key.toString()));
          continue;
        }
        topics.add(MapEntry(targetEntry.key, entry.key.toString()));
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final currTheme = Theme.of(context);
    final currColorScheme = currTheme.colorScheme;
    final primaryTextTheme = currTheme.primaryTextTheme;
    final genTextTheme = currTheme.textTheme;

    return Scaffold(body: SafeArea(child: GestureDetector(onTap: () {
      FocusScope.of(context).unfocus();
    }, child: Stack(children: [
      SingleChildScrollView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(0, 16, 0, 8), child: Text(FlCoreLocalizations.current.push_ctrl_panel_hms_project, style: primaryTextTheme.displaySmall)),
        Stack(alignment: Alignment.centerLeft, children: [
          DropdownButtonHideUnderline(child: Padding(padding: const EdgeInsets.only(right: 144), child: DropdownButton2<int>(value: hmsController.activeProj?.id,
              buttonStyleData: ButtonStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12))),
              customButton: Container(height: kAppBtnHeight, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: currColorScheme.secondaryContainer, borderRadius: BorderRadius.circular(12)), child: Stack(alignment: Alignment.centerLeft, children: [
                Padding(padding: const EdgeInsets.only(right: 32), child: ValueListenableBuilder<int?>(valueListenable: _selectedProjIdNotifier, builder: (context, val, child) {
                  return Text(val?.toString() ?? FlCoreLocalizations.current.push_ctrl_panel_hms_project, style: genTextTheme.bodyLarge);
                },)),
                Align(alignment: Alignment.centerRight, child: SizedBox(width: 16, height: 16, child: SvgPicture.asset(RAssets.icChevronDown,
                    height: 16, width: 16, colorFilter: ColorFilter.mode(currColorScheme.primary, BlendMode.srcIn))))
              ])),
              isExpanded: true, dropdownStyleData: DropdownStyleData(maxHeight: 200, decoration: BoxDecoration(color: currColorScheme.primaryContainer, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)))),
              items: hmsController.projects.keys.map((item) => DropdownMenuItem(value: item, child: Text(item.toString(), style: primaryTextTheme.labelLarge))).toList(growable: false), onChanged: (selected) {
                if (selected == null) {
                  hmsController.deselectProj();
                  return;
                }
                hmsController.selectProj(id: selected);
              }))),
          Align(alignment: Alignment.centerRight, child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(width: 40, height: 40,
                child: TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                    shape: const CircleBorder(), padding: const EdgeInsets.all(4)), onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(settings: Screens.projCtor.routeSettings(), builder: (context) => const HmsPushProjectCtorScreen()));
                }, child: SvgPicture.asset(RAssets.icPlus, width: 20, height: 20,
                    colorFilter: ColorFilter.mode(currColorScheme.secondary, BlendMode.srcIn)))
            ),
            const Padding(padding: EdgeInsets.only(left: 8)),
            SizedBox(width: 40, height: 40,
              child: ValueListenableBuilder<int?>(valueListenable: _selectedProjIdNotifier, builder: (context, val, child) {
                return TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                    shape: const CircleBorder(), padding: const EdgeInsets.all(4)), onPressed: val == null ? null : () {
                  Navigator.of(context).push(MaterialPageRoute(settings: Screens.projCtor.routeSettings(), builder: (context) => HmsPushProjectCtorScreen(initConfig: hmsController.projects[val])));
                }, child: SvgPicture.asset(RAssets.icEdit, width: 20, height: 20,
                  colorFilter: ColorFilter.mode(val == null ? currColorScheme.surface : currColorScheme.secondary, BlendMode.srcIn),));
              },),
            ),
            const Padding(padding: EdgeInsets.only(left: 8)),
            SizedBox(width: 40, height: 40,
              child: ValueListenableBuilder<int?>(valueListenable: _selectedProjIdNotifier, builder: (context, val, child) {
                return TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                    shape: const CircleBorder(), padding: const EdgeInsets.all(4)), onPressed: val == null ? null : () {
                  hmsController.removeProj(projId: val);
                  AppSnackBar.showSimpleTextSnack(context, text: val.toString() + " - " + FlCoreLocalizations.current.general_deleted);
                }, child: SvgPicture.asset(RAssets.icTrash, width: 20, height: 20,
                    colorFilter: ColorFilter.mode(val == null ? currColorScheme.surface : currColorScheme.secondary, BlendMode.srcIn)));
              },),
            )
          ],),)
        ],),
        const Padding(padding: EdgeInsets.only(top: 16)),
        ValueListenableBuilder<PushTargetType>(valueListenable: _targetTypeNotifier, builder: (context, val, child) {
          return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            RadioButton<PushTargetType>(semanticLabel: PushTargetType.token.generateLocalizedName(intl: FlCoreLocalizations.current), value: PushTargetType.token, groupValue: val,
                title: Text(PushTargetType.token.generateLocalizedName(intl: FlCoreLocalizations.current), style: primaryTextTheme.bodyMedium), onChanged: (newVal) {
                  if (newVal == null || val == newVal) {
                    return;
                  }
                  _targetTypeNotifier.value = newVal;
                }),
            const Padding(padding: EdgeInsets.only(top: 4)),
            RadioButton<PushTargetType>(semanticLabel: PushTargetType.topic.generateLocalizedName(intl: FlCoreLocalizations.current), value: PushTargetType.topic, groupValue: val,
                title: Text(PushTargetType.topic.generateLocalizedName(intl: FlCoreLocalizations.current), style: primaryTextTheme.bodyMedium), onChanged: (newVal) {
                  if (newVal == null || val == newVal) {
                    return;
                  }
                  _targetTypeNotifier.value = newVal;
                })
          ]);
        },),
        const Padding(padding: EdgeInsets.only(top: 8)),
        Stack(alignment: Alignment.centerLeft, children: [
          Padding(padding: const EdgeInsets.only(right: 48), child: ValueListenableBuilder<PushTargetType>(valueListenable: _targetTypeNotifier, builder: (context, val, child) {
            return AppTextField(hintText: val.generateLocalizedName(intl: FlCoreLocalizations.current), controller: _targetTextController, autofocus: false, autocorrect: false, maxLines: 3, enableSuggestions: false);
          },
          )),
          Align(alignment: Alignment.centerRight, child: SizedBox(width: 40, height: 40,
              child: TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                  shape: const CircleBorder(), padding: const EdgeInsets.all(4)), onPressed: () {
                final List<String> targets = [];
                final id = hmsController.activeProj?.id;
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

                Navigator.of(context).push(MaterialPageRoute(settings: Screens.notePicker.routeSettings(), builder: (context) => NotePickerScreen(title: FlCoreLocalizations.current.push_target_history, items: targets, onPick: (selected) {
                  _targetTextController.text = selected;
                })));
              }, child: SvgPicture.asset(RAssets.icHistory, width: 20, height: 20, colorFilter: ColorFilter.mode(currColorScheme.secondary, BlendMode.srcIn))
              )
          ))
        ]),
        Padding(padding: const EdgeInsets.fromLTRB(0, 16, 0, 8), child: Text(FlCoreLocalizations.current.push_ctrl_panel_msg_payload, style: primaryTextTheme.displaySmall)),
        AppTextField(controller: _pushPayloadTextController, autofocus: false, autocorrect: false, maxLines: 8, hintText: "JSON", enableSuggestions: false),
        const Padding(padding: EdgeInsets.only(top: 8)),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ValueListenableBuilder<bool>(valueListenable: _validateOnlyPushNotifier, builder: (context, val, child) {
            return Checkbox(value: val, onChanged: (newVal) {
              if (newVal == null) {
                return;
              }
              _validateOnlyPushNotifier.value = newVal;
            });
          }),
          const Padding(padding: EdgeInsets.only(left: 4)),
          Flexible(child: GestureDetector(onTap: () {
            _validateOnlyPushNotifier.value = !_validateOnlyPushNotifier.value;
          }, child:  Text(FlCoreLocalizations.current.push_ctrl_panel_hms_validate_only_hint, style: primaryTextTheme.bodyMedium)))
        ]),
        const Padding(padding: EdgeInsets.only(top: 16)),
        Text(FlCoreLocalizations.current.push_ctrl_panel_send_log_hint, style: primaryTextTheme.displaySmall),
        const Padding(padding: EdgeInsets.only(top: 8)),
        AppTextField(autofocus: false, autocorrect: false, enableSuggestions: false, readonly: true, maxLines: 8, controller: _logTextController),
        const Padding(padding: EdgeInsets.only(top: kAppBtnHeight + 12))
      ])),
      Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: SizedBox(width: MediaQuery.of(context).size.width,
          child: TextButtonAccent(content: FlCoreLocalizations.current.general_send, onPressed: () async {
            if (_processingNotifier.value) {
              return;
            }
            final proj = hmsController.activeProj;
            if (proj == null) {
              AppSnackBar.showSimpleTextSnack(context, text: FlCoreLocalizations.current.push_ctrl_panel_project_not_selected_err);
              return;
            }
            final targetVal = _targetTextController.text;
            if (targetVal.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: FlCoreLocalizations.current.push_ctrl_panel_msg_target_not_stated_err);
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
                AppSnackBar.showSimpleTextSnack(context, text: FlCoreLocalizations.current.push_ctrl_panel_msg_payload_parse_err);
                return;
              }
              _processingNotifier.value = true;
              final res = await hmsController.sendPush(target: targetVal, targetType: _targetTypeNotifier.value, project: proj, validateOnly: _validateOnlyPushNotifier.value, data: push.data ?? "", notification: push.notification, android: push.android, apns: push.apns);
              _processingNotifier.value = false;
              var msg = DateTime.now().toIso8601String() + " -> ";
              final hmsResponse = res.result;
              if (hmsResponse != null) {
                final apiCode = hmsResponse.parsedCode;
                if (apiCode == HMSResponseCode.ok || apiCode == HMSResponseCode.partialOk) {
                  msg += "Sent - " + hmsResponse.msg + " (ReqID " + hmsResponse.requestID + ")\n";
                } else {
                  msg += "Send fail (ReqID " + hmsResponse.requestID + "): " + hmsResponse.msg + " [" + hmsResponse.code.toString() + "]\n";
                }
              } else {
                msg += res.error?.statusMsg ?? "NULL response";
              }
              _logTextController.text += msg + '\n';
            } catch(error) {
              print(error);
              if (_processingNotifier.value) {
                _processingNotifier.value = false;
              }
              if (!context.mounted) {
                return;
              }
              AppSnackBar.showSimpleTextSnack(context, text: FlCoreLocalizations.current.push_ctrl_panel_msg_payload_parse_err);
            }
          },)
      ),))
    ]))));
  }
}