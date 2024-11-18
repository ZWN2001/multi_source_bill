import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../entity/data_overview.dart';
import '../../utils/math.dart';
import '../chart/line_chart.dart';

class DataOverviewCard extends StatelessWidget{
  final DataOverview dataOverview;
  final bool enableEdit;
  final Function(DataOverview)? deleteCallback;
  final Function(DataOverview)? updateCallback;

  const DataOverviewCard({
    super.key,
    required this.dataOverview,
    required this.enableEdit,
    this.deleteCallback ,
    this.updateCallback,
  });

  @override
  Widget build(BuildContext context) {
    double max = 0;
    double min = 0;
    List<double> result = MathUtils.lineChartDataMinMax(dataOverview.chartData);
    min = result[0];
    max = result[1];
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
                  dataOverview.source.sourceName,
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
                    //TODO DataApi.deleteDataOverview(dataOverview.source);
                    deleteCallback!(dataOverview);
                  }
                }, icon: const Icon(Icons.delete, color: Colors.black,)),
                IconButton(onPressed: () async {
                  //chartData增加一条记录
                  double amount = 0;
                  if(context.mounted){
                    amount = await showUpdateDialog(context) ?? -1;
                  }
                  if(amount == -1){
                    return;
                  }

                  //TODO DataApi.setDataOverview(dataOverview.source,dataOverview,amount);

                  List<double> result = MathUtils.lineChartDataMinMax(dataOverview.chartData);
                  min = result[0];
                  max = result[1];
                  updateCallback!(dataOverview);
                  // setState((/) {});
                }, icon: const Icon(Icons.add, color: Colors.black,)),
              ]:[
                Text(
                  dataOverview.source.sourceName,
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
                min: min,
                max: max,
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

  Future<double?> showUpdateDialog(context) async {
    TextEditingController controller = TextEditingController();
    double? b = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("添加一条记录"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: '余额',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("取消"),
            ),
            TextButton(
                onPressed: () {
                  double amount = -1;
                  if (controller.text.isNotEmpty) {
                    amount = double.parse(controller.text);
                  }
                  Navigator.of(context).pop(amount);
                },
                child: const Text("确定")),
          ],
        );
      },
    );
    return b;
  }
}
