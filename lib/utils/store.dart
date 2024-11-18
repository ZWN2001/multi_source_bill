// import 'dart:async';
//
// import 'package:hive_flutter/adapters.dart';
// import 'package:multi_source_bill/test_cases.dart';
//
// import '../entity/data_overview.dart';
//
// /// Non-SQL K-V Storage
// class Store {
//   static late Box _dataOverviewBox;
//   static late Box _allAmountBox;
//
//   static bool _initialized = false;
//
//   ///工具箱的持久化存储,key以 模块:key名称:类型 规范放入(类型仅作辅助判断)
//   static Box get dataOverviewBox => _dataOverviewBox;
//   static Box get allAmountBox => _allAmountBox;
//
//   static Future<void> initialize() async {
//     if (_initialized) {
//       return;
//     }
//     String? subDir;
//     await Hive.initFlutter(subDir);
//     // _dataOverviewBox = await Hive.openBox('dataOverviewBox');
//     _allAmountBox = await Hive.openBox('allAmountBox');
//     _initialized = true;
//     // initData();
//   }
//
//   static void initData(){
//     DataOverview all =DataOverview(amount: 0, amountLast: 0,chartData: [], source: '总');
//     _allAmountBox.put('all', all.toJson());
//     for (var element in TestCases.dataOverviews) {
//       _dataOverviewBox.put(element.source, element.toJson());
//     }
//   }
//
//   // static bool containsKey(String key) {
//   //   return _infoBox.containsKey(key);
//   // }
//   //
//   // static String getString(String key, {String def = ""}) {
//   //   return get<String>(key) ?? def;
//   // }
//   //
//   // static int getInt(String key, {int def = 0}) {
//   //   return get<int>(key) ?? def;
//   // }
//   //
//   // static double getDouble(String key, {double def = 0.0}) {
//   //   return get<double>(key) ?? def;
//   // }
//   //
//   // static bool getBool(String key, {bool def = false}) {
//   //   return get<bool>(key) ?? def;
//   // }
//   //
//   // static List<T> getList<T>(String key, {List<T> def = const []}) {
//   //   Iterable? l = get(key);
//   //   if (l == null || l.isEmpty) {
//   //     return def;
//   //   } else {
//   //     return l.cast<T>().toList();
//   //   }
//   // }
//
//   // static Map<K, V> getMap<K, V>(String key, {Map<K, V> def = const {}}) {
//   //   Map<String, dynamic>? map = get<Map<String, dynamic>>(key);
//   //   if (map == null || map.isEmpty) {
//   //     return def;
//   //   } else {
//   //     return map.cast<K, V>();
//   //   }
//   // }
//   //
//   // ///能够被get的类除基本数据类型、String、List, Map, DateTime, Uint8List外
//   // ///必须实现hive适配器[https://docs.hivedb.dev/#/custom-objects/type_adapters]
//   // static T? get<T>(String key, {T? defaultValue}) {
//   //   return _infoBox.get(key, defaultValue: defaultValue);
//   // }
//   //
//   // ///能够被set的类除基本数据类型、String、List, Map, DateTime, Uint8List外
//   // ///必须实现hive适配器[https://docs.hivedb.dev/#/custom-objects/type_adapters]
//   // static Future<void> set(String key, Object? value) {
//   //   return _infoBox.put(key, value);
//   // }
//   //
//   // static Future<void> putAll(Map<String, Object> entries) {
//   //   return _infoBox.putAll(entries);
//   // }
//   //
//   // static Future<void> remove(String key) {
//   //   return _infoBox.delete(key);
//   // }
//   //
//   // static Future<int> removeAll() {
//   //   return _infoBox.clear();
//   // }
//   //
//   // static Future<int> clearCache() async {
//   //   int count = 0;
//   //   count += await _infoBox.clear();
//   //   return count;
//   // }
//
//
//
// }
//
