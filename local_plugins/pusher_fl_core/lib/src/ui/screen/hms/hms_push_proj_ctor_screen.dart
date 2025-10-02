
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pusher_core/pusher_core.dart';
import 'package:pusher_core/pusher_core_model.dart';

import '../../../generated/assets.gen.dart';
import '../../../generated/l10n.dart';
import '../../../global_constants.dart';
import '../../view/app_snack_bar.dart';
import '../../view/app_text_field.dart';
import '../../view/text_button_accent.dart';

class HmsPushProjectCtorScreen extends StatefulWidget {

  final HmsProjectConfig? initConfig;

  const HmsPushProjectCtorScreen({super.key, this.initConfig});

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
      Padding(padding: const EdgeInsets.fromLTRB(0,16,0,0), child: Stack(alignment: Alignment.topCenter, children: [
        Align(alignment: Alignment.topLeft, child: SizedBox(width: 32, height: 32, child: TextButton(onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: currColorScheme.tertiary, shape: const CircleBorder(),
                padding: const EdgeInsets.only(left: 16), alignment: Alignment.centerLeft), child: SvgPicture.asset(RAssets.icChevronLeft, colorFilter: ColorFilter.mode(currColorScheme.primary, BlendMode.srcIn)))
        )),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: Text(widget.initConfig == null
            ? (FlCoreLocalizations.current.proj_ctor_new_title + " HMS")
            : (FlCoreLocalizations.current.proj_ctor_upd_title + " HMS"), textAlign: TextAlign.center, style: primaryTextTheme.displayLarge))
      ],)),
      Padding(padding: EdgeInsets.only(top: 32 + (primaryTextTheme.displayLarge?.fontSize ?? 24.0)),
          child: SingleChildScrollView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(FlCoreLocalizations.current.proj_ctor_hms_id_hint, style: primaryTextTheme.bodyLarge),
            const Padding(padding: EdgeInsets.only(top: 8)),
            AppTextField(hintText: FlCoreLocalizations.current.proj_ctor_hms_id_hint, controller: _idTextController, keyboardType: TextInputType.number,),
            const Padding(padding: EdgeInsets.only(top: 16)),
            Text(FlCoreLocalizations.current.proj_ctor_hms_cl_id_hint, style: primaryTextTheme.bodyLarge),
            const Padding(padding: EdgeInsets.only(top: 8)),
            AppTextField(hintText: FlCoreLocalizations.current.proj_ctor_hms_cl_id_hint, controller: _clIdTextController, keyboardType: TextInputType.number,),
            const Padding(padding: EdgeInsets.only(top: 16)),
            Text(FlCoreLocalizations.current.proj_ctor_hms_cl_secret_hint, style: primaryTextTheme.bodyLarge),
            const Padding(padding: EdgeInsets.only(top: 8)),
            AppTextField(hintText: FlCoreLocalizations.current.proj_ctor_hms_cl_secret_hint, controller: _clSecretTextController),
            const Padding(padding: EdgeInsets.only(top: kAppBtnHeight + 32))
          ]))),
      Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: SizedBox(width: MediaQuery.of(context).size.width,
          child: TextButtonAccent(content: FlCoreLocalizations.current.general_accept, onPressed: () {
            if (_idTextController.text.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: FlCoreLocalizations.current.proj_ctor_hms_id_empty_err);
              return;
            }
            if (_clIdTextController.text.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: FlCoreLocalizations.current.proj_ctor_hms_cl_id_empty_err);
              return;
            }
            if (_clSecretTextController.text.isEmpty) {
              AppSnackBar.showSimpleTextSnack(context, text: FlCoreLocalizations.current.proj_ctor_hms_cl_secret_empty_err);
              return;
            }
            final id = int.tryParse(_idTextController.text);
            if (id == null) {
              AppSnackBar.showSimpleTextSnack(context, text: FlCoreLocalizations.current.proj_ctor_hms_id_invalid_err);
              return;
            }
            final clId = int.tryParse(_clIdTextController.text);
            if (clId == null) {
              AppSnackBar.showSimpleTextSnack(context, text: FlCoreLocalizations.current.proj_ctor_hms_cl_id_invalid_err);
              return;
            }
            final proj = HmsProjectConfig(hmsId: id, clID: clId, clSecret: _clSecretTextController.text);
            final stockProj = widget.initConfig;
            hmsController.addOrUpdateProj(proj);
            if (stockProj == null) {
              //Add new config
              if (hmsController.activeProj == null) {
                //No selected configs -> set recently added
                hmsController.selectProj(id: proj.id);
              }
            } else if (stockProj.id != proj.id) {
              hmsController.selectProj(id: proj.id);
              hmsController.removeProj(projId: stockProj.id);
            }
            Navigator.of(context).pop();
          }))
      ))
    ]))));
  }
}
