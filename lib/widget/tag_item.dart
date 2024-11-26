import 'package:flutter/material.dart';

class TagItem extends StatelessWidget {
  final String tag;

  const TagItem({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getColorByName(tag),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Text(
        tag,
        style: const TextStyle(),
      ),
    );
  }

  Color _getColorByName(String tag) {
    // 使用 tag 名哈希取色
    int hash = 0;
    for (int i = 0; i < tag.length; i++) {
      hash = tag.codeUnitAt(i) + ((hash << 5) - hash);
    }
    int index = hash % 0xFFFFFF;

    // 计算 r, g, b 值
    int r = index & 0xFF;
    int g = (index & 0xFF00) >> 8;
    int b = (index & 0xFF0000) >> 16;

    // 确保颜色是浅色，将 RGB 的值限制到较高范围
    r = (r + 128) ~/ 2; // 确保 r 不会过小
    g = (g + 128) ~/ 2; // 确保 g 不会过小
    b = (b + 128) ~/ 2; // 确保 b 不会过小

    return Color.fromARGB(128, r, g, b);
  }
}