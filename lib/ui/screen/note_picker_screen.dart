
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pusher/generated/assets.dart';

class NotePickerScreen extends StatelessWidget {

  final String title;
  final List<String> items;
  final void Function(String selected) onPick;

  NotePickerScreen({required this.title, required this.items, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final currTheme = Theme.of(context);
    final currColorScheme = currTheme.colorScheme;
    final primaryTextTheme = currTheme.primaryTextTheme;

    return Scaffold(body: SafeArea(child: Stack(children: [
        Padding(padding: EdgeInsets.fromLTRB(0,16,0,0), child: Stack(alignment: Alignment.topCenter, children: [
        Align(alignment: Alignment.topLeft, child: SizedBox(width: 32, height: 32, child: TextButton(onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: currColorScheme.tertiary, shape: CircleBorder(),
                padding: EdgeInsets.only(left: 16), alignment: Alignment.centerLeft), child: SvgPicture.asset(R.ASSETS_IC_CHEVRON_LEFT_SVG, colorFilter: ColorFilter.mode(currColorScheme.primary, BlendMode.srcIn)))
        )),
        Padding(padding: EdgeInsets.symmetric(horizontal: 32), child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: primaryTextTheme.displayMedium))
      ],)),
      Padding(padding: EdgeInsets.only(top: 16 + (primaryTextTheme.displayMedium?.fontSize ?? 24.0)), child: ListView(physics: BouncingScrollPhysics(), padding: EdgeInsets.symmetric(horizontal: 16), children: items.map((e) => Padding(padding: EdgeInsets.only(top: 12), child: Container(width: mediaQuery.size.width, padding: EdgeInsets.symmetric(vertical: 4), child: TextButton(onPressed: () {
        onPick(e);
        Navigator.of(context).pop();
      }, style: TextButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: currColorScheme.tertiary, padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text(e, style: primaryTextTheme.bodyMedium))))).toList(growable: false)))
    ])));
  }
}