import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddDataSourcePage extends StatefulWidget {
  const AddDataSourcePage({super.key});

  @override
  AddDataSourcePageState createState() => AddDataSourcePageState();
}

class AddDataSourcePageState extends State<AddDataSourcePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加收支源'),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: '收支源名称',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: '收支源描述',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('保存'),
            )
          ],
        ),
      ),
    );
  }
}