import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../entity/data_overview.dart';
import '../../test_cases.dart';
import '../chart/line_chart.dart';


class DataOverviewCard extends StatelessWidget {
  final DataOverview dataOverview;
  final bool enableEdit;
  final Function? deleteCallback;
  final Function? updateCallback;

  const DataOverviewCard({
    super.key,
    required this.dataOverview,
    required this.enableEdit,
    this.deleteCallback ,
    this.updateCallback,
  });

  @override
  Widget build(BuildContext context) {
    double trending = dataOverview.amount - dataOverview.amountLast;
    return Card(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: enableEdit?[
                Text(
                  dataOverview.source,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 36,),
                Icon(
                  trending > 0 ? Icons.trending_up : Icons.trending_down,
                  color: trending > 0 ? Colors.red : Colors.green,
                ),
                Text(
                  ' ${trending.abs()} ',
                  style: TextStyle(
                    fontSize: 18,
                    color: trending > 0 ? Colors.red : Colors.green,
                  ),
                ),
                Expanded(child: Container()),
                IconButton(onPressed: () async {
                  bool b = await showDialogFunction(context);
                  if (b) {
                    DataApi.deleteDataOverview(dataOverview.source);
                    deleteCallback!();
                  }
                }, icon: const Icon(Icons.delete, color: Colors.black,)),
              ]:[
                Text(
                  dataOverview.source,
                  style: const TextStyle(fontSize: 18),
                ),
                Expanded(child: Container()),
                Icon(
                  trending > 0 ? Icons.trending_up : Icons.trending_down,
                  color: trending > 0 ? Colors.red : Colors.green,
                ),
                Text(
                  ' ${trending.abs()} ',
                  style: TextStyle(
                    fontSize: 18,
                    color: trending > 0 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            Text(
              '当前总额: ${dataOverview.amount}',
              style: const TextStyle(fontSize: 24),
            ),
            Expanded(
              child: LineChart(
                chartData: dataOverview.chartData,
                min: TestCases.chartMin,
                max: TestCases.chartMax,
                canPop: false,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> showDialogFunction(context) async {
    bool b = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("确认删除"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("取消"),
            ),
            TextButton(onPressed: () {
              Navigator.of(context).pop(true);
            }, child: const Text("确定")),
          ],
        );
      },
    );
    return b;
  }
}
