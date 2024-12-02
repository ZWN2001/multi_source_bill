import 'package:flutter/material.dart';

import '../utils/sharedpreference_util.dart';

class Themes {
  ///主题的基准颜色
  static Color get themeSourceColor {
    int colorValue = SharedPreferenceUtil.instance
            .getInt(SharedPreferenceUtil.THEME_SOURCE_COLOR) ??
        Colors.teal.value;
    return Color(colorValue);
  }

  static ThemeMode get themeMode {
    //mode: 0-跟随系统 1-浅色模式 2-深色模式
    int mode = SharedPreferenceUtil.instance
            .getInt(SharedPreferenceUtil.THEME_MODE) ??
        0;
    switch (mode) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static bool get enableDynamicColor =>
      SharedPreferenceUtil.instance
          .getBool(SharedPreferenceUtil.ENABLE_DYNAMIC_COLOR) ??
      false;

  static String? get fontFamily =>
      SharedPreferenceUtil.instance
          .getString(SharedPreferenceUtil.CUSTOM_FONT_VALUE);
}
