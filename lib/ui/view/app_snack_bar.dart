
import 'package:flutter/material.dart';

class AppSnackBar extends SnackBar {
  const AppSnackBar({
    super.key,
    required super.content,
    super.duration = const Duration(seconds: 2),
    super.action,
  }): super(margin: const EdgeInsets.fromLTRB(16, 0, 16, 32));

  ///Builds and shows general text snack with applied app style
  ///
  ///[text] - Snack bar content
  ///[clearPreviousSnacks] - Dismiss all active snack bars
  static void showSimpleTextSnack(BuildContext context, {required String text,
    bool clearPreviousSnacks = true}) {
    if (text.isEmpty) {
      return;
    }
    final primaryTextTheme = Theme.of(context).primaryTextTheme;
    if (clearPreviousSnacks) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(content: Text(text, style: primaryTextTheme.bodyMedium?.copyWith(color: Colors.white))));
  }
}