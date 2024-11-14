import 'line_chart_data.dart';

class DataOverview {
  final String source;
  double amount;
  double amountLast;
  final List<LineChartData> chartData;

  DataOverview({
    required this.source,
    required this.amount,
    required this.amountLast,
    required this.chartData,
  });

  factory DataOverview.fromJson(Map<String, dynamic> json) {
    return DataOverview(
      source: json['source'],
      amount: json['amount'],
      amountLast: json['amountLast'],
      chartData: (json['chartData'] as List).map((e) => LineChartData.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'amount': amount,
      'amountLast': amountLast,
      'chartData': chartData.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'DataOverview{source: $source, amount: $amount, amountLast: $amountLast}';
  }

}