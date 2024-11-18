import 'package:sqflite/sqflite.dart';

class DB {
  static Database? _database;

  get database => _database;

  static Future<void> initialize() async {
    if(_database == null){
      _database = await openDatabase('mainData.db');
      await _database!.execute('CREATE TABLE IF NOT EXISTS Sources ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'source_name char(64))');
      await _database!.execute('CREATE TABLE IF NOT EXISTS AmountData ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'source_id INTEGER, '
          'date char(16), '
          'amount float )');

      List res = await _database!.query('Sources');
      if(res.isEmpty){
        _database!
            .insert('Sources', {'source_name': '总'});
      }
    }
  }
}
