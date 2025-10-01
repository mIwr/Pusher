
import '../../global_constants.dart';
import 'package:flutter/material.dart';

class TextButtonAccent extends StatelessWidget {

  static const _disabledBg = Color(0xff9E9FCA);
  static const _disabledText = Color(0x80FFFFFF);

  final EdgeInsets padding;
  final Color? bgColor;
  final void Function()? onPressed;
  final String content;

  const TextButtonAccent({super.key, required this.content, this.padding = EdgeInsets.zero, this.bgColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final currTheme = Theme.of(context);
    final currColorScheme = currTheme.colorScheme;
    final primaryTextTheme = currTheme.primaryTextTheme;

    final textColor = onPressed == null ? _disabledText : Colors.white;
    final btnBg = bgColor ?? currColorScheme.secondary;

    return TextButton(onPressed: onPressed, style: TextButton.styleFrom(foregroundColor: currColorScheme.secondaryContainer,
        backgroundColor: btnBg, disabledBackgroundColor: _disabledBg,
        minimumSize: const Size(100, kAppBtnHeight), alignment: Alignment.center, padding: padding,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24)))), child: Text(content, textAlign: TextAlign.center, style: primaryTextTheme.labelLarge?.copyWith(color: textColor)),
    );
  }
}