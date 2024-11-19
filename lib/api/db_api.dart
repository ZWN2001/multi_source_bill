import 'package:flutter/foundation.dart';
import 'package:multi_source_bill/entity/amount_data.dart';
import 'package:multi_source_bill/entity/data_overview.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/source.dart';
import '../utils/db.dart';

class DBApi{
  static Database? _database = DB().database;

  static Future<List<Source>> getSources() async{
    if(_database == null){
      await DB.initialize();
      _database = DB().database;
    }
    List<Source> sources = [];
    List res = await _database!.query('Sources');
    for (Map item in res) {
      sources.add(Source(
        id: item['id'],
        sourceName: item['source_name'],
      ));
    }

    return sources;
  }

  static Future<List<AmountData>> getAmountData(int sourceId,{int? limit}) async {
    if(_database == null){
      await DB.initialize();
      _database = DB().database;
    }
    List<AmountData> amountData = [];
    List res;
    //若limit不为空，则查询指定数量的前limit个数据
    if(limit != null){
      res = await _database!.query('AmountData', where: 'source_id = ?', whereArgs: [sourceId], limit: limit);
    }else{
      res = await _database!.query('AmountData', where: 'source_id = ?', whereArgs: [sourceId]);
    }
    for (Map item in res) {
      amountData.add(AmountData(
        item['date_time'],
        item['amount'],
      ));
    }
    return amountData;
  }

  static Future<List<DataOverview>> getDataOverview() async {
    List<Source> sources = await getSources();
    print('sources: $sources');
    List<DataOverview> dataOverviews = [];
    for (Source source in sources) {
      List<AmountData> amountData = await getAmountData(source.id, limit: 5);
      List amount = getAmountAndLast(amountData);
      dataOverviews.add(DataOverview(
        source: source,
        amount: amount[0],
        amountLast: amount[1],
        chartData: amountData,
      ));
    }
    return dataOverviews;
  }

  //获取amount和amountLast
  static List getAmountAndLast(List<AmountData> amountData){
    List<double> res = [];
    double amount = 0;
    double amountLast = 0;
    //amountData按时间排序
    amountData.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    if(amountData.isNotEmpty){
      amount = amountData.last.amount;
      if(amountData.length > 1){
        amountLast = amountData[amountData.length - 2].amount;
      }
    }
    res.add(amount);
    res.add(amountLast);
    return res;
  }

  static Future<void> addSource(Source source) async {
    await _database!.insert('Sources', source.toMap());
  }

  static Future<void> deleteSource(int id) async {
    List<AmountData> amountData = await getAmountData(id);
    await _database!.delete('Sources', where: 'id = ?', whereArgs: [id]);
    await _database!.delete('AmountData', where: 'source_id = ?', whereArgs: [id]);
    //TODO:删除source时，更新总amount
    int minSourceId = await getMinSourceId();
    for(AmountData item in amountData){
      double amountInAll = await getAmountByDateTime(minSourceId, item.dateTime)??0;
      if(amountInAll - item.amount == 0) {
        await _database!.delete(
            'AmountData', where: 'source_id = ? and date_time = ?',
            whereArgs: [minSourceId, item.dateTime]);
      }else{
        await _database!.update('AmountData', {'amount': amountInAll - item.amount}, where: 'source_id = ? and date_time = ?', whereArgs: [minSourceId, item.dateTime]);
      }
    }
  }

  static Future<void> addAmountData(int sourceId, AmountData amountData) async {
    //获取原有的amount并删除
    double amountOld = await getAmountByDateTime(sourceId, amountData.dateTime)??0;
    await _database!.delete(
        'AmountData', where: 'source_id = ? and date_time = ?',
        whereArgs: [sourceId, amountData.dateTime]);
    //插入新的amountData
    await _database!.insert(
        'AmountData', {'source_id': sourceId}..addAll(amountData.toMap()));
    //更新总amount
    int minSourceId = await getMinSourceId();
    print('minSourceId: $minSourceId');
    double? amountInAll = await getAmountByDateTime(
        minSourceId, amountData.dateTime);
    if (amountInAll == null) {
      await _database!.insert('AmountData', {
        'source_id': minSourceId,
        'date_time': amountData.dateTime,
        'amount': amountData.amount
      });
    } else {
      await _database!.update(
          'AmountData', {'amount': amountInAll - amountOld + amountData.amount},
          where: 'source_id = ? and date_time = ?',
          whereArgs: [minSourceId, amountData.dateTime]);
    }
  }

  static Future<double?> getAmountByDateTime(int sourceId, String dateTime){
    return _database!.query('AmountData', where: 'source_id = ? and date_time = ?', whereArgs: [sourceId, dateTime]).then((value){
      if(value.isEmpty){
        return null;
      }else{
        return value[0]['amount'] as double;
      }
    });
  }

  static Future<void> deleteAmountData(int sourceId, String dateTime) async {
    try{
      await _database!.delete('AmountData', where: 'source_id = ? and date_time = ?', whereArgs: [sourceId, dateTime]);
    }catch(e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<int> getMinSourceId(){
    return _database!.query('Sources', columns: ['id']).then((value) => value[0]['id'] as int);
  }

  static void cleanDB()async{
    _database!.delete('Sources');
    _database!.delete('AmountData');
    _database!.execute('CREATE TABLE IF NOT EXISTS Sources ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'source_name char(64))');
    _database!.execute('CREATE TABLE IF NOT EXISTS AmountData ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'source_id INTEGER, '
    'date_time char(16), '
    'amount float )');

    _database!.insert('Sources', {'id':0,'source_name': '总'});
  }

}