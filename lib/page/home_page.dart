import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:multi_source_bill/api/db_api.dart';

import '../entity/data_overview.dart';
import '../entity/source.dart';
import '../utils/db.dart';
import '../widget/cards/data_overview_card.dart';
import 'filter_select_page.dart';

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
          builder: (_) {
            return Column(
              children: [
                Row(
                  children: [
                    DropdownMenu<String>(
                      inputDecorationTheme: InputDecorationTheme(
                        isDense: false,
                        contentPadding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                        constraints: BoxConstraints.tight(
                            const Size.fromHeight(44)),
                        border: InputBorder.none,
                      ),
                      // menuHeight: 30,
                      initialSelection: homePageController.selectedFilter,
                      onSelected: homePageController.onSelect,
                      dropdownMenuEntries: _buildMenuList(
                          homePageController.filterData),
                    ),
                    Expanded(child: Container()),
                    //筛选
                    IconButton(
                      icon: homePageController.filterFuncList.isEmpty
                          ? const Icon(Icons.filter_alt)
                          : const Icon(
                          Icons.filter_alt_sharp, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => FilterSelectPage()));
                      },
                    ),
                    const SizedBox(width: 16),
                  ],
                ),

                SingleChildScrollView(
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
                          updateCallback: (DataOverview dataOverview) {
                            homePageController.onUpdateCall(
                                index, dataOverview);
                          },
                        ),
                      );
                    },
                    itemCount: homePageController.dataOverviews.length,
                  ),
                )
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await _showDialogFunction(context);
          if (result) {
            homePageController.refreshData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }


  Future<bool> _showDialogFunction(context) async {
    TextEditingController controller = TextEditingController();
    bool b = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("提示"),
          content: TextField(
            controller: controller,
            maxLength: 64,
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
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    Source s = Source(
                      sourceName: controller.text, id: 0,
                    );
                    await DBApi.addSource(s);
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: const Text("确定")),
          ],
        );
      },
    );
    return b;
  }

  List<DropdownMenuEntry<String>> _buildMenuList(List<String> data) {
    return data.map((String value) {
      return DropdownMenuEntry<String>(value: value, label: value);
    }).toList();
  }
}

class HomePageController extends GetxController{
  static HomePageController get to => Get.find();
  RxList<DataOverview> dataOverviews = <DataOverview>[].obs;
  final List<DataOverview> defaultDataOverviews = [];


  final List<String> filterData = ['默认', '涨幅升序', '涨幅降序', '总额升序', '总额降序'];
  //对应排序规则的排序方法
  final Map<String, Function> filterMethods = {
    '涨幅升序': (DataOverview a, DataOverview b) => (a.amount - a.amountLast).compareTo(b.amount - b.amountLast),
    '涨幅降序': (DataOverview a, DataOverview b) => (b.amount - b.amountLast).compareTo(a.amount - a.amountLast),
    '总额升序': (DataOverview a, DataOverview b) => a.amount.compareTo(b.amount),
    '总额降序': (DataOverview a, DataOverview b) => b.amount.compareTo(a.amount),
  };
  String selectedFilter = '默认';

  final List<Function> filterFuncList = [];
  List<String> filterListSource = [];
  double? filterAmountMin;
  double? filterAmountMax;

  @override
  Future<void> onInit() async{
    super.onInit();
    await DB.initialize();
    dataOverviews.addAll(await DBApi.getDataOverview());
    defaultDataOverviews.addAll(dataOverviews);
    update();
  }

  Future<void> refreshData() async {
    dataOverviews.clear();
    dataOverviews.addAll(await DBApi.getDataOverview());
    update();
  }

  void onDeleteCall(int index){
    refreshData();
  }

  Future<void> onUpdateCall(int index,DataOverview dataOverview) async {
    refreshData();
  }

  void onSelect(String? value) {
    selectedFilter = value!;
    if(selectedFilter == '默认'){
      dataOverviews.clear();
      dataOverviews.addAll(defaultDataOverviews);
    }else{
      dataOverviews.sort((a, b) => filterMethods[selectedFilter]!(a, b));
    }

    update();
  }

  void buildFilterFuncList(){
    filterFuncList.clear();
    if(filterListSource.isNotEmpty){
      filterFuncList.add((DataOverview dataOverview) => filterListSource.contains(dataOverview.source.sourceName));
    }
    if(filterAmountMin != null){
      filterFuncList.add((DataOverview dataOverview) => dataOverview.amount >= filterAmountMin!);
    }
    if(filterAmountMax != null){
      filterFuncList.add((DataOverview dataOverview) => dataOverview.amount <= filterAmountMax!);
    }
  }
}
