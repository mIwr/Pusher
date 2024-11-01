
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pusher/generated/l10n.dart';
import 'package:pusher_core/pusher_core.dart';
import 'package:pusher_core/pusher_core_model.dart';
import 'package:pusher_fl_core/pusher_fl_core.dart';
import 'package:pusher_fl_core/pusher_fl_core_ui.dart';

class GmsPushProjectCtorScreen extends StatefulWidget {

  final GmsProjectConfig? initConfig;

  const GmsPushProjectCtorScreen({super.key, this.initConfig});

  @override
  State createState() => _GmsPushProjectCtorScreenState();
}

class _GmsPushProjectCtorScreenState extends State<GmsPushProjectCtorScreen> {

  final _idNotifier = ValueNotifier<String?>(null);
  final _apiV1CredTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initConfig == null) {
      return;
    }
    _idNotifier.value = widget.initConfig?.id;
    final initApiV1Cred = widget.initConfig?.apiV1Cred;
    if (initApiV1Cred != null && initApiV1Cred.isNotEmpty) {
      _apiV1CredTextController.text = json.encode(initApiV1Cred);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Theme.of(context);
    final currColorScheme = currTheme.colorScheme;
    final primaryTextTheme = currTheme.primaryTextTheme;

    return Scaffold(body: SafeArea(child: GestureDetector(onTap: () {
      FocusScope.of(context).unfocus();
    }, child: Stack( children: [
      Padding(padding: const EdgeInsets.fromLTRB(0,16,0,0), child: Stack(alignment: Alignment.topCenter, children: [
          Align(alignment: Alignment.topLeft, child: SizedBox(width: 32, height: 32, child: TextButton(onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: currColorScheme.tertiary, shape: const CircleBorder(),
              padding: const EdgeInsets.only(left: 16), alignment: Alignment.centerLeft), child: SvgPicture.asset(AssetsUtil.getAssetPath(R.ASSETS_IC_CHEVRON_LEFT_SVG), colorFilter: ColorFilter.mode(currColorScheme.primary, BlendMode.srcIn)))
          )),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: Text(widget.initConfig == null
              ? (S.current.proj_ctor_new_title + " GMS")
              : (S.current.proj_ctor_upd_title + " GMS"), textAlign: TextAlign.center, style: primaryTextTheme.displayLarge))
        ],)),
      Padding(padding: EdgeInsets.only(top: 32 + (primaryTextTheme.displayLarge?.fontSize ?? 24.0)),
          child: SingleChildScrollView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(S.current.proj_ctor_gms_id_hint, style: primaryTextTheme.bodyLarge),
            const Padding(padding: EdgeInsets.only(top: 8)),
            ValueListenableBuilder<String?>(valueListenable: _idNotifier, builder: (context, val, child) {
              var text = "N/A";
              if (val != null && val.isNotEmpty) {
                text = val;
              }
              return Text(text, style: primaryTextTheme.displaySmall);
            }),
            const Padding(padding: EdgeInsets.only(top: 16)),
            Text(S.current.proj_ctor_gms_cred_json_hint, style: primaryTextTheme.bodyLarge),
            const Padding(padding: EdgeInsets.only(top: 8)),
            AppTextField(hintText: S.current.proj_ctor_gms_cred_json_hint, maxLines: 11, controller: _apiV1CredTextController, onChanged: (newText) {
              try {
                final Map<String, dynamic> jsonMap = json.decode(newText) ?? {};
                final Map<String, String> map = Map.from(jsonMap);
                final tempConfig = GmsProjectConfig(apiV1Cred: map);
                _idNotifier.value = tempConfig.id;
              } catch(error) {
                if (kDebugMode) {
                  print(error);
                }
              }
            }),
            const Padding(padding: EdgeInsets.only(top: kAppBtnHeight + 32))
          ]))),
      Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: SizedBox(width: MediaQuery.of(context).size.width,
          child: TextButtonAccent(content: S.current.general_accept, onPressed: () {
            if (_apiV1CredTextController.text.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.proj_ctor_gms_cred_empty_err);
              return;
            }
            if (_idNotifier.value == null || _idNotifier.value?.isEmpty == true) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.proj_ctor_gms_id_empty_err);
              return;
            }
            try {
              final Map<String, dynamic> map = json.decode(_apiV1CredTextController.text);
              final cred = HashMap<String, String>();
              for (final entry in map.entries) {
                if (entry.value is String) {
                  cred[entry.key] = entry.value;
                  continue;
                }
                cred[entry.key] = entry.value.toString();
              }
              final proj = GmsProjectConfig(apiV1Cred: cred);
              final stockProj = widget.initConfig;
              gmsController.addOrUpdateProj(proj);
              if (stockProj == null) {
                //Add new config
                if (gmsController.activeProj == null) {
                  //No selected configs -> set recently added
                  gmsController.selectProj(id: proj.id);
                }
              } else if (stockProj.id != proj.id) {
                gmsController.selectProj(id: proj.id);
                gmsController.removeProj(projId: stockProj.id);
              }
            } catch(error) {
              if (kDebugMode) {
                print(error);
              }
              AppSnackBar.showSimpleTextSnack(context, text: S.current.proj_ctor_gms_cred_empty_err + '\n' + error.toString());
              return;
            }
            Navigator.of(context).pop();
          }))
      ))
    ]))));
  }
}
