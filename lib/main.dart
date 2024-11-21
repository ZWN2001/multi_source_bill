import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:multi_source_bill/api/db_api.dart';
import 'package:multi_source_bill/page/home_page.dart';
import 'package:multi_source_bill/page/menu_page.dart';
import 'package:multi_source_bill/utils/db.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut(()=>HomePageController());
  await DB.initialize();
  await DBApi.dbInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainPage(),

    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final zoomDrawerController = ZoomDrawerController();
    return ZoomDrawer(
      controller: zoomDrawerController,
      menuScreen: const MenuPage(),
      mainScreen: HomePage(controller: zoomDrawerController,),
      borderRadius: 24.0,
      showShadow: true,
      mainScreenTapClose: true,
      angle: -12.0,
      drawerShadowsBackgroundColor: Colors.grey,
      slideWidth: MediaQuery.of(context).size.width * 0.9,
    );
  }
}
