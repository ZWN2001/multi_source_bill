import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../api/api.dart';
import '../entity/data_overview.dart';
import '../widget/cards/data_overview_card.dart';

class HomePage extends StatelessWidget {
  final ZoomDrawerController controller;

  const HomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    var homePageController = Get.find<HomePageController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("首页"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            controller.toggle!();
          },
        ),
      ),
      body: GetBuilder(
        init: homePageController,
          builder: (_){
        return SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 240,
                child: DataOverviewCard(
                  dataOverview: homePageController.dataOverviews[index],
                  enableEdit: index != 0,
                  deleteCallback: (DataOverview dataOverview) {
                    homePageController.onDeleteCall(index);
                  },
                  // updateCallback: (DataOverview dataOverview) {
                  //   // dataOverviews[index] = dataOverview;
                  // },
                ),
              );
            },
            itemCount: homePageController.dataOverviews.length,
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await showDialogFunction(context);
          if (result) {
            homePageController.refreshData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
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

class HomePageController extends GetxController{
  static HomePageController get to => Get.find();
  RxList<DataOverview> dataOverviews = <DataOverview>[].obs;
  late DataOverview allAmount;

  @override
  void onInit() {
    super.onInit();
      allAmount = DataApi.getAllAmountData();
      dataOverviews.add(allAmount);
      dataOverviews.addAll(DataApi.getDataOverviews());
  }

  void refreshData(){
    dataOverviews.clear();
    allAmount = DataApi.getAllAmountData();
    dataOverviews.add(allAmount);
    dataOverviews.addAll(DataApi.getDataOverviews());
    update();
  }

  void onDeleteCall(int index){
    dataOverviews.removeAt(index);
    update();
  }

}
