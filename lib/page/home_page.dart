import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:multi_source_bill/utils/keep_alive.dart';

import '../cards/data_overview_card.dart';
import '../test_cases.dart';



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
  @override
  void initState() {
    super.initState();
    zoomDrawerController = widget.controller;

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                    child: DataOverviewCard(dataOverview: TestCases.dataOverview),
                  )
              ),
            )
          ];
        },
        body: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return KeepAliveWrapper(child: SizedBox(
              height: 200,
              child: DataOverviewCard(dataOverview: TestCases.dataOverviews[index]),
            ));
          },
          itemCount: TestCases.dataOverviews.length,
        ),
      ),

    );

  }

}


