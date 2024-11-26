import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_source_bill/api/db_api.dart';
import 'package:multi_source_bill/widget/tag_item.dart';

import '../../entity/amount_data.dart';
import '../../entity/data_overview.dart';
import '../../page/data_detail_page.dart';
import '../../utils/math.dart';
import '../chart/line_chart.dart';

class DataOverviewCard extends StatelessWidget {
  final DataOverview dataOverview;
  final bool enableEdit;
  final Function(DataOverview)? deleteCallback;
  final Function(DataOverview)? updateCallback;

  const DataOverviewCard({
    super.key,
    required this.dataOverview,
    required this.enableEdit,
    this.deleteCallback,
    this.updateCallback,
  });

  @override
  Widget build(BuildContext context) {
    double max = 0;
    double min = 0;
    List<double> result = MathUtils.lineChartDataMinMax(dataOverview.chartData);
    min = result[0];
    min = result[1];
    double trending = dataOverview.amount - dataOverview.amountLast;
    return Card(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //标题与小功能
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dataOverview.source.sourceName,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  width: 36,
                ),
                Expanded(child: Container()),
                //总看板不允许编辑
                ...enableEdit
                    ? [
                  IconButton(
                      onPressed: () async {
                        bool b = await _showDialogFunction(context);
                        if (b) {
                          DBApi.deleteSource(dataOverview.source.id);
                          deleteCallback!(dataOverview);
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () async {
                        await _tagAdd(context);
                        updateCallback!(dataOverview);
                      },
                      icon: const Icon(
                        Icons.tag,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () async {
                        await _dataAdd(context);
                        List<double> result =
                        MathUtils.lineChartDataMinMax(
                            dataOverview.chartData);
                        min = result[0];
                        max = result[1];
                        updateCallback!(dataOverview);
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      )),
                ]
                    : [],
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DataDetailPage(id: dataOverview.source.id)));
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                    ))
              ],
            ),
            //amount数据
            Row(
              children: [
                Text(
                  '当前总额: ${dataOverview.amount}',
                  style: const TextStyle(fontSize: 24),
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
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
            //标签
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dataOverview.tags
                    .map((e) => TagItem(tag: e))
                    .toList(),
              ),
            ),
            //图表
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

  Future<void> _dataAdd(BuildContext context) async {
    //chartData增加一条记录
    double? amount = 0;
    if (context.mounted) {
      amount = await _showUpdateDialog(context);
    }
    if (amount == null) {
      return;
    }

    await DBApi.addAmountData(
        dataOverview.source.id,
        AmountData(
          '${DateTime.now().month}-${DateTime.now().day}',
          amount,
        ));
  }

  Future<void> _tagAdd(BuildContext context) async {
    //chartData增加一条记录
    String? tag = '';
    if (context.mounted) {
      tag = await _showAddTagDialog(context);
    }
    if (tag == null) {
      return;
    }
    DBApi.addTag(dataOverview.source.id, tag);

  }

  Future<bool> _showDialogFunction(context) async {
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
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("确定")),
          ],
        );
      },
    );
    return b;
  }

  Future<double?> _showUpdateDialog(context) async {
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
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')) //设置只允许输入数字
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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

  Future<String?> _showAddTagDialog(context) async {
    TextEditingController controller = TextEditingController();
    String? b = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("添加一个Tag"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Tag',
            ),
            maxLength: 16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
                onPressed: () {
                  String tag = '';
                  if (controller.text.isNotEmpty) {
                    tag = controller.text;
                  }
                  Navigator.of(context).pop(tag);
                },
                child: const Text("确定")),
          ],
        );
      },
    );
    return b;
  }
}
