
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pusher/global_constants.dart';
import 'package:pusher/global_variables.dart';
import 'package:pusher/model/gms/gms_project_config.dart';
import 'package:pusher/generated/l10n.dart';
import 'package:pusher/generated/assets.dart';
import 'package:pusher/ui/view/app_snack_bar.dart';
import 'package:pusher/ui/view/app_text_field.dart';
import 'package:pusher/ui/view/text_button_accent.dart';

class GmsPushProjectCtorScreen extends StatefulWidget {

  final GmsProjectConfig? initConfig;

  GmsPushProjectCtorScreen({this.initConfig});

  @override
  State createState() => _GmsPushProjectCtorScreenState();
}

class _GmsPushProjectCtorScreenState extends State<GmsPushProjectCtorScreen> {

  final _idTextController = TextEditingController();
  final _apiV1CredTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initConfig == null) {
      return;
    }
    final initId = widget.initConfig?.id;
    if (initId != null && initId.isNotEmpty) {
      _idTextController.text = initId;
    }
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
      Padding(padding: EdgeInsets.fromLTRB(0,16,0,0), child: Stack(alignment: Alignment.topCenter, children: [
          Align(alignment: Alignment.topLeft, child: SizedBox(width: 32, height: 32, child: TextButton(onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: currColorScheme.tertiary, shape: CircleBorder(),
              padding: EdgeInsets.only(left: 16), alignment: Alignment.centerLeft), child: SvgPicture.asset(R.ASSETS_IC_CHEVRON_LEFT_SVG, colorFilter: ColorFilter.mode(currColorScheme.primary, BlendMode.srcIn)))
          )),
          Padding(padding: EdgeInsets.symmetric(horizontal: 32), child: Text(widget.initConfig == null
              ? (S.current.proj_ctor_new_title + " GMS")
              : (S.current.proj_ctor_upd_title + " GMS"), textAlign: TextAlign.center, style: primaryTextTheme.displayLarge))
        ],)),
      Padding(padding: EdgeInsets.only(top: 32 + (primaryTextTheme.displayLarge?.fontSize ?? 24.0)),
          child: SingleChildScrollView(physics: BouncingScrollPhysics(), padding: EdgeInsets.fromLTRB(16, 0, 16, 0), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(S.current.proj_ctor_gms_id_hint, style: primaryTextTheme.bodyLarge),
            Padding(padding: EdgeInsets.only(top: 8)),
            AppTextField(hintText: S.current.proj_ctor_gms_id_hint, controller: _idTextController),
            Padding(padding: EdgeInsets.only(top: 16)),
            Text(S.current.proj_ctor_gms_cred_json_hint, style: primaryTextTheme.bodyLarge),
            Padding(padding: EdgeInsets.only(top: 8)),
            AppTextField(hintText: S.current.proj_ctor_gms_cred_json_hint, maxLines: 11, controller: _apiV1CredTextController),
            Padding(padding: EdgeInsets.only(top: kAppBtnHeight + 32))
          ]))),
      Align(alignment: Alignment.bottomCenter, child: Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 12), child: SizedBox(width: MediaQuery.of(context).size.width,
          child: TextButtonAccent(content: S.current.general_accept, onPressed: () {
            if (_idTextController.text.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.proj_ctor_gms_id_empty_err);
              return;
            }
            if (_apiV1CredTextController.text.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.proj_ctor_gms_cred_empty_err);
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
              final proj = GmsProjectConfig(fcmId: _idTextController.text, apiV1Cred: cred);
              final stockProj = widget.initConfig;
              gmsController.updateProj(proj);
              if (stockProj != null && stockProj.id != proj.id) {
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
