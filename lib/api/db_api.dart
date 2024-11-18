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
        item['date'],
        item['amount'],
      ));
    }
    return amountData;
  }

  static Future<List<DataOverview>> getDataOverview() async {
    List<Source> sources = await getSources();
    List<DataOverview> dataOverviews = [];
    for (Source source in sources) {
      List<AmountData> amountData = await getAmountData(source.id, limit: 5);
      List amount = getAmount(amountData);
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
  static List getAmount(List<AmountData> amountData){
    List<double> res = [];
    double amount = 0;
    double amountLast = 0;
    //amountData按时间排序
    amountData.sort((a, b) => a.date.compareTo(b.date));
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

  static void addSource(Source source){
    _database!.insert('Sources', source.toMap());
  }

  static void deleteSource(int id){
    _database!.delete('Sources', where: 'id = ?', whereArgs: [id]);
    _database!.delete('AmountData', where: 'source_id = ?', whereArgs: [id]);
  }

  static void addAmountData(int sourceId, AmountData amountData){
    _database!.insert('AmountData', amountData.toMap()..['source_id'] = sourceId);
  }

}