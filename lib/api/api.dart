import 'package:hive_flutter/adapters.dart';

import '../entity/data_overview.dart';
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

  static void setDataOverview(String key, DataOverview data) {
    _dataOverviewBox.put(key, data.toJson());
  }

  static void deleteDataOverview(String key) {
    _dataOverviewBox.delete(key);
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
    _allAmountBox.put('all', amount);
  }
}