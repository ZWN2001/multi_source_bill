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

  static Future<List<String>> getSourceNames() async{
    List<String> sources = [];
    List res = await _database!.query('Sources');
    for (Map item in res) {
      sources.add(item['source_name']);
    }
    return sources;
  }

  static Future<Source> getSourceByID(int id) async{
    if(_database == null){
      await DB.initialize();
      _database = DB().database;
    }
    List res = await _database!.query('Sources', where: 'id = ?', whereArgs: [id]);
    return Source(
      id: res[0]['id'],
      sourceName: res[0]['source_name'],
    );
  }

  static Future<void> addSource(Source source) async {
    await _database!.insert('Sources', source.toMap());
  }

  static Future<void> deleteSource(int id) async {
    List<AmountData> amountData = await getAmountData(id);
    await _database!.delete('Sources', where: 'id = ?', whereArgs: [id]);
    await _database!.delete('AmountData', where: 'source_id = ?', whereArgs: [id]);

    int minSourceId = await getMinSourceId();
    for(AmountData item in amountData){
      double amountInAll = await getAmountByDateTime(minSourceId, item.dateTime)??0;
      if(amountInAll - item.amount == 0) {
        await _database!.delete(
            'AmountData', where: 'source_id = ? and date_time = ?',
            whereArgs: [minSourceId, item.dateTime]);
      }else {
        await _database!.update(
            'AmountData', {'amount': amountInAll - item.amount},
            where: 'source_id = ? and date_time = ?',
            whereArgs: [minSourceId, item.dateTime]);
      }
    }
  }

  static Future<int> getMinSourceId(){
    return _database!.query('Sources', columns: ['id']).then((value) => value[0]['id'] as int);
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

  static Future<void> addAmountData(int sourceId, AmountData amountData) async {
    //获取原有的amount并删除
    double? amountOld = await getAmountByDateTime(sourceId, amountData.dateTime);
    //这天没有数据，获取最靠后的那个数据
    if(amountOld == null){
      List<AmountData> amountData = await getAmountData(sourceId);
      List amount = getAmountAndLast(amountData);
      amountOld = amount[0];
    }
    await _database!.delete(
        'AmountData', where: 'source_id = ? and date_time = ?',
        whereArgs: [sourceId, amountData.dateTime]);
    //插入新的amountData
    await _database!.insert(
        'AmountData', {'source_id': sourceId}..addAll(amountData.toMap()));
    //更新总amount
    int minSourceId = await getMinSourceId();
    List<AmountData> amountListOfAll = await getAmountData(minSourceId);
    AmountData last = amountListOfAll.last;
    //如果最后一条数据的日期和新增的数据日期不同，则新增一条数据
    if (last.dateTime != amountData.dateTime) {
      await _database!.insert('AmountData', {
        'source_id': minSourceId,
        'date_time': amountData.dateTime,
        'amount': last.amount - amountOld! + amountData.amount
      });
    } else {
      await _database!.update(
          'AmountData', {'amount': last.amount - amountOld! + amountData.amount},
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

  static Future<List<DataOverview>> getDataOverview() async {
    List<Source> sources = await getSources();
    List<DataOverview> dataOverviews = [];
    DataOverview d;
    for (Source source in sources) {
      d = await getDataOverviewDetailBySource(source);
      dataOverviews.add(d);
    }
    return dataOverviews;
  }

  static Future<DataOverview> getDataOverviewDetailBySource(Source source) async {
    List<AmountData> amountData = await getAmountData(source.id);
    List<String> tags = await getTagsByID(source.id);
    List amount = getAmountAndLast(amountData);
    return DataOverview(
      source: source,
      amount: amount[0],
      amountLast: amount[1],
      chartData: amountData,
      tags: tags,
    );
  }

  static Future<DataOverview> getDataOverviewDetailByID(int sourceID) async {
    Source source = await getSourceByID(sourceID);
    List<AmountData> amountData = await getAmountData(sourceID);
    List<String> tags = await getTagsByID(source.id);
    List amount = getAmountAndLast(amountData);
    return DataOverview(
      source: source,
      amount: amount[0],
      amountLast: amount[1],
      chartData: amountData,
      tags: tags,
    );
  }

  static Future<List<String>> getTags()async{
    List<String> list = [];
    list.addAll(await _database!.query('Tags').then((value) => value.map((e) => e['tag_name'] as String).toSet().toList()));
    return list;
  }

  static Future<List<String>> getTagsByID(int sourceID)async{
    List<String> list = [];
    list.addAll(await _database!.query('Tags',where: 'source_id = ?',whereArgs: [sourceID]).then((value) => value.map((e) => e['tag_name'] as String).toList()));
    return list;
  }

  static Future<void> addTag(int sourceID,String tagName)async{
    //先查询是否已经存在
    List<String> tags = await getTagsByID(sourceID);
    if(tags.contains(tagName)){
      return;
    }
    await _database!.insert('Tags', {'source_id':sourceID,'tag_name':tagName});
  }

  static Future<void> cleanDB()async{
    await _database!.delete('Sources');
    await _database!.delete('AmountData');
    await _database!.delete('Tags');
    await _database!.execute('CREATE TABLE IF NOT EXISTS Sources ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'source_name char(64))');
    await _database!.execute('CREATE TABLE IF NOT EXISTS AmountData ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'source_id INTEGER, '
    'date_time char(16), '
    'amount float )');
    await _database!.execute('CREATE TABLE IF NOT EXISTS Tags ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'source_id INTEGER, '
        'tag_name char(16))');

    await _database!.insert('Sources', {'id':0,'source_name': '总'});
  }

  static Future<void> dbInit() async{
    await  cleanDB();
    await _database!.insert('Sources', {'id':1,'source_name': 'test'});
    await _database!.insert('AmountData', {'source_id':1,'date_time':'01-01','amount': 100});
    await _database!.insert('AmountData', {'source_id':0,'date_time':'01-01','amount': 100});
    await _database!.insert('Tags', {'source_id':1,'tag_name':'test'});
  }

}