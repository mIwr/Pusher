
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pusher_core/pusher_core.dart';
import 'package:pusher_core/pusher_core_model.dart';

import '../../../generated/assets.gen.dart';
import '../../../generated/l10n.dart';
import '../../../global_constants.dart';
import '../../../model/push_target_type_ext_locale.dart';
import '../../../screens_enum.dart';
import '../../../util/secure_storage_util.dart';
import '../../view/app_snack_bar.dart';
import '../../view/app_text_field.dart';
import '../../view/radio_button_widget.dart';
import '../../view/text_button_accent.dart';
import '../gms/gms_push_proj_ctor_screen.dart';
import '../note_picker_screen.dart';

class PushGmsCtrlScreen extends StatefulWidget {

  const PushGmsCtrlScreen({super.key});

  @override
  State createState() => _PushGmsCtrlScreen();
}

class _PushGmsCtrlScreen extends State<PushGmsCtrlScreen> {

  final _selectedProjIdNotifier = ValueNotifier<String?>(null);
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
    final selectedProj = gmsController.activeProj;
    if (selectedProj != null) {
      _selectedProjIdNotifier.value = selectedProj.id;
    }
    _projectsUpdListener = gmsController.onProjectsCollectionUpdate.listen(_onProjectsUpd);
    _selectedProjUpdListener = gmsController.onSelectedProjectUpdate.listen(_onSelectedProjUpd);
    _targetsUpdListener = gmsController.onTargetsCollectionUpdate.listen(_onProjTargetsUpd);
  }

  @override
  void dispose() {
    _projectsUpdListener?.cancel();
    _selectedProjUpdListener?.cancel();
    _targetsUpdListener?.cancel();
    super.dispose();
  }

  void _onProjectsUpd(HashMap<String, GmsProjectConfig> upd) {
    SecureStorageUtil.setGmsProjects(upd.values.toList(growable: false));
    if (!context.mounted) {
      return;
    }
    setState(() {});
  }

  void _onSelectedProjUpd(GmsProjectConfig? upd) {
    _selectedProjIdNotifier.value = upd?.id;
  }
  
  void _onProjTargetsUpd(HashMap<String, HashMap<String, PushTargetType>> upd) {
    final List<MapEntry<String, String>> tokens = [];
    final List<MapEntry<String, String>> topics = [];
    for (final entry in upd.entries) {
      for (final targetEntry in entry.value.entries) {
        if (targetEntry.value == PushTargetType.token) {
          tokens.add(MapEntry(targetEntry.key, entry.key));
          continue;
        }
        topics.add(MapEntry(targetEntry.key, entry.key));
      }
    }
    if (tokens.isEmpty) {
      PushTargetsDbUtil.clearDeviceTokens(servicePrefix: PushTargetsDbUtil.kGmsServicePrefix);
    } else {
      PushTargetsDbUtil.insertOrReplaceDeviceTokens(servicePrefix: PushTargetsDbUtil.kGmsServicePrefix, items: tokens);
    }
    if (topics.isEmpty) {
      PushTargetsDbUtil.clearPushTopics(servicePrefix: PushTargetsDbUtil.kGmsServicePrefix);
    } else {
      PushTargetsDbUtil.insertOrReplacePushTopics(servicePrefix: PushTargetsDbUtil.kGmsServicePrefix, items: topics);
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
        Padding(padding: const EdgeInsets.fromLTRB(0, 16, 0, 8), child: Text(FlCoreLocalizations.current.push_ctrl_panel_gms_project, style: primaryTextTheme.displaySmall)),
        Stack(alignment: Alignment.centerLeft, children: [
          DropdownButtonHideUnderline(child: Padding(padding: const EdgeInsets.only(right: 144), child: DropdownButton2<String>(value: gmsController.activeProj?.id,
              buttonStyleData: ButtonStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12))),
              customButton: Container(height: kAppBtnHeight, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: currColorScheme.secondaryContainer, borderRadius: BorderRadius.circular(12)), child: Stack(alignment: Alignment.centerLeft, children: [
                Padding(padding: const EdgeInsets.only(right: 32), child: ValueListenableBuilder<String?>(valueListenable: _selectedProjIdNotifier, builder: (context, val, child) {
                  return Text(val ?? FlCoreLocalizations.current.push_ctrl_panel_gms_project, style: genTextTheme.bodyLarge);
              },)),
                Align(alignment: Alignment.centerRight, child: SizedBox(width: 16, height: 16, child: SvgPicture.asset(RAssets.icChevronDown,
                    height: 16, width: 16, colorFilter: ColorFilter.mode(currColorScheme.primary, BlendMode.srcIn))))
              ])),
              isExpanded: true, dropdownStyleData: DropdownStyleData(maxHeight: 200, decoration: BoxDecoration(color: currColorScheme.primaryContainer, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)))),
              items: gmsController.projects.keys.map((item) => DropdownMenuItem(value: item, child: Text(item, style: primaryTextTheme.labelLarge))).toList(growable: false), onChanged: (selected) {
                if (selected == null) {
                  gmsController.deselectProj();
                  return;
                }
                gmsController.selectProj(id: selected);
              }))),
          Align(alignment: Alignment.centerRight, child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(width: 40, height: 40,
                child: TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                    shape: const CircleBorder(), padding: const EdgeInsets.all(4)), onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(settings: Screens.projCtor.routeSettings(), builder: (context) => const GmsPushProjectCtorScreen()));
                }, child: SvgPicture.asset(RAssets.icPlus, width: 20, height: 20,
                    colorFilter: ColorFilter.mode(currColorScheme.secondary, BlendMode.srcIn)))
            ),
            const Padding(padding: EdgeInsets.only(left: 8)),
            SizedBox(width: 40, height: 40,
              child: ValueListenableBuilder<String?>(valueListenable: _selectedProjIdNotifier, builder: (context, val, child) {
                return TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                    shape: const CircleBorder(), padding: const EdgeInsets.all(4)), onPressed: val == null ? null : () {
                  Navigator.of(context).push(MaterialPageRoute(settings: Screens.projCtor.routeSettings(), builder: (context) => GmsPushProjectCtorScreen(initConfig: gmsController.projects[val])));
                }, child: SvgPicture.asset(RAssets.icEdit, width: 20, height: 20,
                  colorFilter: ColorFilter.mode(val == null ? currColorScheme.surface : currColorScheme.secondary, BlendMode.srcIn),));
              },),
            ),
            const Padding(padding: EdgeInsets.only(left: 8)),
            SizedBox(width: 40, height: 40,
              child: ValueListenableBuilder<String?>(valueListenable: _selectedProjIdNotifier, builder: (context, val, child) {
                return TextButton(style: TextButton.styleFrom(backgroundColor: currColorScheme.secondaryContainer, foregroundColor: currColorScheme.tertiary,
                    shape: const CircleBorder(), padding: const EdgeInsets.all(4)), onPressed: val == null ? null : () {
                  gmsController.removeProj(projId: val);
                  AppSnackBar.showSimpleTextSnack(context, text: val + " - " + FlCoreLocalizations.current.general_deleted);
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
                final id = gmsController.activeProj?.id;
                if (id != null) {
                  switch(_targetTypeNotifier.value) {
                    case PushTargetType.token:
                      targets.addAll(gmsController.getProjectTargets(id, targetType: PushTargetType.token).map((e) => e.key));
                      break;
                    case PushTargetType.topic:
                      targets.addAll(gmsController.getProjectTargets(id, targetType: PushTargetType.topic).map((e) => e.key));
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
          }, child:  Text(FlCoreLocalizations.current.push_ctrl_panel_gms_validate_only_hint, style: primaryTextTheme.bodyMedium)))
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
            final proj = gmsController.activeProj;
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
              final push = PushGms.from(pushMap);
              if (push == null) {
                AppSnackBar.showSimpleTextSnack(context, text: FlCoreLocalizations.current.push_ctrl_panel_msg_payload_parse_err);
                return;
              }
              _processingNotifier.value = true;
              final res = await gmsController.sendPush(target: targetVal, targetType: _targetTypeNotifier.value, project: proj, validateOnly: _validateOnlyPushNotifier.value, data: push.data, notification: push.notification, android: push.android, apns: push.apns, fcmOptions: push.fcmOptions);
              _processingNotifier.value = false;
              var msg = DateTime.now().toIso8601String() + " -> ";
              final parsedRes = res.result;
              final msgId = parsedRes?.pushID;
              if (msgId != null) {
                msg += "Sent - " + msgId + '\n';
              } else {
                final err = res.error;
                msg += "Send fail";
                if (err != null) {
                  msg += " - " + res.statusCode.toString() + ' ' + err.statusMsg;
                }
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