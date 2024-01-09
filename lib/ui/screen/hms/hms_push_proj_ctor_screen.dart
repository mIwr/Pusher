
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pusher/global_constants.dart';
import 'package:pusher/global_variables.dart';
import 'package:pusher/generated/l10n.dart';
import 'package:pusher/generated/assets.dart';
import 'package:pusher/model/hms/hms_project_config.dart';
import 'package:pusher/ui/view/app_snack_bar.dart';
import 'package:pusher/ui/view/app_text_field.dart';
import 'package:pusher/ui/view/text_button_accent.dart';

class HmsPushProjectCtorScreen extends StatefulWidget {

  final HmsProjectConfig? initConfig;

  HmsPushProjectCtorScreen({this.initConfig});

  @override
  State createState() => _HmsPushProjectCtorScreenState();
}

class _HmsPushProjectCtorScreenState extends State<HmsPushProjectCtorScreen> {

  final _idTextController = TextEditingController();
  final _clIdTextController = TextEditingController();
  final _clSecretTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initConfig == null) {
      return;
    }
    var initId = widget.initConfig?.id;
    if (initId != null) {
      _idTextController.text = initId.toString();
    }
    initId = widget.initConfig?.clID;
    if (initId != null) {
      _clIdTextController.text = initId.toString();
    }
    final initSecret = widget.initConfig?.clSecret;
    if (initSecret != null && initSecret.isNotEmpty) {
      _clSecretTextController.text = initSecret;
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
            ? (S.current.proj_ctor_new_title + " HMS")
            : (S.current.proj_ctor_upd_title + " HMS"), textAlign: TextAlign.center, style: primaryTextTheme.displayLarge))
      ],)),
      Padding(padding: EdgeInsets.only(top: 32 + (primaryTextTheme.displayLarge?.fontSize ?? 24.0)),
          child: SingleChildScrollView(physics: BouncingScrollPhysics(), padding: EdgeInsets.fromLTRB(16, 0, 16, 0), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(S.current.proj_ctor_hms_id_hint, style: primaryTextTheme.bodyLarge),
            Padding(padding: EdgeInsets.only(top: 8)),
            AppTextField(hintText: S.current.proj_ctor_hms_id_hint, controller: _idTextController, keyboardType: TextInputType.number,),
            Padding(padding: EdgeInsets.only(top: 16)),
            Text(S.current.proj_ctor_hms_cl_id_hint, style: primaryTextTheme.bodyLarge),
            Padding(padding: EdgeInsets.only(top: 8)),
            AppTextField(hintText: S.current.proj_ctor_hms_cl_id_hint, controller: _clIdTextController, keyboardType: TextInputType.number,),
            Padding(padding: EdgeInsets.only(top: 16)),
            Text(S.current.proj_ctor_hms_cl_secret_hint, style: primaryTextTheme.bodyLarge),
            Padding(padding: EdgeInsets.only(top: 8)),
            AppTextField(hintText: S.current.proj_ctor_hms_cl_secret_hint, controller: _clSecretTextController),
            Padding(padding: EdgeInsets.only(top: kAppBtnHeight + 32))
          ]))),
      Align(alignment: Alignment.bottomCenter, child: Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 12), child: SizedBox(width: MediaQuery.of(context).size.width,
          child: TextButtonAccent(content: S.current.general_accept, onPressed: () {
            if (_idTextController.text.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.proj_ctor_hms_id_empty_err);
              return;
            }
            if (_clIdTextController.text.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.proj_ctor_hms_cl_id_empty_err);
              return;
            }
            if (_clSecretTextController.text.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.proj_ctor_hms_cl_secret_empty_err);
              return;
            }
            final id = int.tryParse(_idTextController.text);
            if (id == null) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.proj_ctor_hms_id_invalid_err);
              return;
            }
            final clId = int.tryParse(_clIdTextController.text);
            if (clId == null) {
              AppSnackBar.showSimpleTextSnack(context, text: S.current.proj_ctor_hms_cl_id_invalid_err);
              return;
            }
            final proj = HmsProjectConfig(hmsId: id, clID: clId, clSecret: _clSecretTextController.text);
            final stockConfig = widget.initConfig;
            if (stockConfig != null) {
              hmsController.removeProj(projId: stockConfig.id);
            }
            hmsController.updateProj(proj);
            Navigator.of(context).pop();
          }))
      ))
    ]))));
  }
}
