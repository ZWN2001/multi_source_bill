import 'package:multi_source_bill/entity/source.dart';

import 'amount_data.dart';

class DataOverview {
  final Source source;
  double amount;
  double amountLast;
  final List<AmountData> chartData;

  DataOverview({
    required this.source,
    required this.amount,
    required this.amountLast,
    required this.chartData,
  });

  factory DataOverview.fromJson(Map<String, dynamic> json) {
    return DataOverview(
      source: Source.fromJson(json['source']),
      amount: json['amount'],
      amountLast: json['amountLast'],
      chartData: (json['chartData'] as List).map((e){
        final Map<String, dynamic> data = Map<String, dynamic>.from(e as Map);
        return AmountData.fromJson(data);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source.toJson(),
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