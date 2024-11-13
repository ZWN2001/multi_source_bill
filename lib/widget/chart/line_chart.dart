import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../entity/line_chart_data.dart';

class LineChart extends StatelessWidget {
  final List<LineChartData> chartData;
  final double min;
  final double max;
  final bool canPop;

  const LineChart(
      {super.key,
      required this.chartData,
      required this.min,
      required this.max,
      required this.canPop});

  @override
  Widget build(BuildContext context) {
    return chartData.isEmpty
        ? const Center(
            child: Text(
              '暂无数据',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          )
        : Column(
      mainAxisSize: MainAxisSize.min,
            children: [
              //返回键
              if (canPop)
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              Expanded(child: _buildDashedLineChart())
            ],
          );
  }

  SfCartesianChart _buildDashedLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: const Legend(
          isVisible: false,
          overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: const CategoryAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(width: 0),
          labelPlacement: LabelPlacement.onTicks,
          interval: 2
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        minimum: double.parse(min.toString()),
        maximum: double.parse(max.toString()),
        labelFormat: '{value}元',
      ),
      series: _getDashedLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<LineSeries<LineChartData, String>> _getDashedLineSeries() {
    return <LineSeries<LineChartData, String>>[
      LineSeries<LineChartData, String>(
        animationDuration: 2500,
        dashArray: const <double>[15, 3, 3, 3],
        dataSource: chartData,
        xValueMapper: (LineChartData sales, _) => sales.date,
        yValueMapper: (LineChartData sales, _) => sales.amount,
        width: 2,
        name: '金额',
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 10)),
        markerSettings: const MarkerSettings(isVisible: true),
      )
    ];
  }
}
