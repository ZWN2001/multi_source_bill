import 'package:flutter/material.dart';

import '../../entity/data_overview.dart';
import '../../utils/math.dart';
import '../widget/chart/line_chart.dart';


class DataDetailPage extends StatelessWidget{
  final DataOverview dataOverview;

  const DataDetailPage({
    super.key,
    required this.dataOverview,
  });

  @override
  Widget build(BuildContext context) {
    double max = 0;
    double min = 0;
    List<double> result = MathUtils.lineChartDataMinMax(dataOverview.chartData);
    min = result[0];
    max = result[1];
    return Card(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: LineChart(
          chartData: dataOverview.chartData,
          min: min,
          max: max,
          canPop: false,
        ),
      ),
    );
  }
}
