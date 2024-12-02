import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_source_bill/api/db_api.dart';
import 'package:multi_source_bill/page/filter_select_page.dart';
import 'package:multi_source_bill/page/home_page.dart';
import 'package:multi_source_bill/utils/db.dart';
import 'package:multi_source_bill/utils/font.dart';
import 'package:multi_source_bill/utils/sharedpreference_util.dart';
import 'package:multi_source_bill/utils/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'entity/themes.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.initialize();
  await SharedPreferenceUtil.initialize();
  if(kDebugMode){
    await DBApi.dbInit();
  }
  Get.lazyPut(()=>HomePageController());
  Get.lazyPut(()=>FilterSelectPageController());
  await FontUtil.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = ValueNotifier(
      ThemeSettings(
          sourceColor: Themes.themeSourceColor,
          themeMode: Themes.themeMode,
          enableDynamicColor: Themes.enableDynamicColor,
          fontFamily: Themes.fontFamily),
    );
    if (Theme.of(context).platform == TargetPlatform.android) {
      SystemUiOverlayStyle style = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Themes.themeMode == ThemeMode.light
              ? Brightness.dark
              : Themes.themeMode == ThemeMode.dark
              ? Brightness.light
              : null);
      SystemChrome.setSystemUIOverlayStyle(style);
    }
    return DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) => ThemeProvider(
          lightDynamic: lightDynamic,
          darkDynamic: darkDynamic,
          settings: settings,
          child: NotificationListener<ThemeSettingChange>(
            onNotification: (notification) {
              Brightness? brightness;
              Color? navigatorBarColor;
              settings.value = notification.settings;
              switch (settings.value.themeMode) {
                case ThemeMode.light:
                  brightness = Brightness.dark;
                  navigatorBarColor = Colors.transparent;
                  break;
                case ThemeMode.dark:
                  brightness = Brightness.light;
                  navigatorBarColor = Colors.black87;
                  break;
                case ThemeMode.system:
                  brightness = null;
                  break;
              }
              SystemUiOverlayStyle style = SystemUiOverlayStyle(
                  systemNavigationBarColor: navigatorBarColor,
                  systemNavigationBarIconBrightness: brightness);
              SystemChrome.setSystemUIOverlayStyle(style);
              return true;
            },
            child: ValueListenableBuilder<ThemeSettings>(
              valueListenable: settings,
              builder: (context, value, _) {
                final theme = ThemeProvider.of(context);
                return GetMaterialApp(
                  //去除debug标志
                  debugShowCheckedModeBanner: false,
                  //主题
                  theme: theme.light(settings.value.sourceColor,
                      settings.value.fontFamily),
                  darkTheme: theme.dark(settings.value.sourceColor,
                      settings.value.fontFamily),
                  themeMode: theme.themeMode(),
                  supportedLocales: const [
                    Locale('zh', 'CN'),
                    Locale('en', 'US'),
                  ],
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  locale: const Locale('zh'),
                  home: const HomePage()
                );
              },
            ),
          ),
        ));
  }
}
