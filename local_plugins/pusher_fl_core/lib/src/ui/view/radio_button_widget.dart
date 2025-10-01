
import 'package:flutter/material.dart';

class RadioButton<T> extends StatelessWidget {

  final T value;
  final T? groupValue;
  final String semanticLabel;
  final Widget title;
  final EdgeInsets contentPadding;
  final EdgeInsets spacing;
  final ValueChanged<T?> onChanged;

  const RadioButton({super.key,
    required this.value,
    required this.groupValue,
    this.semanticLabel = "",
    required this.title,
    this.contentPadding = EdgeInsets.zero,
    this.spacing = EdgeInsets.zero,
    required this.onChanged,
  });

  Widget _buildCheckIndicator(BuildContext context) {
    final bool selected = value == groupValue;
    final currTheme = Theme.of(context);
    final currColorScheme = currTheme.colorScheme;

    if (selected) {
      return Container(width: 24, height: 24, padding: EdgeInsets.zero,
          alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle,
              color: currColorScheme.secondary),
          child: Container(width: 10, height: 10, decoration: BoxDecoration(color: currColorScheme.primaryContainer, shape: BoxShape.circle))
      );
    }

    return Container(width: 24, height: 24, padding: EdgeInsets.zero,
        alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle,
            color: currTheme.secondaryHeaderColor),
        child: Container(width: 21, height: 21, decoration: BoxDecoration(color: currColorScheme.primaryContainer, shape: BoxShape.circle))
    );
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Theme.of(context);
    final currColorScheme = currTheme.colorScheme;

    return Padding(padding: spacing, child: Semantics(container: true, checked: value == groupValue,
      label: semanticLabel, excludeSemantics: true,
      child: TextButton(onPressed: () {
        if (value == groupValue) {
          return;
        }
        onChanged(value);
      },
        style: TextButton.styleFrom(padding: contentPadding, foregroundColor: currColorScheme.tertiary,),
        child: Stack(alignment: Alignment.centerLeft, children: [
          _buildCheckIndicator(context),
          Padding(padding: const EdgeInsets.only(left: 34), child: title)
        ],
        ),
      ),
    ));
  }
}