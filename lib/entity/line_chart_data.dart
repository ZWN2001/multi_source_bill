class LineChartData {
  LineChartData(this.date, this.amount);

  String date;
  double amount;

  factory LineChartData.fromJson(Map<String, dynamic> json) {
    return LineChartData(
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
}