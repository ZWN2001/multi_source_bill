import 'package:hive_flutter/adapters.dart';

import '../entity/data_overview.dart';
import '../entity/line_chart_data.dart';
import '../utils/store.dart';

class DataApi{
  static final Box _dataOverviewBox = Store.dataOverviewBox;
  static final Box _allAmountBox = Store.allAmountBox;

  static DataOverview getDataOverview(String key, {String def = ""}) {
    var data = _dataOverviewBox.get(key, defaultValue: def);
    if (data == def) {
      return DataOverview(
        source: key,
        amount: 0,
        amountLast: 0,
        chartData: [],
      );
    }
    final Map<String, dynamic> map = Map<String, dynamic>.from(data);
    return DataOverview.fromJson(map);
  }

  static void setDataOverview(String key, DataOverview dataOverview, double amountNew) {
    LineChartData data = LineChartData(
      '${DateTime.now().month}-${DateTime.now().day}',
      amountNew,
    );
    if(dataOverview.chartData.isNotEmpty){
      LineChartData dataLast = dataOverview.chartData.last;
      if(dataLast.date == data.date){
        dataOverview.chartData.removeLast();
      }
    }
    dataOverview.chartData.add(data);
    dataOverview.amountLast = dataOverview.amount;
    dataOverview.amount = amountNew;
    _dataOverviewBox.put(key, dataOverview.toJson());

    _updateAll(dataOverview, amountNew);
  }

  static void _updateAll(DataOverview dataOverview, double amountNew) {
    DataOverview all =  getAllAmountData();
    all.amountLast = all.amount;
    all.amount -= dataOverview.amountLast;
    all.amount += amountNew;
    LineChartData data = LineChartData(
      '${DateTime.now().month}-${DateTime.now().day}',
      all.amount,
    );
    if(all.chartData.isNotEmpty){
      LineChartData dataLast = all.chartData.last;
      if(dataLast.date == data.date){
        all.chartData.removeLast();
      }
    }
    all.chartData.add(data);
    setAllAmountData(all);
  }

  static void deleteDataOverview(String key) {
    DataOverview data = getDataOverview(key);
    _dataOverviewBox.delete(key);
    DataOverview all = getAllAmountData();
    all.amountLast = all.amount;
    all.amount -= data.amount;
    LineChartData dataLast = all.chartData.last;
    dataLast.amount = all.amount;
    all.chartData.removeLast();
    all.chartData.add(dataLast);
    setAllAmountData(all);
  }


  static List<DataOverview> getDataOverviews() {
    if (_dataOverviewBox.isEmpty) {
      return [];
    }
    return _dataOverviewBox.values.map((e) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(e as Map);
      return DataOverview.fromJson(data);
    }).toList();
  }

  static void setDataOverviews(List<DataOverview> data) {
    _dataOverviewBox.clear();
    for (var element in data) {
      _dataOverviewBox.put(element.source, element.toJson());
    }
  }

  static DataOverview getAllAmountData() {
    final Map<String, dynamic> data = Map<String, dynamic>.from(_allAmountBox.get('all') as Map);
    return DataOverview.fromJson(data);
  }

  static void setAllAmountData(DataOverview amount) {
    _allAmountBox.put('all', amount.toJson());
  }
}