import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../entity/themes.dart';
import '../utils/context_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../utils/theme.dart' as theme_util;
import '../utils/color.dart';
import '../utils/font.dart';
import '../utils/sharedpreference_util.dart';
import '../utils/theme.dart';


class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  late bool _enableDynamicColor;

  late SharedPreferences _sharedPreferences;

  //字体缩放大小
  late double _textScale;
  late String _fontValue;

  late ColorScheme _theme;
  String _themeModeName = '';

  Color? _newColor;
  late Color _fontColorOnNewColor;

  late Color _oldPrimary;
  late Color _fontColorOnOldPrimary;

  late Color _newPrimary;
  late Color _fontColorOnNewPrimary;

  bool _supportDynamicColor = false;

  @override
  void initState() {
    super.initState();
    fetchSetting();
  }

  @override
  Widget build(BuildContext context) {
    _getColors();
    _theme = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('主题设置'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          //
          // Card(
          //   margin: EdgeInsets.fromLTRB(12, 0, 12, 6),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(16.0)),
          //   ),
          //   child: ListTile(
          //     title: Text('自定义主页卡片'),
          //     trailing: Padding(
          //       padding: const EdgeInsets.only(top: 1.0),
          //       child: Icon(Icons.chevron_right),
          //     ),
          //     onTap: () async {
          //       // Get.to(() => HomeSubscriptionSettingsPage());
          //     },
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.only(left: 24.0, top: 12, bottom: 8),
            child: Text(
              '显示设置',
              style: TextStyle(color: _theme.secondary),
            ),
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: ListTile(
              title: const Text('切换主题模式'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _themeModeName,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 1.0),
                    child: Icon(Icons.chevron_right),
                  ),
                ],
              ),
              onTap: () async {
                await showEditThemeMode();
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
          // Card(
          //   margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(16.0)),
          //   ),
          //   child: SwitchListTile(
          //     title: Text('网页跟随深色模式'),
          //     subtitle: Text('应用内浏览器页面是否跟随应用深色模式'),
          //     value: _webviewFollowSystem,
          //     onChanged: (value) async {
          //       setState(() {
          //         _webviewFollowSystem = value;
          //         _sharedPreferences.setBool(
          //             SharedPreferenceUtil.WEBVIEW_FOLLOW_SYSTEM, value);
          //       });
          //     },
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.only(left: 24.0, top: 12, bottom: 8),
            child: Text(
              '字体设置',
              style: TextStyle(color: _theme.secondary),
            ),
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: ListTile(
              title: const Text('字体切换'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(FontUtil.isCustom ? '自定义字体' : '默认字体'),
                  const Padding(
                    padding: EdgeInsets.only(top: 1.0),
                    child: Icon(Icons.chevron_right),
                  ),
                ],
              ),
              onTap: () async {
                await showEditFont();
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: ListTile(
              title: const Text('字体大小'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_textScale.toStringAsFixed(2)),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () async {
                double? scale = await _showChooseTextScale();
                if (scale != null && scale != _textScale) {
                  _textScale = scale;
                  SharedPreferenceUtil.instance
                      .setDouble(SharedPreferenceUtil.TEXT_SCALE, _textScale);
                  Get.appUpdate();
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 24.0, top: 12, bottom: 8),
            child: Text(
              '主题色设置',
              style: TextStyle(color: _theme.secondary),
            ),
          ),
          Card(
            color: context.lightColors.primary,
            margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: ListTile(
              title: Text(
                '你当前的主题色',
                style: TextStyle(color: _fontColorOnOldPrimary),
              ),
              trailing: Text(ColorUtil.nameColor(_oldPrimary),
                  style: TextStyle(color: _fontColorOnOldPrimary)),
            ),
          ),
          if (_supportDynamicColor)
            Card(
              margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: SwitchListTile(
                  title: const Text('开启动态配色'),
                  subtitle: const Text('开启后将从系统壁纸提取主题色'),
                  value: _enableDynamicColor,
                  onChanged: (value) async {
                    setState(() {
                      _enableDynamicColor = value;
                      _changeTheme(
                          sourceColor: _oldPrimary, enableDynamicColor: value);
                      _sharedPreferences.setBool(
                          SharedPreferenceUtil.ENABLE_DYNAMIC_COLOR, value);
                    });
                  }),
            ),
          if (!_enableDynamicColor)
            Card(
              margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: colorPicker(),
            ),
          if (!_enableDynamicColor && _newColor != null)
            Card(
              color: _newPrimary,
              margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: InkWell(
                onTap: () {
                  _changeTheme(
                      sourceColor: _newColor!, enableDynamicColor: false);
                  _sharedPreferences.setInt(
                      SharedPreferenceUtil.THEME_SOURCE_COLOR,
                      _newColor!.value);
                },
                child: ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '新主题色：${ColorUtil.nameColor(_newPrimary)}',
                        style: TextStyle(color: _fontColorOnNewPrimary),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '确认',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: _fontColorOnNewPrimary),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Icon(Icons.chevron_right,
                            color: _fontColorOnNewPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Card(
            color: const Color(0xff006b59),
            margin: const EdgeInsets.fromLTRB(12, 6, 12, 24),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: InkWell(
              onTap: () {
                _enableDynamicColor = false;
                _changeTheme(
                    sourceColor: const Color(0xff006b59), enableDynamicColor: false);
                _sharedPreferences.setInt(
                    SharedPreferenceUtil.THEME_SOURCE_COLOR, 0xff006b59);
                _sharedPreferences.setBool(
                    SharedPreferenceUtil.ENABLE_DYNAMIC_COLOR, false);
              },
              child: ListTile(
                title: Text(
                  '恢复默认主题色',
                  style: TextStyle(color: _fontColorOnNewPrimary),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child:
                      Icon(Icons.chevron_right, color: _fontColorOnNewPrimary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchSetting() async {
    _sharedPreferences = SharedPreferenceUtil.instance;
    _enableDynamicColor =
        _sharedPreferences.getBool(SharedPreferenceUtil.ENABLE_DYNAMIC_COLOR) ??
            false;
    _textScale =
        _sharedPreferences.getDouble(SharedPreferenceUtil.TEXT_SCALE) ?? 1;
    _fontValue =
        _sharedPreferences.getString(SharedPreferenceUtil.CUSTOM_FONT_VALUE) ??
            '默认字体';
    _supportDynamicColor = await DynamicColorPlugin.getCorePalette() != null;
    switch (Themes.themeMode) {
      case ThemeMode.system:
        _themeModeName = '跟随系统';
        break;
      case ThemeMode.light:
        _themeModeName = '浅色模式';
        break;
      case ThemeMode.dark:
        _themeModeName = '深色模式';
        break;
    }
    setState(() {});
  }

  void _getColors() {
    _oldPrimary = context.lightColors.primary;
    _fontColorOnOldPrimary = ColorUtil.getReadableColor(_oldPrimary);

    _newColor ??= context.colors.surface;
    _fontColorOnNewColor = ColorUtil.getReadableColor(_newColor!);

    _newPrimary = theme_util.ThemeProvider.of(context)
        .light(_newColor)
        .colorScheme
        .primary;
    _fontColorOnNewPrimary = ColorUtil.getReadableColor(_newPrimary);
  }

  ColorPicker colorPicker() {
    return ColorPicker(
      color: _newColor!,
      // Update the screenPickerColor using the callback.
      onColorChanged: (Color color) => setState(() => _newColor = color),
      borderRadius: 22,
      heading: Text(
        '挑选新的主题色',
        style: TextStyle(fontSize: 18, color: _theme.onSurface),
      ),
      subheading: const Text(
        '',
      ),
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      wheelWidth: 30,
      wheelDiameter: 250,
      pickerTypeLabels: const <ColorPickerType, String>{
        ColorPickerType.both: '基本颜色',
        ColorPickerType.wheel: '色轮',
      },
      pickerTypeTextStyle: TextStyle(color: _fontColorOnNewColor),
      columnSpacing: 15,
      hasBorder: true,
      wheelSquareBorderRadius: 10,
      wheelHasBorder: true,
      selectedPickerTypeColor: _newColor!.withAlpha(150),
    );
  }

  Future<void> showEditFont() async {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: const Text('选择字体'),
              children: [
                RadioListTile(
                    value: '默认字体',
                    groupValue: _fontValue,
                    title: const Text('默认字体'),
                    onChanged: (dynamic name) async {
                      _fontValue = name;
                      _sharedPreferences.setString(
                          SharedPreferenceUtil.CUSTOM_FONT_VALUE, name);
                      Fluttertoast.showToast(msg: '已恢复为默认字体');
                      Get.back();
                      FontUtil.removeFont();
                      _changeTheme(fontFamily: name);
                    }),
                RadioListTile(
                    value: 'SourceHanSansSC-Normal',
                    groupValue: _fontValue,
                    title: const Text('思源黑体'),
                    onChanged: changeNetWorkFont),
                RadioListTile(
                    value: 'SourceHanSerifSC-Regular',
                    groupValue: _fontValue,
                    title: const Text('思源宋体(细)'),
                    onChanged: changeNetWorkFont),
                RadioListTile(
                    value: 'SourceHanSerifSC-Medium',
                    groupValue: _fontValue,
                    title: const Text('思源宋体(粗)'),
                    onChanged: changeNetWorkFont),
                RadioListTile(
                    value: '选择字体',
                    groupValue: _fontValue,
                    title: const Text('选择字体'),
                    onChanged: (dynamic name) async {
                      //FilePicker会自动获取获取存储权限读取外部字体文件
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['ttf', 'otf']);
                      if (result != null) {
                        _fontValue = name;
                        _sharedPreferences.setString(
                            SharedPreferenceUtil.CUSTOM_FONT_VALUE, name);
                        File file = File(result.files.single.path!);
                        String fontName =
                            await FontUtil.saveFont(file.readAsBytesSync());
                        _changeTheme(fontFamily: fontName);
                      }
                      Get.back();
                    })
              ],
            ));
  }

  void _changeTheme({
    Color? sourceColor,
    ThemeMode? themeMode,
    bool? enableDynamicColor,
    String? fontFamily,
  }) {
    theme_util.ThemeSettings themeSettings =
        ThemeProvider.of(context).settings.value;
    theme_util.ThemeSettingChange(
      settings: theme_util.ThemeSettings(
        sourceColor: sourceColor ?? themeSettings.sourceColor,
        themeMode: themeMode ?? themeSettings.themeMode,
        enableDynamicColor:
            enableDynamicColor ?? themeSettings.enableDynamicColor,
        fontFamily: fontFamily ?? themeSettings.fontFamily,
      ),
    ).dispatch(context);
  }

  Future<void> changeNetWorkFont(dynamic name) async {
    _fontValue = name;
    _sharedPreferences.setString(SharedPreferenceUtil.CUSTOM_FONT_VALUE, name);
    Fluttertoast.showToast(msg: '正在后台下载,下载完成会自动切换');
    Get.back();
    FontUtil.saveNetworkFont(
            'https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-serif/OTF/SimplifiedChinese/SourceHanSerifSC-Medium.otf',
            name)
        .then((_) => _changeTheme(fontFamily: name));
  }

  Future<void> showEditThemeMode() async {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: const Text('切换主题模式'),
              children: [
                RadioListTile(
                    value: '跟随系统',
                    groupValue: _themeModeName,
                    title: const Text('跟随系统'),
                    onChanged: (_) async {
                      _themeModeName = '跟随系统';
                      _sharedPreferences.setInt(
                          SharedPreferenceUtil.THEME_MODE, 0);
                      _changeTheme(themeMode: ThemeMode.system);
                      Get.back();
                    }),
                RadioListTile(
                    value: '浅色模式',
                    groupValue: _themeModeName,
                    title: const Text('浅色模式'),
                    onChanged: (dynamic name) async {
                      _themeModeName = '浅色模式';
                      _sharedPreferences.setInt(
                          SharedPreferenceUtil.THEME_MODE, 1);
                      _changeTheme(themeMode: ThemeMode.light);
                      Get.back();
                    }),
                RadioListTile(
                    value: '深色模式',
                    groupValue: _themeModeName,
                    title: const Text('深色模式'),
                    onChanged: (dynamic name) {
                      _themeModeName = '深色模式';
                      _sharedPreferences.setInt(
                          SharedPreferenceUtil.THEME_MODE, 2);
                      _changeTheme(themeMode: ThemeMode.dark);
                      Get.back();
                    }),
              ],
            ));
  }

  Future<double?> _showChooseTextScale() async {
    var sliderValue = _textScale.obs;
    return showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('选择字体大小'),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: sliderValue.value,
                onChanged: (data) {
                  setState(() {
                    sliderValue.value = data;
                  });
                },
                min: 0.5,
                max: 2.0,
                divisions: 30,
                label: sliderValue.toStringAsFixed(2),
                activeColor: context.colors.primary,
                inactiveColor: Colors.grey,
              ),
              MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(sliderValue.value),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Text('小'),
                      Expanded(child: Container()),
                      const Text('大')
                    ],
                  ))
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(sliderValue.value);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
