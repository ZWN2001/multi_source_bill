import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../entity/data_overview.dart';
import '../../utils/math.dart';
import '../api/db_api.dart';
import '../widget/chart/line_chart.dart';


class DataDetailPage extends StatefulWidget{
  final int id;

  const DataDetailPage({
    super.key,
    required this.id,
  });

  @override
  DataDetailPageState createState() => DataDetailPageState();
}

class DataDetailPageState extends State<DataDetailPage>{
  DataOverview? dataOverview;
  late double max;
  late double min;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: dataOverview==null ? const Text('') : Text(dataOverview!.source.sourceName),
      ),
      body: dataOverview==null ? const Center(child: CircularProgressIndicator(),) :Card(
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: LineChart(
            chartData: dataOverview!.chartData,
            min: min,
            max: max,
            canPop: false,
          ),
        ),
      ),
    );
  }

  Future<void> initData() async {
    //获取数据
    dataOverview = await DBApi.getDataOverviewDetailByID(widget.id);
    List<double> result = MathUtils.lineChartDataMinMax(dataOverview!.chartData);
    min = result[0];
    max = result[1];
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }
}
