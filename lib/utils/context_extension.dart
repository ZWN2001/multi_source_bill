import 'package:flutter/material.dart';
import 'package:multi_source_bill/utils/theme.dart';

extension TypographyUtil on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  ColorScheme get lightColors => ThemeProvider.of(this)
      .light(ThemeProvider.of(this).settings.value.sourceColor)
      .colorScheme;

  ColorScheme get darkColors => ThemeProvider.of(this)
      .dark(ThemeProvider.of(this).settings.value.sourceColor)
      .colorScheme;

  ThemeMode get themeMode => ThemeProvider.of(this).themeMode();

  double get safeAreaHeight => MediaQuery.of(this).padding.top;
}
