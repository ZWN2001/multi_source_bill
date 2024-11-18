class AmountData {
  AmountData(this.date, this.amount);

  String date;
  double amount;

  factory AmountData.fromJson(Map<String, dynamic> json) {
    return AmountData(
      json['date'],
      json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'amount': amount,
    };
  }

  @override
  String toString() {
    return 'LineChartData{date: $date, amount: $amount}';
  }
}