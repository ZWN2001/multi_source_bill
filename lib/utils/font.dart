import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_source_bill/utils/path_util.dart';

import 'package:multi_source_bill/utils/sharedpreference_util.dart';

import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class FontUtil {
  /// 自定义字体保存在本地的名字
  static const String _FONT_STORAGE_NAME = 'custom';
  static late SharedPreferences _sharedPreference;

  ///用户多次使用自定义字体时加载到不同的fontFamily
  static int _customCount = 0;

  /// 是否用户已经自定义了
  static bool get isCustom =>
      _sharedPreference.getString(SharedPreferenceUtil.CUSTOM_FONT) != null;


  static Future<void> initialize() async {
    _sharedPreference = SharedPreferenceUtil.instance;
    File fontFile =
        File(p.join(await PathUtil.dataPath(), '$_FONT_STORAGE_NAME.ttf'));
    if (await fontFile.exists()) {
      await loadFontFromList(fontFile.readAsBytesSync(),
          fontFamily:
              _sharedPreference.getString(SharedPreferenceUtil.CUSTOM_FONT));
    }
    // 应该是只需要在init的时候载入字体就好？
    // 交给build()装载Theme
    // Get.changeTheme(merge(Themes.themeNow));
  }

  /// 从字节数组保存字体
  static Future<String> saveFont(Uint8List bytes) async {
    File fontFile =
        File(p.join(await PathUtil.dataPath(), '$_FONT_STORAGE_NAME.ttf'));
    fontFile.writeAsBytes(bytes);
    await loadFontFromList(bytes,
        fontFamily: '$_FONT_STORAGE_NAME$_customCount');
    _sharedPreference.setString(
        SharedPreferenceUtil.CUSTOM_FONT, '$_FONT_STORAGE_NAME$_customCount');
    return '$_FONT_STORAGE_NAME$_customCount';
  }

  /// 从网络下载更新字体，保存到本地
  /// [url] 网络字体的下载链接 [fontName]字体名称
  static Future<String> saveNetworkFont(String url, String fontName) async {
    File fontFile =
        File(p.join(await PathUtil.dataPath(), '$_FONT_STORAGE_NAME.ttf'));
    Uint8List fontData = await (_download(url, fontName));
    fontFile.writeAsBytes(fontData);
    await loadFontFromList(fontData, fontFamily: fontName);
    _sharedPreference.setString(SharedPreferenceUtil.CUSTOM_FONT, fontName);
    return fontName;
  }

  /// 有本地缓存的情况下返回缓存
  /// 否则,从[url]下载字体到本地缓存,并返回下载的内容
  static Future<Uint8List> _download(String url, String fontName) async {
    // 读取本地缓存
    String cacheFileName =
        p.join(await PathUtil.downloadPath(), '$fontName.ttf');
    File fontFile = File(cacheFileName);
    if (fontFile.existsSync()) {
      return fontFile.readAsBytes();
    }
    //不要用Http.dio替换下面的dio,不是i山大的服务器不需要限制时间
    final response = await Dio(BaseOptions(
      responseType: ResponseType.bytes
    )).get<Uint8List>(url);
    File cacheFile = File(cacheFileName);
    cacheFile.writeAsBytesSync(response.data!);
    return response.data!;
  }

  /// 重置默认字体
  static Future<void> removeFont() async {
    File fontFile =
        File(p.join(await PathUtil.dataPath(), '$_FONT_STORAGE_NAME.ttf'));
    if (fontFile.existsSync()) {
      await fontFile.delete();
    }
    _sharedPreference.remove(SharedPreferenceUtil.CUSTOM_FONT);
  }
}
