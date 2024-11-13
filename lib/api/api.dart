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
    return DataOverview.fromJson(data);
  }

  static void setDataOverview(String key, DataOverview dataOverview, double amountNew) {
    LineChartData data = LineChartData(
      '${DateTime.now().month}-${DateTime.now().day}',
      amountNew,
    );
    dataOverview.chartData.add(data);
    dataOverview.amountLast = dataOverview.amount;
    dataOverview.amount = amountNew;
    _dataOverviewBox.put(key, dataOverview.toJson());

    //TODO: update all amount data,这里还有bug，修正更新策略
    DataOverview all =  getAllAmountData();
    all.amountLast = all.amount;
    all.amount -= dataOverview.amountLast;
    all.amount += amountNew;
    data = LineChartData(
      '${DateTime.now().month}-${DateTime.now().day}',
      all.amount,
    );
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
    return _dataOverviewBox.values.map((e) => DataOverview.fromJson(e)).toList();
  }

  static void setDataOverviews(List<DataOverview> data) {
    _dataOverviewBox.clear();
    for (var element in data) {
      _dataOverviewBox.put(element.source, element.toJson());
    }
  }

  static DataOverview getAllAmountData() {
    return DataOverview.fromJson(_allAmountBox.get('all', defaultValue: ''));
  }

  static void setAllAmountData(DataOverview amount) {
    _allAmountBox.put('all', amount.toJson());
  }
}