
import 'package:flutter/material.dart';
import 'package:pusher/global_constants.dart';

class TextButtonAccent extends StatelessWidget {

  static const _disabledBg = Color(0xff9E9FCA);
  static const _disabledText = Color(0x80FFFFFF);

  final EdgeInsets padding;
  final Color? bgColor;
  final void Function()? onPressed;
  final String content;

  const TextButtonAccent({required this.content, this.padding = EdgeInsets.zero, this.bgColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final currTheme = Theme.of(context);
    final currColorScheme = currTheme.colorScheme;
    final primaryTextTheme = currTheme.primaryTextTheme;

    final textColor = onPressed == null ? _disabledText : Colors.white;
    final btnBg = bgColor ?? currColorScheme.secondary;

    return TextButton(onPressed: onPressed, style: TextButton.styleFrom(foregroundColor: currColorScheme.secondaryContainer,
        backgroundColor: btnBg, disabledBackgroundColor: _disabledBg,
        minimumSize: Size(100, kAppBtnHeight), alignment: Alignment.center, padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24)))), child: Text(content, textAlign: TextAlign.center, style: primaryTextTheme.labelLarge?.copyWith(color: textColor)),
    );
  }
}