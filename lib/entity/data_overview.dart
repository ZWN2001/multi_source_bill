import 'line_chart_data.dart';

class DataOverview {
  final String source;
  final double amount;
  final double amountLast;
  final List<LineChartData> chartData;

  DataOverview({
    required this.source,
    required this.amount,
    required this.amountLast,
    required this.chartData,
  });

}