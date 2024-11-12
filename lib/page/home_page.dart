import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';



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
    return Container(
      color: Colors.pink,
      child: Center(
        child: ElevatedButton(
          onPressed: (){
            zoomDrawerController.toggle?.call();
            setState(() {});
          },
          child: Text("Toggle Drawer"),
        ),
      ),
    );
  }

}


