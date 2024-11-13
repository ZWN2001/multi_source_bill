import 'package:flutter/material.dart';

import '../../entity/data_overview.dart';
import '../../test_cases.dart';
import '../chart/line_chart.dart';


class DataOverviewCard extends StatelessWidget {
  final DataOverview dataOverview;

  const DataOverviewCard({
    super.key,
    required this.dataOverview,
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
              children: [
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
}
