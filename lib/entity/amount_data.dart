class AmountData {
  AmountData(this.dateTime, this.amount);

  String dateTime;
  double amount;

  factory AmountData.fromJson(Map<String, dynamic> json) {
    return AmountData(
      json['date_time'],
      json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_time': dateTime,
      'amount': amount,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'date_time': dateTime,
      'amount': amount,
    };
  }

  @override
  String toString() {
    return 'LineChartData{date_time: $dateTime, amount: $amount}';
  }
}