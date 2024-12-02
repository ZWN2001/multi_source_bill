import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {


  static SharedPreferences? _instance;

  static Future<void> initialize() async {
    _instance ??= await SharedPreferences.getInstance();
  }

  ///必须先进行初始化
  static SharedPreferences get instance {
    assert(_instance != null);
    return _instance!;
  }


  static const ENABLE_DYNAMIC_COLOR = 'enableDynamicColor';

  ///主题模式
  static const THEME_MODE = 'themeMode';

  ///自定义字体选择
  static const CUSTOM_FONT_VALUE = 'customFontValue';

  ///主题基准颜色
  static const THEME_SOURCE_COLOR = 'themeSourceColor';

  ///自定义字体
  static const CUSTOM_FONT = 'customFont';

  ///全局字体缩放
  static const TEXT_SCALE = 'textScale';
}
