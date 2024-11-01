
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {

  final String hintText;
  final Widget? prefix;
  final Widget? prefixIcon;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final Widget? suffix;
  final Widget? suffixIcon;
  final int? maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool obscureText;
  final bool readonly;
  final List<TextInputFormatter> inputFormatters;
  final Color? fillColor;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final void Function()? onTap;
  final void Function(String value)? onChanged;

  const AppTextField({this.hintText = "", this.prefix, this.prefixIcon, this.prefixText, this.prefixStyle, this.suffix, this.suffixIcon, this.maxLines = 1,
    this.keyboardType = TextInputType.text, this.textInputAction = TextInputAction.done, this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true, this.autofocus = true,
    this.enableSuggestions = true, this.obscureText = false, this.readonly = false,
    this.inputFormatters = const[], this.fillColor, this.focusNode, this.controller, this.onTap, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final primaryTextTheme = Theme.of(context).primaryTextTheme;
    return TextField(decoration: InputDecoration(hintText: hintText, fillColor: fillColor, hoverColor: Colors.white,
        prefix: prefix, prefixIcon: prefixIcon, prefixText: prefixText, prefixStyle: prefixStyle, suffix: suffix, suffixIcon: suffixIcon),
        textAlignVertical: TextAlignVertical.center,
        maxLines: maxLines,
        readOnly: readonly,
        autofocus: autofocus,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        obscureText: obscureText,
        focusNode: focusNode,
        controller: controller,
        inputFormatters: inputFormatters,
        onTap: onTap,
        style: primaryTextTheme.bodyLarge,
        onChanged: onChanged
    );
  }
}