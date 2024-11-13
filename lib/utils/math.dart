import '../entity/line_chart_data.dart';

class MathUtils{
  double min(List<double> list){
    double min = list[0];
    for (int i = 1; i < list.length; i++) {
      if (list[i] < min) {
        min = list[i];
      }
    }
    return min;
  }

  double max(List<double> list){
    double max = list[0];
    for (int i = 1; i < list.length; i++) {
      if (list[i] > max) {
        max = list[i];
      }
    }
    return max;
  }

  List<double> lineChartDataMinMax(List<LineChartData> list){
    List<double> result = [];
    List<double> data = [];
    for (int i = 0; i < list.length; i++) {
      data.add(list[i].amount);
    }
    result.add(min(data));
    result.add(max(data));
    return result;
  }
}