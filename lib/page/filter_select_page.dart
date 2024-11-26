import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:view_tabbar/view_tabbar.dart';

import 'home_page.dart';

class FilterSelectPage extends StatelessWidget {
  FilterSelectPage({super.key});

  final pageController = PageController();
  final tabBarController = ViewTabBarController();


  @override
  Widget build(BuildContext context) {
    //用到的homePageController主要是为了将筛选条件进行同步，这样重新打开筛选页面时，可以看到之前的筛选条件
    const filters = [' 筛选源', ' 筛选标签', ' 数额区间'];
    const duration = Duration(milliseconds: 300);
    var homePageController = Get.find<HomePageController>();
    var filterSelectPageController = Get.find<FilterSelectPageController>();
    filterSelectPageController.filterListSource = homePageController.filterListSource;
    filterSelectPageController.amountMin = homePageController.filterAmountMin;
    filterSelectPageController.amountMax = homePageController.filterAmountMax;
    var filterWidgets = [_buildTagFilter(filterSelectPageController),_buildTagFilter(filterSelectPageController), _buildAmountFilter(filterSelectPageController)];
    return Scaffold(
        appBar: AppBar(
          title: const Text('筛选'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  //左侧侧边栏
                  ViewTabBar(
                    pinned: true,
                    itemCount: filters.length,
                    direction: Axis.vertical,
                    pageController: pageController,
                    tabBarController: tabBarController,
                    animationDuration: duration,
                    // 取消动画 -> Duration.zero
                    builder: (context, index) {
                      return ViewTabBarItem(
                        index: index,
                        transform: ScaleTransform(
                          maxScale: 1.2,
                          transform: ColorsTransform(
                            normalColor: const Color(0xff606266),
                            highlightColor: Colors.blue,
                            builder: (context, color) {
                              return Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  left: 10.0,
                                  right: 10.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  filters[index],
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },

                    indicator: StandardIndicator(
                      color: Colors.blue[200],
                      width: 4.0,
                      height: 48.0,
                      bottom: 0,
                    ),
                  ),

                  Expanded(
                    child: PageView.builder(
                      itemCount: filters.length,
                      controller: pageController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return filterWidgets[index];
                      },
                    ),
                  ),
                ],
              ),),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 4),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  ElevatedButton(onPressed: filterSelectPageController.clearFilter, child: const Text("重置")),
                  const SizedBox(width: 16),
                  ElevatedButton(onPressed: () {
                    homePageController.filterListSource = filterSelectPageController.filterListSource;
                    homePageController.filterAmountMin = filterSelectPageController.amountMin;
                    homePageController.filterAmountMax = filterSelectPageController.amountMax;
                    homePageController.buildFilterFuncList();
                    Get.back();
                  }, child: const Text("确定")),
                ],
              ),
            )
          ],
        )
    );
  }


  Widget _buildTagFilter(FilterSelectPageController filterSelectPageController) {
    List<String> choices = [
      'News',
      'Entertainment',
      'Politics',
      'Automotive',
      'Sports',
      'Education',
      'Fashion',
      'Travel',
      'Food',
      'Tech',
      'Science',
      'Arts'
    ];


    return GetBuilder(
        init: filterSelectPageController,
        builder: (_) {
          return InlineChoice<String>.multiple(
            clearable: true,
            value: filterSelectPageController.filterListSource,
            onChanged: filterSelectPageController.setSelectedValue,
            itemCount: choices.length,
            itemBuilder: (state, i) {
              return ChoiceChip(
                selected: filterSelectPageController.filterListSource.contains(
                    choices[i]),
                onSelected: (selected) {
                  if (selected) {
                    filterSelectPageController.filterListSource.add(choices[i]);
                  } else {
                    filterSelectPageController.filterListSource.remove(choices[i]);
                  }
                },
                label: Text(choices[i]),
              );
            },
            listBuilder: ChoiceList.createWrapped(
              spacing: 10,
              runSpacing: 10,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 25,
              ),
            ),
          );
        });
  }

  Widget _buildAmountFilter(FilterSelectPageController filterSelectPageController){
    return GetBuilder(
      init: filterSelectPageController,
      builder: (_){
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: filterSelectPageController.minEditController..text=filterSelectPageController.amountMax == null?"":filterSelectPageController.amountMin.toString(),
                    decoration: const InputDecoration(
                      labelText: '最小金额',
                      hintText: '请输入最小金额',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))//设置只允许输入数字
                    ],
                    onChanged: (value) {
                      filterSelectPageController.amountMin = double.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                const Text("~"),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: filterSelectPageController.maxEditController..text=filterSelectPageController.amountMax == null?"":filterSelectPageController.amountMax.toString(),
                    decoration: const InputDecoration(
                      labelText: '最大金额',
                      hintText: '请输入最大金额',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))//设置只允许输入数字
                    ],
                    onChanged: (value) {
                      filterSelectPageController.amountMax = double.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ],
        );
      },
    );
  }
}

class FilterSelectPageController extends GetxController{
  final maxEditController = TextEditingController();
  final minEditController = TextEditingController();
  List<String> filterListSource = [];
  double? amountMin;
  double? amountMax;

  void clearFilter(){
    filterListSource.clear();
    amountMin = null;
    amountMax = null;
    minEditController.clear();
    maxEditController.clear();
    update();
  }

  void setSelectedValue(List<String> value) {
    filterListSource=value;
    update();
  }

}