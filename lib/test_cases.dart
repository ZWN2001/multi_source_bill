import 'entity/data_overview.dart';
import 'entity/line_chart_data.dart';

class TestCases{

  static DataOverview all =DataOverview(amount: 0, amountLast: 0,chartData: [], source: '总');
  static List<LineChartData> chartData = [
    LineChartData(
       '1',
       100,
    ),
    LineChartData(
       '2',
       200,
    ),
    LineChartData(
       '3',
       300,
    ),
    LineChartData(
       '4',
       400,
    ),
    LineChartData(
       '5',
       500,
    ),
    LineChartData(
       '6',
       600,
    ),
    LineChartData(
       '7',
       700,
    ),
    LineChartData(
       '8',
       800,
    ),
    LineChartData(
       '9',
       900,
    ),
    LineChartData(
       '10',
       1000,
    ),
  ];

  static List<DataOverview> dataOverviews = [

    DataOverview(amount: 1300.0, amountLast: 1100,chartData: chartData, source: 'buff'),
    DataOverview(amount: 1300.0, amountLast: 1100,chartData: chartData, source: '中银'),
    DataOverview(amount: 1300.0, amountLast: 1100,chartData: chartData, source: '工行'),
    DataOverview(amount: 1300.0, amountLast: 1100,chartData: chartData, source: 'yyyp'),
    DataOverview(amount: 1300.0, amountLast: 1100,chartData: chartData, source: 'Steam'),
    DataOverview(amount: 1300.0, amountLast: 1100,chartData: chartData, source: '组件1'),
    DataOverview(amount: 1300.0, amountLast: 1100,chartData: chartData, source: '组件2'),
  ];

  static double chartMin = 100;
  static double chartMax = 1000;
}