import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:multi_source_bill/utils/keep_alive.dart';

import '../api/api.dart';
import '../entity/data_overview.dart';
import '../widget/cards/data_overview_card.dart';

class HomePage extends StatefulWidget {
  final ZoomDrawerController controller;

  const HomePage({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  late ZoomDrawerController zoomDrawerController;
  List<DataOverview> dataOverviews = [];
  late DataOverview allAmount;

  @override
  void initState() {
    super.initState();
    zoomDrawerController = widget.controller;
    dataOverviews.addAll(DataApi.getDataOverviews());
    allAmount = DataApi.getAllAmountData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: true,
              snap: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                margin: const EdgeInsets.fromLTRB(16, 64, 16, 0),
                child: DataOverviewCard(
                  dataOverview: allAmount,
                  enableEdit: false,
                ),
              )),
            )
          ];
        },
        body: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return KeepAliveWrapper(
                child: SizedBox(
              height: 240,
              child: DataOverviewCard(
                dataOverview: dataOverviews[index],
                enableEdit: true,
                deleteCallback: () {
                  refresh();
                },
                updateCallback: () {
                  refresh();
                },
              ),
            ));
          },
          itemCount: dataOverviews.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await showDialogFunction(context);
          if (result) {
            refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void refresh(){
    setState(() {
      dataOverviews.clear();
      dataOverviews.addAll(DataApi.getDataOverviews());
      allAmount = DataApi.getAllAmountData();
    });
  }

  Future<bool> showDialogFunction(context) async {
    TextEditingController controller = TextEditingController();
    bool b = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("提示"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: '收支源名称',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("取消"),
            ),
            TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    DataOverview d = DataOverview(
                      source: controller.text,
                      amount: 0,
                      amountLast: 0,
                      chartData: [],
                    );
                    DataApi.setDataOverview(controller.text, d, 0);
                  }
                  Navigator.of(context).pop(true);
                },
                child: const Text("确定")),
          ],
        );
      },
    );
    return b;
  }
}
