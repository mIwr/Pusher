
import 'package:flutter/material.dart';

///Represents additional colors theme extension
class AppColorSchemeThemeExt extends ThemeExtension<AppColorSchemeThemeExt> {

  ///Attention color
  final Color attention;
  ///Color, which readable at [attention] color
  final Color onAttention;
  ///Attention container background color
  final Color attentionContainer;
  ///Color, which readable at [attentionContainer] color
  final Color onAttentionContainer;

  ///Positive color
  final Color positive;
  ///Color, which readable at [positive] color
  final Color onPositive;
  ///Positive container background color
  final Color positiveContainer;
  ///Color, which readable at [positiveContainer] color
  final Color onPositiveContainer;

  const AppColorSchemeThemeExt({required this.attention, required this.onAttention,
  required this.attentionContainer, required this.onAttentionContainer,
  required this.positive, required this.onPositive, required this.positiveContainer,
  required this.onPositiveContainer});

  @override
  ThemeExtension<AppColorSchemeThemeExt> copyWith({Color? attention, Color? onAttention,
    Color? attentionContainer, Color? onAttentionContainer, Color? positive,
    Color? onPositive, Color? positiveContainer, Color? onPositiveContainer,}) {
    return AppColorSchemeThemeExt(attention: attention ?? this.attention,
        onAttention: onAttention ?? this.onAttention,
        attentionContainer: attentionContainer ?? this.attentionContainer,
        onAttentionContainer: onAttentionContainer ?? this.onAttentionContainer,
        positive: positive ?? this.positive, onPositive: onPositive ?? this.onPositive,
        positiveContainer: positiveContainer ?? this.positiveContainer,
        onPositiveContainer: onPositiveContainer ?? this.onPositiveContainer,
    );
  }

  @override
  ThemeExtension<AppColorSchemeThemeExt> lerp(ThemeExtension<AppColorSchemeThemeExt>? other, double t) {
    if (other is! AppColorSchemeThemeExt) {
      return this;
    }

    return AppColorSchemeThemeExt(attention: Color.lerp(attention, other.attention, t) ?? attention,
        onAttention: Color.lerp(onAttention, other.onAttention, t) ?? onAttention,
        attentionContainer: Color.lerp(attentionContainer, other.attentionContainer, t) ?? attentionContainer,
        onAttentionContainer: Color.lerp(onAttentionContainer, other.onAttentionContainer, t) ?? onAttentionContainer,
        positive: Color.lerp(positive, other.positive, t) ?? positive,
        onPositive: Color.lerp(onPositive, other.onPositive, t) ?? onPositive,
        positiveContainer: Color.lerp(positiveContainer, other.positiveContainer, t) ?? positiveContainer,
        onPositiveContainer: Color.lerp(onPositiveContainer, other.onPositiveContainer, t) ?? onPositiveContainer,
    );
  }
}